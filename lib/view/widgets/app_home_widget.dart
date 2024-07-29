import 'package:bargainb/features_web/home/presentation/views/home_web_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/utils/app.dart';
import '../../features/home/presentation/views/main_screen.dart';
import '../../features/onboarding/presentation/views/splash_progress_screen.dart';
import '../../features/onboarding/presentation/views/welcome_screen.dart';
import '../../features_web/registration/presentation/views/register_web_screen.dart';

class getHomeWidget extends StatelessWidget {
  const getHomeWidget({
    super.key,
    required this.getAllProductsFuture,
    required this.widget,
  });

  final Future getAllProductsFuture;
  final MyApp widget;

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? HomeWebScreen()
        // ? RegisterWebScreen(isLogin: false)
        : FutureBuilder(
            future: getAllProductsFuture,
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
              return widget.isFirstTime ? const WelcomeScreen() : const MainScreen(); //logged out
            });
  }
}
