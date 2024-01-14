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
          child: Column(
            children: [
              Image.asset(groceryGames),
              10.ph,
              Image.asset(chats),
              21.ph,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                    "As one of our first users, we're thrilled to offer you a FREE one-month trial of BargainB. But hey, there's a twist."
                        .tr(),
                    style: TextStylesInter.textViewLight15,
                    textAlign: TextAlign.center),
              ),
              10.ph,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                    "Help us make BargainB awesome for you and us, as we use it too. Take a quick survey Your feedback is gold!"
                        .tr(),
                    style: TextStylesInter.textViewLight15,
                    textAlign: TextAlign.center),
              ),
              10.ph,
              GenericButton(
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                  color: brightOrange,
                  height: 60,
                  onPressed: () => AppNavigator.push(context: context, screen: SurveyScreen()),
                  child: Text(
                    "Yes, FREE one-month trial of BargainB".tr(),
                    style: TextStylesInter.textViewSemiBold16,
                  )),
              10.ph,
              GenericButton(
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  height: 60,
                  borderColor: Color(0xFFEBEBEB),
                  onPressed: () => AppNavigator.push(context: context, screen: OnBoardingScreen()),
                  child: Text(
                    "Nope, I don’t want a free trial",
                    style: TextStylesInter.textViewSemiBold16.copyWith(color: Colors.black),
                  )),
            ],
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
