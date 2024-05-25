
import 'package:bargainb/core/utils/service_locators.dart';
import 'package:bargainb/features/onboarding/presentation/views/confirm_subscription_screen.dart';
import 'package:bargainb/features/onboarding/presentation/views/customize_experience_screen.dart';
import 'package:bargainb/features/onboarding/presentation/views/onboarding_subscription_screen.dart';
import 'package:bargainb/features/profile/data/repos/profile_repo_impl.dart';
import 'package:bargainb/features/profile/presentation/manager/user_provider.dart';
import 'package:bargainb/features/registration/presentation/views/register_screen.dart';
import 'package:bargainb/providers/subscription_provider.dart';
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
          .timeout(const Duration(seconds: 3), onTimeout: () {});
      authStateChangesStream = FirebaseAuth.instance.authStateChanges();
      initMixpanel();
    } catch (exception) {
      transaction.throwable = exception;
      transaction.status = const SpanStatus.internalError();
    } finally {
      transaction.finish();
    }
  }

  Future<void> initMixpanel() async {
    var mixpanelToken = kDebugMode ? '752b3abf782a7347499ccb3ebb504194' : '3aa827fb2f1cdf5ff2393b84d9c40bac';
    mixPanel = await Mixpanel.init(mixpanelToken, trackAutomaticEvents: true);
    FlutterBranchSdk.disableTracking(kDebugMode);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        title: 'BargainB',
        theme: ThemeData(
          canvasColor: Colors.white,
          useMaterial3: false
        ),
        navigatorObservers: [SentryNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: getAllProductsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashWithProgressIndicator();
              }
              return StreamBuilder(
                  stream: authStateChangesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SplashWithProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      //user opens app via notification
                      if (widget.notificationMessage != null) {
                        return MainScreen(notificationData: widget.notificationMessage?.data['listId']);
                      }
                      return const MainScreen();
                    }
                    return widget.isFirstTime ?
                    const WelcomeScreen() : const MainScreen();
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
            ChangeNotifierProvider<AuthUserProvider>(create: (_) => AuthUserProvider(getIt.get<ProfileRepoImpl>())),
            ChangeNotifierProvider<SuggestionRepository>(create: (_) => SuggestionRepository()),
            ChangeNotifierProvider<SubscriptionProvider>(create: (_) => SubscriptionProvider()..initSubscription()),
          ],
          child: MyApp(notificationMessage: notificationMessage, isFirstTime: isFirstTime),
        ))),
  );
}
