import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';

class SixthOnboarding extends StatefulWidget {
  const SixthOnboarding({Key? key}) : super(key: key);

  @override
  State<SixthOnboarding> createState() => _SixthOnboardingState();
}

class _SixthOnboardingState extends State<SixthOnboarding> {
  @override
  void initState() {
    TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "Sixth onboarding screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Create, Share, & Save".tr(),
          style: TextStylesInter.textViewBold26,
        ),
        10.ph,
        Text(
          'Create a single master list for all your grocery and non-grocery items'.tr(),
          style: TextStylesInter.textViewSemiBold16,
          textAlign: TextAlign.center,
        ),
        10.ph,
        Text(
          'Invite , Collaborate & Save',
          style: TextStylesInter.textViewLight15,
        ),
        15.ph,
        Image.asset(onboarding6),
      ],
    );
  }
}
