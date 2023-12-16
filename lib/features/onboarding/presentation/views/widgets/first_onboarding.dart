import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';

class FirstOnboarding extends StatefulWidget {
  const FirstOnboarding({
    super.key,
  });

  @override
  State<FirstOnboarding> createState() => _FirstOnboardingState();
}

class _FirstOnboardingState extends State<FirstOnboarding> {
  @override
  void initState() {
    TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "First onboarding screen");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcome to BargainB".tr(),
          style: TextStylesInter.textViewBold26,
        ),
        10.ph,
        Text(
          "Your Grocery Assistant".tr(),
          style: TextStylesInter.textViewSemiBold16,
        ),
        20.ph,
        Text(
          "Tired of overpaying for groceries? Feeling overwhelmed by the endless aisles? Let BargainB be your sidekick to smarter, more affordable grocery shopping."
              .tr(),
          style: TextStylesInter.textViewLight13,
          textAlign: TextAlign.center,
        ),
        14.ph,
        Text(
          'Our smart app helps you find the best deals, discover delicious recipes, and streamline your shopping experience, saving you every month'
              .tr(),
          style: TextStylesInter.textViewLight13,
          textAlign: TextAlign.center,
        ),
        60.ph,
        Image.asset(onboarding1)
      ],
    );
  }
}
