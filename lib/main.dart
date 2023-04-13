import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
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

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  print(message.notification!.title);
}

@pragma('vm:entry-point')
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // print(await FirebaseAppCheck.instance.getToken());
  await FirebaseAppCheck.instance.activate(
      // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
      // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
      // your preferred provider. Choose from:
      // 1. debug provider
      // 2. safety net provider
      // 3. play integrity provider
      );
  var notificationMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  var pref = await SharedPreferences.getInstance();
  var isRemembered = pref.getBool("rememberMe") ?? false;
  var isFirstTime = pref.getBool("firstTime") ?? true;

  if (isFirstTime) {
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
      options.dsn = kReleaseMode
          ? 'https://9ac26c76cf0349d59d82538e91345ada@o4504179587940352.ingest.sentry.io/4504831610126336'
          : '';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<GoogleSignInProvider>(
                create: (_) => GoogleSignInProvider()),
            ChangeNotifierProvider<ProductsProvider>(
                create: (_) => ProductsProvider()),
            ChangeNotifierProvider<ChatlistsProvider>(
                create: (_) => ChatlistsProvider()),
          ],
          child: MyApp(
              notificationMessage: notificationMessage,
              dynamicLinkPath: path,
              isRemembered: isRemembered,
              isFirstTime: isFirstTime),
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

class MyApp extends StatefulWidget {
  final String dynamicLinkPath;
  final RemoteMessage? notificationMessage;
  final bool isRemembered;
  final bool isFirstTime;
  const MyApp(
      {super.key,
      required this.dynamicLinkPath,
      required this.isRemembered,
      required this.isFirstTime,
      this.notificationMessage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Mixpanel mixPanel;

  @override
  void initState() {
    super.initState();

    initMixpanel();
  }

  Future<void> initMixpanel() async {
    // Replace with your Project Token
    // Once you've called this method once, you can access `mixpanel` throughout the rest of your application.
    mixPanel = await Mixpanel.init("752b3abf782a7347499ccb3ebb504194",
        trackAutomaticEvents: true);
    mixPanel.track("test event");
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        title: 'BargainB',
        theme: ThemeData(canvasColor: lightPurple),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (!widget.isRemembered) return RegisterScreen();
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                if (widget.notificationMessage != null) {
                  return ChatListViewScreen(
                      listId: widget.notificationMessage?.data['listId'],
                      listName:
                          widget.notificationMessage!.notification!.title!,
                      isNotificationOpened: true);
                }
                // return DynamicLinkService()
                //     .getStartPage(dynamicLinkPath); //case 1
                return widget.isFirstTime ? OnBoardingScreen() : MainScreen();
                // return ProfileScreen();
              }
              // return HomeScreen();
              return RegisterScreen();
            }),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
