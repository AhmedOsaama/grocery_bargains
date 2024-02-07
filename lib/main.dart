
import 'package:bargainb/providers/insights_provider.dart';
import 'package:bargainb/providers/suggestion_provider.dart';
import 'package:bargainb/providers/tutorial_provider.dart';
import 'package:bargainb/providers/user_provider.dart';
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
import 'firebase_options.dart';
import 'providers/chatlists_provider.dart';
import 'providers/google_sign_in_provider.dart';
import 'providers/products_provider.dart';

//To apply keys for the various languages used.
// flutter pub run easy_localization:generate -S ./assets/translations -f keys -o locale_keys.g.dart

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
    PurchaseApi.init(),
  ]);

  var notificationMessage = await FirebaseMessaging.instance.getInitialMessage();

  var pref = await SharedPreferences.getInstance();
  var isFirstTime = pref.getBool("firstTime") ?? true;

  initializeMyApp(notificationMessage, isFirstTime);
}


