import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:showcaseview/showcaseview.dart';

import '../utils/tooltips_keys.dart';

class TutorialProvider with ChangeNotifier{
  bool isTutorialRunning = false;
  bool canShowWelcomeDialog = false;
  bool canShowConfetti = false;

  void startTutorial(){
    log("IS STARTING TUTORIAL");
    isTutorialRunning = true;
    notifyListeners();
  }

  void showTutorialConfetti(){
    canShowConfetti = true;
    // notifyListeners();
  }
  void hideTutorialConfetti(){
    canShowConfetti = false;
    notifyListeners();
  }

  void activateWelcomeTutorial(){
    canShowWelcomeDialog = true;
    // notifyListeners();
  }

  void deactivateWelcomeTutorial(){
    canShowWelcomeDialog = false;
    notifyListeners();
  }

  void stopTutorial(BuildContext context){
    isTutorialRunning = false;
    ShowCaseWidget.of(context).dismiss();
    showTutorialConfetti();
    notifyListeners();
  }

}