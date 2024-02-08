import 'dart:developer';

import 'package:bargainb/features/home/presentation/views/widgets/home_floating_button.dart';
import 'package:bargainb/features/home/presentation/views/widgets/nav_bar_showcase.dart';
import 'package:bargainb/features/home/presentation/views/widgets/tutorial_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../providers/chatlists_provider.dart';
import '../../../../providers/tutorial_provider.dart';
import 'widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var showFAB = false;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(builder: (builder){
        startTutorial(context, builder);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          floatingActionButton: HomeFloatingButton(showFAB: showFAB, scrollController: scrollController),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomSheet: NavBarTutorial(builder: builder,),
          body: HomeViewBody(scrollController: scrollController, showFAB: showFAB, updateFAB: updateHomeFloatingButton,),
        );
      })
    );
  }

  void updateHomeFloatingButton(bool value){
    setState(() {
      showFAB = value;
    });
  }

  Future<dynamic> showWelcomeDialog(BuildContext context, BuildContext builder) async {
    await Future.delayed(const Duration(seconds: 2));
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return TutorialDialog(showcaseContext: builder,);
        });
  }

  void startTutorialStopwatch(BuildContext context) {
    var chatlistProvider = Provider.of<ChatlistsProvider>(context, listen: false);
    chatlistProvider.stopwatch.start();
    chatlistProvider.stopwatch.reset();
    var onboardingDuration = chatlistProvider.stopwatch.elapsed.inSeconds.toString();
    log("Onboarding duration start: $onboardingDuration");
  }

  void startTutorial(BuildContext context, BuildContext builder) {
    var tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);
    if (tutorialProvider.canShowWelcomeDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showWelcomeDialog(context, builder);
        setState(() {
          tutorialProvider.canShowWelcomeDialog = false;
        });
        startTutorialStopwatch(context);
      });
    }
  }
}

