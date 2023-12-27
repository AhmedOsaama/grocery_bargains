import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../config/routes/app_navigator.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../onboarding/presentation/views/policy_screen.dart';
import '../../../../onboarding/presentation/views/terms_of_service_screen.dart';

class PolicyTermsWidget extends StatelessWidget {
  const PolicyTermsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {
              TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open Privacy Policy Link", DateTime.now().toUtc().toString(), "Preferences Screen");
              AppNavigator.push(context: context, screen: PolicyScreen());
            },
            child: Text(
              "Privacy Policy".tr(),
              style: TextStyles.textViewMedium10
                  .copyWith(color: Colors.grey),
            )),
        Text("|"),
        TextButton(
            onPressed: () {
              TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open Terms of Service Link", DateTime.now().toUtc().toString(), "Preferences Screen");
              AppNavigator.push(context: context, screen: TermsOfServiceScreen());
            },
            child: Text(
              "Terms of Service".tr(),
              style: TextStyles.textViewMedium10
                  .copyWith(color: Colors.grey),
            )),
      ],
    );
  }
}
