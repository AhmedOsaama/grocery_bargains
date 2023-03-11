import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaav/config/themes/app_theme.dart';
import 'package:swaav/providers/google_sign_in_provider.dart';
import 'package:swaav/providers/products_provider.dart';
import 'package:swaav/services/dynamic_link_service.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/view/screens/main_screen.dart';
import 'package:swaav/view/screens/chatlist_view_screen.dart';
import 'package:swaav/view/screens/onboarding_screen.dart';
import 'package:swaav/view/screens/register_screen.dart';
import 'package:swaav/view/screens/splash_screen.dart';

import 'firebase_options.dart';

//To apply keys for the various languages used.
// flutter pub run easy_localization:generate -S ./assets/translations -f keys -o locale_keys.g.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var pref = await SharedPreferences.getInstance();
  var isRemembered = pref.getBool("rememberMe") ?? false;

  final String path = await DynamicLinkService().handleDynamicLinks();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
          ChangeNotifierProvider<ProductsProvider>(create: (_) => ProductsProvider()),
        ],
        child: MyApp(
          dynamicLinkPath: path,
            isRemembered: isRemembered
        ),
      )));
}

class MyApp extends StatelessWidget {
  final String dynamicLinkPath;
  final bool isRemembered;
  const MyApp({super.key, required this.dynamicLinkPath, required this.isRemembered});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BargainB',
      // theme: appTheme(),
      theme: ThemeData(
        canvasColor: lightPurple
      ),
      debugShowCheckedModeBanner: false,
      home: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, _) {
            if(!isRemembered) return RegisterScreen();
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    // return DynamicLinkService()
                    //     .getStartPage(dynamicLinkPath); //case 1
                    return OnBoardingScreen();
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
