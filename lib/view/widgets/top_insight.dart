import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/style_utils.dart';

class TopInsight extends StatelessWidget {
  final String insightType;
  final Image image;
  final String insightValue;
  final String insightMetadata;
  const TopInsight({Key? key, required this.insightType, required this.image, required this.insightValue, required this.insightMetadata}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 20),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x263463ED),
            blurRadius: 28,
            offset: Offset(0, 10),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(insightType, style: TextStylesInter.textViewSemiBold10.copyWith(color: mainPurple),),
          10.ph,
          image,
          // 15.ph,
          SizedBox(
            width: 75.w,
              child: Text(insightValue,
                textAlign: TextAlign.center,
                style: TextStylesInter.textViewSemiBold10, overflow: TextOverflow.ellipsis,)),
          Text(insightMetadata, style: TextStylesInter.textViewRegular10,)
        ],
      ),
    );
  }

}
