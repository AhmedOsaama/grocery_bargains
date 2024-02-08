
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../features/onboarding/presentation/views/splash_progress_screen.dart';
import '../../features/onboarding/presentation/views/welcome_screen.dart';
import '../../providers/chatlists_provider.dart';
import '../../providers/google_sign_in_provider.dart';
import '../../providers/insights_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/suggestion_provider.dart';
import '../../providers/tutorial_provider.dart';
import '../../providers/user_provider.dart';
import '../../view/screens/main_screen.dart';

class MyApp extends StatefulWidget {
  final RemoteMessage? notificationMessage;
  final bool isFirstTime;
  const MyApp({super.key, required this.isFirstTime, this.notificationMessage});

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
    final transaction = Sentry.startTransaction('main initstate', 'task');
    try {
      getAllProductsFuture = Provider.of<ProductsProvider>(context, listen: false)
          .getAllProducts()
          .timeout(Duration(seconds: 3), onTimeout: () {});
      authStateChangesStream = FirebaseAuth.instance.authStateChanges();
      initMixpanel();
    } catch (exception) {
      transaction.throwable = exception;
      transaction.status = SpanStatus.internalError();
    } finally {
      transaction.finish();
    }
  }

  Future<void> initMixpanel() async {
    mixPanel = await Mixpanel.init("3aa827fb2f1cdf5ff2393b84d9c40bac",
        trackAutomaticEvents: true, optOutTrackingDefault: kDebugMode); //live
    FlutterBranchSdk.disableTracking(kDebugMode);
    // await Mixpanel.init("752b3abf782a7347499ccb3ebb504194", trackAutomaticEvents: true, optOutTrackingDefault: false);  //dev
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        title: 'BargainB',
        theme: ThemeData(
          canvasColor: Colors.white,
        ),
        navigatorObservers: [SentryNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: getAllProductsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashWithProgressIndicator();
              }
              return StreamBuilder(
                  stream: authStateChangesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SplashWithProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      if (widget.notificationMessage != null) {
                        return MainScreen(notificationData: widget.notificationMessage?.data['listId']);
                      }
                      return MainScreen();
                    }
                    return widget.isFirstTime ? WelcomeScreen() : MainScreen();
                    // return WelcomeScreen();
                  });
            }),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}

void initializeMyApp(RemoteMessage? notificationMessage, bool isFirstTime) {
  SentryFlutter.init(
        (options) {
      options.dsn = kReleaseMode
          ? 'https://9ac26c76cf0349d59d82538e91345ada@o4504179587940352.ingest.sentry.io/4504831610126336'
          : '';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('nl')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        // startLocale: const Locale('nl'),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
            ChangeNotifierProvider<ProductsProvider>(create: (_) => ProductsProvider()),
            ChangeNotifierProvider<ChatlistsProvider>(create: (_) => ChatlistsProvider()),
            ChangeNotifierProvider<TutorialProvider>(create: (_) => TutorialProvider()),
            ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
            ChangeNotifierProvider<SuggestionRepository>(create: (_) => SuggestionRepository()),
          ],
          child: MyApp(notificationMessage: notificationMessage, isFirstTime: isFirstTime),
        ))),
  );
}
