import 'dart:async';
import 'dart:io';

import 'package:bargainb/core/utils/service_locators.dart';
import 'package:bargainb/services/purchase_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/app.dart';
import 'features/profile/data/repos/profile_repo_impl.dart';
import 'features/profile/presentation/manager/user_provider.dart';
import 'firebase_options.dart';
import 'providers/chatlists_provider.dart';
import 'providers/google_sign_in_provider.dart';
import 'providers/products_provider.dart';
import 'providers/subscription_provider.dart';
import 'providers/suggestion_provider.dart';
import 'providers/tutorial_provider.dart';
import 'providers/user_provider.dart';

@pragma('vm:entry-point')
Future<void> main() async {
  setupServiceLocator();
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Future.wait([
      EasyLocalization.ensureInitialized(),
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      ),
      PurchaseApi.init(),
    ]);
    await SentryFlutter.init(
      (options) {
        options.dsn = kReleaseMode
            ? 'https://9ac26c76cf0349d59d82538e91345ada@o4504179587940352.ingest.sentry.io/4504831610126336'
            : '';
        options.tracesSampleRate = 1.0;
      },
    );
    var notificationMessage = await FirebaseMessaging.instance.getInitialMessage();
    var pref = await SharedPreferences.getInstance();
    var isFirstTime = pref.getBool("firstTime") ?? true;      //turned off when tutorial is done
    var isOnboarding = pref.getBool("onboarding") ?? false;      //turned off when tutorial is done
    initializeMyApp(notificationMessage, isFirstTime, isOnboarding);
  }, (error, stack) async {
    await Sentry.captureException(error, stackTrace: stack);
  });
}
