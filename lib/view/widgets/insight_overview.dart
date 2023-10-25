import 'package:bargainb/main.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/style_utils.dart';

class InsightOverview extends StatelessWidget {
  final String type;
  final String value;
  final String info;
  final Color infoColor;
  const InsightOverview({Key? key, required this.type, required this.value, required this.info, required this.infoColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174.w,
      height: 112.h,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
          color: Color(0x263463ED),
      blurRadius: 28,
      offset: Offset(0, 10),
      spreadRadius: 0,
    )
    ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.arrow_forward_ios, color: mainPurple, size: 20,),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type, style: TextStylesInter.textViewMedium14.copyWith(color: Color(0xFFC2D0FA)),),
              5.ph,
              Text(value, style: TextStylesInter.textViewSemiBold20,),
              5.ph,
              Text(info, style: TextStylesInter.textViewSemiBold12.copyWith(color: infoColor),)
            ],
          ),
        ],
      ),
    );
  }
}
