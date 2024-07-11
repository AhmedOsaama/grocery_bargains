import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/routes/app_navigator.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';
import '../latest_bargains_screen.dart';

class LatestBargainsRow extends StatelessWidget {
  const LatestBargainsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 200.w,
          child: Text(
            "Today's Latest Discounts".tr(),
            style: TextStylesInter.textViewBold16.copyWith(color: prussian),
          ),
        ),
        TextButton(
            onPressed: () {
              AppNavigator.push(context: context, screen: LatestBargainsScreen());
              try {
                TrackingUtils().trackTextLinkClicked(FirebaseAuth.instance.currentUser!.uid,
                    DateTime.now().toUtc().toString(), "Home screen", "See all latest bargains");
              } catch (e) {
                print(e);
                TrackingUtils().trackTextLinkClicked(
                    'Guest', DateTime.now().toUtc().toString(), "Home screen", "See all latest bargains");
              }
            },
            child: Text(
              'seeAll'.tr(),
              style: TextStylesInter.textViewRegular16.copyWith(color: mainPurple),
            ))
      ],
    );
  }
}
