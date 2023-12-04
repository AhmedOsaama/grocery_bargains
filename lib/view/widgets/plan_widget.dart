import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class PlanWidget extends StatelessWidget {
  final String promotion;
  final String type;
  final String price;
  final String pricePerMonth;
  const PlanWidget({
    super.key, required this.promotion, required this.type, required this.price, required this.pricePerMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.only(top: 15, left: 15, right: 9, bottom: 9),
          margin: EdgeInsets.only(right: 7.w),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF3463ED)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
                children: [
                  10.ph,
                  Text(
                    type,
                    style:
                    TextStylesInter.textViewRegular10.copyWith(color: Color(0xFF181A26), letterSpacing: -0.30),
                  ),
                  18.ph,
                  Row(
                    children: [
                      Text(
                        price,
                        style: TextStylesInter.textViewSemiBold24.copyWith(color: Color(0xFF181A26), fontSize: 22.sp),
                      ),
                      5.pw,
                      Text(
                        "EUR",
                        style: TextStylesInter.textViewSemiBold12
                            .copyWith(color: Color(0xFF181A26), letterSpacing: -0.30),
                      ),
                    ],
                  ),
                  18.ph,
                  Text(pricePerMonth,
                      style: TextStylesInter.textViewRegular10
                          .copyWith(color: Color(0xFF181A26), letterSpacing: -0.30))
                ],
              ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 100),
          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
          decoration: BoxDecoration(
              color: mainPurple,
              borderRadius: BorderRadius.circular(4)
          ),
          child: Text(promotion, style: TextStylesInter.textViewBold7.copyWith(color: Colors.white, letterSpacing: -0.30),),
        )
      ],
    );
  }
}
