import 'dart:developer';

import 'package:bargainb/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../utils/tooltips_keys.dart';

class TutorialProvider with ChangeNotifier {
  bool isTutorialRunning = false;
  bool canShowWelcomeDialog = false;
  bool canShowConfetti = false;
  String hasSeenTutorialPrefKey = "hasSeenTutorial";

  void startTutorial() {
    isTutorialRunning = true;
    notifyListeners();
  }

  void showTutorialConfetti() {
    canShowConfetti = true;
    // notifyListeners();
  }

  void hideTutorialConfetti() {
    canShowConfetti = false;
    notifyListeners();
  }

  Future<void> activateWelcomeTutorial() async {
    var pref = await SharedPreferences.getInstance();
    var hasSeenTutorial = pref.getBool(hasSeenTutorialPrefKey) ?? false;
    if (!hasSeenTutorial) {
      canShowWelcomeDialog = true;
      notifyListeners();
    }
  }

  Future<void> stopTutorial(BuildContext context) async {
      isTutorialRunning = false;
      ShowCaseWidget.of(context).dismiss();
      showTutorialConfetti();
      notifyListeners();
      setTutorialStatus(true);
      Provider.of<UserProvider>(context,listen: false).turnOffFirstTime();
  }

  ///checks whether tutorial was shown to user or not
  Future<bool> getTutorialStatus() async {
    var pref = await SharedPreferences.getInstance();
    var hasSeenTutorial = pref.getBool("hasSeenTutorial") ?? false;
    return hasSeenTutorial;
  }

  Future<void> setTutorialStatus(bool value) async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool(hasSeenTutorialPrefKey, value);
  }
}
