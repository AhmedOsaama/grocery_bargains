import 'dart:io';

import 'package:bargainb/providers/insights_provider.dart';
import 'package:bargainb/providers/suggestion_provider.dart';
import 'package:bargainb/providers/tutorial_provider.dart';
import 'package:bargainb/providers/user_provider.dart';
import 'package:bargainb/services/purchase_service.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/register_screen.dart';
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
import 'view/screens/main_screen.dart';
import 'view/screens/onboarding_screen.dart';

//To apply keys for the various languages used.
// flutter pub run easy_localization:generate -S ./assets/translations -f keys -o locale_keys.g.dart

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  print(message.notification!.title);
}

@pragma('vm:entry-point')
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    ),
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) => FirebaseAppCheck.instance.activate()),
  ]);
  // await PurchaseApi.init();

  var notificationMessage = await FirebaseMessaging.instance.getInitialMessage();

  var pref = await SharedPreferences.getInstance();
  var isRemembered = pref.getBool("rememberMe") ?? false;
  var isFirstTime = pref.getBool("firstTime") ?? true;

  await SentryFlutter.init(
    (options) {
      options.dsn = kReleaseMode
          ? 'https://9ac26c76cf0349d59d82538e91345ada@o4504179587940352.ingest.sentry.io/4504831610126336'
          : '';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en'), Locale('nl')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
            ChangeNotifierProvider<ProductsProvider>(create: (_) => ProductsProvider()),
            ChangeNotifierProvider<ChatlistsProvider>(create: (_) => ChatlistsProvider()),
            ChangeNotifierProvider<InsightsProvider>(create: (_) => InsightsProvider()),
            ChangeNotifierProvider<TutorialProvider>(create: (_) => TutorialProvider()),
            ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
            ChangeNotifierProvider<SuggestionRepository>(create: (_) => SuggestionRepository()),
          ],
          child: MyApp(notificationMessage: notificationMessage, isRemembered: isRemembered, isFirstTime: isFirstTime),
        ))),
  );
}

class MyApp extends StatefulWidget {
  final RemoteMessage? notificationMessage;
  final bool isRemembered;
  final bool isFirstTime;
  const MyApp({super.key, required this.isRemembered, required this.isFirstTime, this.notificationMessage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Mixpanel mixPanel;
  late Future getAllProductsFuture;
  late Stream authStateChangesStream;

  @override
  void initState() {
    super.initState();
    getAllProductsFuture = Provider.of<ProductsProvider>(context, listen: false)
        .getAllProducts()
        .timeout(Duration(seconds: 3), onTimeout: () {});
    Provider.of<ProductsProvider>(context, listen: false).getAllCategories();
    authStateChangesStream = FirebaseAuth.instance.authStateChanges();
    initMixpanel();
  }

  Future<void> initMixpanel() async {
    // mixPanel = await Mixpanel.init("3aa827fb2f1cdf5ff2393b84d9c40bac", trackAutomaticEvents: true); //live
    await Mixpanel.init("752b3abf782a7347499ccb3ebb504194", trackAutomaticEvents: true);  //dev
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: white,
    ));
    return ScreenUtilInit(
      designSize: Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        title: 'BargainB',
        theme: ThemeData(
          canvasColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: getAllProductsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                return SplashWithProgressIndicator();
              }

              return StreamBuilder(
                  stream: authStateChangesStream,
                  builder: (context, snapshot) {
                    if (!widget.isRemembered && Platform.isAndroid) {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                      return RegisterScreen();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                      return SplashWidget();
                    }
                    if (snapshot.hasData) {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

                      if (widget.notificationMessage != null) {
                        return MainScreen(notificationData: widget.notificationMessage?.data['listId']);
                      }

                      return widget.isFirstTime ? OnBoardingScreen() : MainScreen();
                    }
                    if (Platform.isIOS) {
                      return widget.isFirstTime ? OnBoardingScreen() : MainScreen();
                    }
                    return MainScreen();
                  });
            }),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}

class SplashWithProgressIndicator extends StatelessWidget {
  const SplashWithProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(splashImage), fit: BoxFit.fill),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 250),
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}

class SplashWidget extends StatelessWidget {
  const SplashWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(splashImage), fit: BoxFit.fill),
      ),
    );
  }
}
