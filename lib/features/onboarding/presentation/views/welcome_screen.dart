import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), (){
      AppNavigator.pushReplacement(context: context, screen: OnboardingScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 1200)),
              builder: (context, snapshot) {
                var loading = snapshot.connectionState == ConnectionState.waiting;
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: loading ? 0 : 1,
                  child: Image.asset(
                    welcome,
                  ),
                );
              }),
          FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 500)),
              builder: (context, snapshot) {
                var loading = snapshot.connectionState == ConnectionState.waiting;
                return SizedBox(
                  height: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        bottom: loading ? 50 : 0,
                        // opacity: loading ? 0 : 1,
                        child: Text(
                          "Welcome!",
                          textAlign: TextAlign.center,
                          style: TextStylesPaytoneOne.textViewRegular24.copyWith(color: Color(0xff123013)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          10.ph,
          FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 1200)),
              builder: (context, snapshot) {
                var loading = snapshot.connectionState == ConnectionState.waiting;
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: loading ? 0 : 1,
                  child: Text(
                    "Finish the next steps to unlock and personalize your grocery assistant to start saving now",
                    textAlign: TextAlign.center,
                    style: TextStylesInter.textViewRegular16,
                  ),
                );
              })

        ],
      ),
    );
  }
}