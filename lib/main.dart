import 'package:bargainb/core/utils/service_locators.dart';
import 'package:bargainb/services/purchase_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/app.dart';
import 'firebase_options.dart';
//To apply keys for the various languages used.
// flutter pub run easy_localization:generate -S ./assets/translations -f keys -o locale_keys.g.dart
@pragma('vm:entry-point')
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => FirebaseAppCheck.instance.activate());
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    ),
    PurchaseApi.init(),
  ]);
  var notificationMessage = await FirebaseMessaging.instance.getInitialMessage();
  var pref = await SharedPreferences.getInstance();
  var isFirstTime = pref.getBool("firstTime") ?? true;

  initializeMyApp(notificationMessage, isFirstTime);
}


