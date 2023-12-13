import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../../view/components/button.dart';
class ThirdOnboarding extends StatefulWidget {
  final Function goToNextPage;
  const ThirdOnboarding({Key? key, required this.goToNextPage}) : super(key: key);

  @override
  State<ThirdOnboarding> createState() => _ThirdOnboardingState();
}

class _ThirdOnboardingState extends State<ThirdOnboarding> {
  @override
  void initState() {
    TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "Third onboarding screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Your Data. Your Choice'.tr(),
          style: TextStylesInter.textViewBold26,
        ),
        15.ph,
        Text(
          'How We Collect and Use Your Data'.tr(),
          style: TextStyles.textViewSemiBold16,
        ),
        Image.asset(onboarding4_1),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text:
                  'At BargainB, we value your privacy and are committed to protecting your personal information. We collect data about how and when you use our app to provide you with the best possible experience and personalize the content, products, and recipes you see. Read our'.tr(),
                  style: TextStylesInter.textViewLight12),
              TextSpan(
                  text: ' policy'.tr(),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                    TrackingUtils().trackTextLinkClicked("Guest", DateTime.now().toUtc().toString(), "Third onboarding screen", "Click Policy link");
                      final url = Uri.parse('https://thebargainb.com/privacy-policy');
                      try {
                        await launchUrl(url);
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                  style: TextStylesInter.textViewSemiBold12.copyWith(decoration: TextDecoration.underline)),
              TextSpan(
                text: ' for more '.tr(),
                style: TextStylesInter.textViewLight12,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        15.ph,
        Text(
          'We use your data to personalise your Assistant, recommend products, send you alerts about deals, and track your savings. We also use your data to improve our app and services.'
              .tr(),
          style: TextStylesInter.textViewLight12,
          textAlign: TextAlign.center,
        ),
        15.ph,
        Image.asset(onboarding4_2),
        10.ph,
        GenericButton(
          borderRadius: BorderRadius.circular(6),
          padding: EdgeInsets.symmetric(vertical: 20),
          color: brightOrange,
          width: double.infinity,
          onPressed: () {
            TrackingUtils().trackButtonClick("Guest", "Personalize Assistant", DateTime.now().toUtc().toString(), "Third onboarding screen");
            personalizeAI();
            // AppNavigator.pushReplacement(
            //     context: context, screen: MainScreen());
            // Provider.of<UserProvider>(context, listen: false).turnOffFirstTime();
            // Provider.of<TutorialProvider>(context, listen: false).activateWelcomeTutorial();
          },
          child: Text(
            'Yes, Personalise My Assistant'.tr(),
            style: TextStyles.textViewSemiBold16.copyWith(color: white),
          ),
        ),
        15.ph,
        GenericButton(
          borderRadius: BorderRadius.circular(6),
          padding: EdgeInsets.symmetric(vertical: 20),
          borderColor: Color(0xFFEBEBEB),
          color: Colors.white,
          width: double.infinity,
          onPressed: () async {
            TrackingUtils().trackButtonClick("Guest", "Not now, exit app", DateTime.now().toUtc().toString(), "Third onboarding screen");
            exit(1);
          },
          child: Text(
            'Not now, leave App'.tr(),
            style: TextStyles.textViewSemiBold16.copyWith(color: black),
          ),
        ),
      ],
    );
  }

  Future<void> personalizeAI() async {
    TrackingStatus appTrackingStatus = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (appTrackingStatus == TrackingStatus.notDetermined) {
      appTrackingStatus = await AppTrackingTransparency.requestTrackingAuthorization();
    }
    if (appTrackingStatus == TrackingStatus.denied) {
      exit(1);
    }
    widget.goToNextPage();
  }
}
