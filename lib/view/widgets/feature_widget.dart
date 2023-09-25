import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets_manager.dart';
import '../../utils/style_utils.dart';

class FeatureContainer extends StatelessWidget {
  final String heading;
  final String body;
  const FeatureContainer({
    super.key, required this.heading, required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.w,
      // height: 201,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      margin: EdgeInsets.only(right: 14.w),
      decoration: BoxDecoration(
          color: purple70,
          borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.ph,
          Text(heading, style: TextStylesInter.textViewSemiBold14.copyWith(color: Colors.white),),
          15.ph,
          SizedBox(
            width: 178.w,
              child: Text(body, style: TextStylesInter.textViewLight12.copyWith(color: Colors.white),)),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(savingIllustration, width: 108, height: 108,),
          )
        ],
      ),
    );
  }
}
