import 'dart:convert';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/tracking_utils.dart';
import 'survey_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: Future.delayed(const Duration(milliseconds: 500)),
                    builder: (context, snapshot) {
                      var loading = snapshot.connectionState == ConnectionState.waiting;
                      return Container(
                        height: loading ? 0.h : 130.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              bottom: loading ? 50 : 0,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: loading ? 0 : 1,
                                child: Image.asset(
                                  context.locale.languageCode == "en" ? groceryGames : groceryGamesDutch,
                                  width: context.locale.languageCode == "nl" ? 320 : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                10.ph,
                FutureBuilder(
                    future: Future.delayed(const Duration(milliseconds: 1500)),
                    builder: (context, snapshot) {
                      var loading = snapshot.connectionState == ConnectionState.waiting;
                      return Container(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 1000),
                          opacity: loading ? 0 : 1,
                          child: Image.asset(
                            context.locale.languageCode == "en" ? chats : chatsDutch,
                            height: 150,
                          ),
                        ),
                      );
                    }),
                // Image.asset(chats),
                21.ph,
                FutureBuilder(
                    future: Future.delayed(const Duration(milliseconds: 2500)),
                    builder: (context, snapshot) {
                      var loading = snapshot.connectionState == ConnectionState.waiting;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: loading ? 0 : 1,
                            // child: Image.asset(context.locale.languageCode == "en" ? onboarding_bubble1 : onboarding_bubble1_dutch, width: 270.w,),
                            child: Column(
                              children: [
                                Text(
                                  "Welcome to BargainB".tr(),
                                  style: TextStylesInter.textViewBold26,
                                ),
                                10.ph,
                                Text(
                                  "We're done playing by their rules. We've built BargainB to be your champion against the grocery chains,"
                                          " ensuring you always get the best deals, hassle-free."
                                      .tr(),
                                  style: TextStylesInter.textViewLight15,
                                  textAlign: TextAlign.center,
                                ),
                                10.ph,
                                Text("Special Welcome Offer for Our Early Birds!".tr(),
                                    style: TextStylesInter.textViewSemiBold14, textAlign: TextAlign.center),
                                10.ph,
                                Text(
                                  "As one of our first users, enjoy a FREE one-month trial of BargainB. Help us make BargainB awesome for you and us by taking a quick survey. Your feedback is gold!"
                                      .tr(),
                                  style: TextStylesInter.textViewLight13,
                                  textAlign: TextAlign.center,
                                ),
                                5.ph,
                                Text(
                                  "Start with a FREE one-month trial at BargainB. Here's what you need to know:".tr(),
                                  style: TextStylesInter.textViewLight13,
                                ),
                                5.ph,
                                Text(
                                  """Trial Duration: Enjoy full access for 1 month!
Post-Trial Subscription: Continue saving with our 2.99/month subscription.
No Surprises: Receive a reminder before your trial ends.
Easy Cancellation: Cancel anytime before the trial ends at no cost."""
                                      .tr(),
                                  style: TextStylesInter.textViewLight12,
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                10.ph,
                FutureBuilder(
                    future: Future.delayed(const Duration(milliseconds: 3000)),
                    builder: (context, snapshot) {
                      var loading = snapshot.connectionState == ConnectionState.waiting;
                      return Container(
                        height: loading ? 200.h : 200.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 1000),
                              top: loading ? 50 : 0,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 1000),
                                opacity: loading ? 0 : 1,
                                // child: Image.asset(context.locale.languageCode == "en" ? onboarding_bubble1 : onboarding_bubble1_dutch, width: 270.w,),
                                child: Column(
                                  children: [
                                    GenericButton(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        borderRadius: BorderRadius.circular(10),
                                        color: brightOrange,
                                        height: 60,
                                        onPressed: () => AppNavigator.push(context: context, screen: const SurveyScreen()),
                                        child: Text(
                                          "Yes, FREE one-month trial of BargainB ".tr(),
                                          style: TextStylesInter.textViewSemiBold16,
                                        )),
                                    10.ph,
                                    GenericButton(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        height: 60,
                                        borderColor: const Color(0xFFEBEBEB),
                                        onPressed: () =>
                                            AppNavigator.push(context: context, screen: const OnBoardingScreen()),
                                        child: Text(
                                          "Nope, I don’t want a free trial".tr(),
                                          style: TextStylesInter.textViewSemiBold16.copyWith(color: Colors.black),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    trackFirstTimeUser();
    if (kReleaseMode) sendNewInstallMessage();
    super.initState();
  }

  Future<void> sendNewInstallMessage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var url =
        Uri.parse('https://connect.pabbly.com/workflow/sendwebhookdata/IjU3NjUwNTY5MDYzMTA0MzU1MjY4NTUzMTUxMzIi_pc');
    await post(url,
        headers: {
          "Content-Type": "Application/json",
        },
        body: jsonEncode({
          'user_message':
              "This is to notify you of a new first time user that installed the app. \n Store: ${packageInfo.installerStore} Package Name: ${packageInfo.packageName}, version: ${packageInfo.version}, Build Number: ${packageInfo.buildNumber}",
        })).catchError((e) {
      print(e);
    });
  }

  void trackFirstTimeUser() {
    try {
      TrackingUtils().trackFirstTimeUser(DateTime.now().toUtc().toString());
    } catch (e) {}
  }
}
