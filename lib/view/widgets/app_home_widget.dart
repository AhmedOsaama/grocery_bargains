import 'package:bargainb/features/onboarding/presentation/views/account_feedback_screen.dart';
import 'package:bargainb/features/onboarding/presentation/views/free_trial_screen.dart';
import 'package:bargainb/features/registration/presentation/views/email_address_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../core/utils/app.dart';
import '../../features/home/presentation/views/main_screen.dart';
import '../../features/onboarding/presentation/views/splash_progress_screen.dart';
import '../../features/onboarding/presentation/views/highlights_screen.dart';

class getHomeWidget extends StatefulWidget {
  const getHomeWidget({
    super.key,
    required this.widget,
    required this.isFirstTime,
    required this.notificationMessage,
  });

  final MyApp widget;
  final bool isFirstTime;
  final RemoteMessage? notificationMessage;

  @override
  State<getHomeWidget> createState() => _getHomeWidgetState();
}

class _getHomeWidgetState extends State<getHomeWidget> {
  late Future appStartFuture;
  @override
  void initState() {
    super.initState();
    appStartFuture = Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
            future: appStartFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashWithProgressIndicator();
              }
              if (FirebaseAuth.instance.currentUser != null) {
                //logged in
                if (widget.notificationMessage != null) {
                  return MainScreen(notificationData: widget.notificationMessage?.data['listId']);
                }
                if (!widget.isFirstTime) return const MainScreen();
              }
              return widget.isFirstTime ? const HighlightsScreen() :
              const MainScreen(); //logged out
              // const HighlightsScreen(); //logged out
              // return AccountFeedbackScreen(isPremium: true);
            });
  }
}
