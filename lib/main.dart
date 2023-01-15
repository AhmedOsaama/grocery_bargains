import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swaav/config/themes/app_theme.dart';
import 'package:swaav/providers/google_sign_in_provider.dart';
import 'package:swaav/services/dynamic_link_service.dart';
import 'package:swaav/view/screens/home_screen.dart';
import 'package:swaav/view/screens/list_view_screen.dart';
import 'package:swaav/view/screens/register_screen.dart';
import 'package:swaav/view/screens/splash_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final String path = await DynamicLinkService().handleDynamicLinks();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
        ],
        child: MyApp(
          dynamicLinkPath: path,
        ),
      )));
}

class MyApp extends StatelessWidget {
  final String dynamicLinkPath;
  const MyApp({super.key, required this.dynamicLinkPath});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWAAV',
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
      home: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, _) {
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    print("LOGGED IN");
                    return DynamicLinkService()
                        .getStartPage(dynamicLinkPath); //case 1
                  }
                  return RegisterScreen();
                });
          }),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
