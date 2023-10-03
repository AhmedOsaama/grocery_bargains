import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class SubscriptionPlanWidget extends StatefulWidget {
  final String promotion;
  final String type;
  final String price;
  final String pricePerMonth;
  final String selectedPlan;
  final Function onSubscriptionChanged;
  const SubscriptionPlanWidget({Key? key, required this.promotion, required this.type, required this.price, required this.pricePerMonth, required this.selectedPlan, required this.onSubscriptionChanged}) : super(key: key);

  @override
  State<SubscriptionPlanWidget> createState() => _SubscriptionPlanWidgetState();
}

class _SubscriptionPlanWidgetState extends State<SubscriptionPlanWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 17),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 5.h),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.promotion == LocaleKeys.currentPlan.tr() ? mainPurple : brightOrange,
            ),
            child: Text(
              widget.promotion,
              style: TextStylesInter.textViewBold7.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF3463ED))
            ),
            child: Row(
              children: [
                Radio(value: widget.type, groupValue: widget.selectedPlan, onChanged: (value) {
                  setState(() {
                  widget.onSubscriptionChanged(value);
                  });
                }),
                Text(widget.type, style: TextStylesInter.textViewSemiBold10.copyWith(color: blackSecondary),),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.price,
                          style: TextStylesInter.textViewSemiBold24.copyWith(color: Color(0xFF181A26)),
                        ),
                      ],
                    ),
                    5.ph,
                    Text(widget.pricePerMonth,
                        style: TextStylesInter.textViewRegular10
                            .copyWith(color: Color(0xFF181A26), letterSpacing: -0.30))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
