import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/chatlists_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'providers/chatlists_provider.dart';
import 'providers/google_sign_in_provider.dart';
import 'providers/products_provider.dart';
import 'services/dynamic_link_service.dart';
import 'utils/app_colors.dart';
import 'view/screens/main_screen.dart';
import 'view/screens/onboarding_screen.dart';
import 'view/screens/register_screen.dart';

//To apply keys for the various languages used.
// flutter pub run easy_localization:generate -S ./assets/translations -f keys -o locale_keys.g.dart
@pragma('vm:entry-point')
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var notificationMessage = await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onMessageOpenedApp.listen((message) { //TODO: move this to home screen and listen for the background lifecycle event and go to the page accordingly
    print("onMessageOpenedApp: " + message.data['listId']);
    print("onMessageOpenedApp title: " + message.notification!.title!);
    print("onMessageOpenedApp body: " + message.notification!.body!);
    notificationMessage = message;
  });

  var pref = await SharedPreferences.getInstance();
  var isRemembered = pref.getBool("rememberMe") ?? false;
  var isFirstTime = pref.getBool("firstTime") ?? true;

  if(isFirstTime) {
      // var consentStatus = await GdprDialog.instance.getConsentStatus();
      // print(consentStatus.name);
      // if(consentStatus == ConsentStatus.required) {
    // GdprDialog.instance.showDialog(isForTest: true,testDeviceId: '07EB556D7EBA611E395AAF54AB12E08C')
    //     .then((onValue) {
    //   print('result === $onValue');
    // });
      // }
    pref.setBool("firstTime", false);
  }
  final String path = await DynamicLinkService().handleDynamicLinks();

  await SentryFlutter.init(
        (options) {
      // options.dsn = 'https://9ac26c76cf0349d59d82538e91345ada@o4504179587940352.ingest.sentry.io/4504831610126336' ;
      options.dsn = kReleaseMode ? 'https://9ac26c76cf0349d59d82538e91345ada@o4504179587940352.ingest.sentry.io/4504831610126336' : '' ;
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
            ChangeNotifierProvider<ProductsProvider>(create: (_) => ProductsProvider()),
            ChangeNotifierProvider<ChatlistsProvider>(create: (_) => ChatlistsProvider()),
          ],
          child: MyApp(
            notificationMessage: notificationMessage,
              dynamicLinkPath: path,
              isRemembered: isRemembered,
              isFirstTime: isFirstTime
          ),
        ))),
  );

  // runApp(EasyLocalization(
  //     supportedLocales: const [Locale('ar'), Locale('en')],
  //     path: 'assets/translations',
  //     fallbackLocale: const Locale('en'),
  //     child: MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
  //         ChangeNotifierProvider<ProductsProvider>(create: (_) => ProductsProvider()),
  //         ChangeNotifierProvider<ChatlistsProvider>(create: (_) => ChatlistsProvider()),
  //       ],
  //       child: MyApp(
  //           dynamicLinkPath: path,
  //           isRemembered: isRemembered,
  //           isFirstTime: isFirstTime
  //       ),
  //     )));
}

class MyApp extends StatelessWidget {
  final String dynamicLinkPath;
  final RemoteMessage? notificationMessage;
  final bool isRemembered;
  final bool isFirstTime;
  const MyApp({super.key, required this.dynamicLinkPath, required this.isRemembered, required this.isFirstTime, this.notificationMessage});

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
                    if(notificationMessage != null){
                      return ChatListViewScreen(listId: notificationMessage?.data['listId'], listName: notificationMessage!.notification!.title!);
                    }
                    // return DynamicLinkService()
                    //     .getStartPage(dynamicLinkPath); //case 1
                    return isFirstTime ? OnBoardingScreen() : MainScreen();
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
