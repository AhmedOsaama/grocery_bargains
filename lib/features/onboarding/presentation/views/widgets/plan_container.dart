import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/style_utils.dart';

class PlanContainer extends StatefulWidget {
  final String plan;
  final String selectedPlan;
  final Function changePlan;
  final String? offerText;
  final String price;
  PlanContainer(
      {Key? key,
        required this.selectedPlan,
        required this.changePlan,
        this.offerText,
        required this.price,
        required this.plan})
      : super(key: key);

  @override
  State<PlanContainer> createState() => _PlanContainerState();
}

class _PlanContainerState extends State<PlanContainer> {
  @override
  Widget build(BuildContext context) {
    Color accentColor = widget.plan == "Monthly" ? Color(0xFFFF8A1F) : Color(0xFF3463ED);
    return Stack(
      // alignment: Alignment.topCenter,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: accentColor, width: 2),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Radio(
                value: widget.plan,
                groupValue: widget.selectedPlan,
                onChanged: (value) => widget.changePlan(value),
                activeColor: accentColor,
              ),
              Text(
                widget.plan.tr(),
                style: TextStylesInter.textViewRegular17,
              ),
              10.pw,
              if (widget.offerText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: accentColor,
                  ),
                  child: Text(
                    widget.offerText!,
                    style: TextStylesInter.textViewRegular10.copyWith(color: Colors.white),
                  ),
                ),
              Spacer(),
              Text(widget.price,
                  textAlign: TextAlign.center, style: TextStylesInter.textViewSemiBold20.copyWith(fontSize: 16.sp)),
            ],
          ),
        ),
        Container(
          width: 86,
          height: 15,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 4, left: 30),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: accentColor),
          child: Text(
            "LIMITED TIME OFFER".tr(),
            style: TextStyles.textViewBold7.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
