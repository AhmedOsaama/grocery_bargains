import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:bargainb/config/routes/app_navigator.dart';
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
import '../policy_screen.dart';
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
    return SingleChildScrollView(
      child: Column(
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
                    'At BargainB, we prioritize your privacy & the protection of your personal information. To enhance your experience & tailor the content, products, & recipes to your preferences, we collect data about your app usage. Read our '.tr(),
                    style: TextStylesInter.textViewLight13),
                TextSpan(
                    text: ' policy'.tr(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                      TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "Policy Page",);
                       AppNavigator.push(context: context, screen: PolicyScreen());
                      },
                    style: TextStylesInter.textViewSemiBold12.copyWith(decoration: TextDecoration.underline)),
                TextSpan(
                  text: ' for more '.tr(),
                  style: TextStylesInter.textViewLight13,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          15.ph,
          Text(
                "In addition to using your data to personalize your assistant, recommend products, send deal alerts, & track savings, we also collect & use your Contact List information. This helps us to improve our app's functionality & services. We may use this information to facilitate social connections, enable you to share deals with your contacts, & offer more personalized recommendations. Your contact data is handled with the utmost care & confidentiality. You have control over this data collection & can manage your preferences in the app settings.".tr(),
            style: TextStylesInter.textViewLight13,
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
      ),
    );
  }

  Future<void> personalizeAI() async {
    TrackingStatus appTrackingStatus = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (appTrackingStatus == TrackingStatus.notDetermined) {
      appTrackingStatus = await AppTrackingTransparency.requestTrackingAuthorization();
    }
    log(appTrackingStatus.name);
    print(appTrackingStatus.name);
    // if(appTrackingStatus == TrackingStatus.authorized || appTrackingStatus == TrackingStatus.notSupported) {
      widget.goToNextPage();
      return;
    // }
    // if (appTrackingStatus == TrackingStatus.denied) {
    //   exit(1);
    // }
  }
}
