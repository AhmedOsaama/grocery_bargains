import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bargainb/core/utils/service_locators.dart';
import 'package:bargainb/features/profile/data/repos/profile_repo_impl.dart';
import 'package:bargainb/features/profile/presentation/manager/user_provider.dart';
import 'package:bargainb/providers/subscription_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart';
import 'package:segment_analytics/state.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:upgrader/upgrader.dart';

import '../../providers/chatlists_provider.dart';
import '../../providers/google_sign_in_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/suggestion_provider.dart';
import '../../providers/tutorial_provider.dart';
import '../../providers/user_provider.dart';
import '../../view/widgets/app_home_widget.dart';
import 'package:segment_analytics/client.dart';

class MyApp extends StatefulWidget {
  final RemoteMessage? notificationMessage;
  final bool isFirstTime;
  const MyApp({super.key, required this.isFirstTime, this.notificationMessage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Mixpanel mixPanel;
  late Stream authStateChangesStream;
  late Widget homeWidget;

  @override
  void initState() {
    super.initState();
      authStateChangesStream = FirebaseAuth.instance.authStateChanges();
      homeWidget = getHomeWidget(widget: widget, notificationMessage: widget.notificationMessage, isFirstTime: widget.isFirstTime,);
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        title: 'BargainB',
        theme: ThemeData(canvasColor: canvasColor, useMaterial3: false),
        navigatorObservers: [SentryNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        home: Platform.isIOS ? UpgradeAlert(
          upgrader: Upgrader(
            showIgnore: false,
            dialogStyle: UpgradeDialogStyle.cupertino
          ),
            child: homeWidget
        ) : FutureBuilder(
          future: InAppUpdate.checkForUpdate(),
          builder: (context, snapshot) {
            if(snapshot.data != null) {
              var updateInfo = snapshot.data;
              log("UPDATEEEEEEEEEEE: ${updateInfo.toString()}");
              if(updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
                InAppUpdate.performImmediateUpdate().then((value) {
                });
              }
            }
            return homeWidget;
          }
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}


void initializeMyApp(RemoteMessage? notificationMessage, bool isFirstTime) {
  runApp(
      EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('nl'), Locale('de'), Locale('es'), Locale('fr'), Locale('it')],
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
          ))
  );
}
