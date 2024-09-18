import 'package:bargainb/utils/app_colors.dart';
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
  final double? priceDouble;
  final double? beforeDiscountPrice;
  final String currencyCode;
  PlanContainer(
      {Key? key,
        required this.selectedPlan,
        required this.changePlan,
        this.offerText,
        required this.price,
        required this.plan, this.beforeDiscountPrice, required this.currencyCode, this.priceDouble})
      : super(key: key);

  @override
  State<PlanContainer> createState() => _PlanContainerState();
}

class _PlanContainerState extends State<PlanContainer> {
  @override
  Widget build(BuildContext context) {
    Color accentColor = widget.plan == "Monthly" ? Color(0xFFFF8A1F) : Color(0xFF3463ED);
    return GestureDetector(
      onTap: (){
        widget.changePlan(widget.plan);
      },
      child: Stack(
        // alignment: Alignment.topCenter,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: widget.plan == "Monthly" ? Color(0xffE8FFE8) : Color(0xff123013),
              borderRadius: BorderRadius.circular(5),
              border: widget.selectedPlan == widget.plan ? Border.all(color: primaryGreen, width: 3) : Border.all(width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Radio(
                    //   value: widget.plan,
                    //   groupValue: widget.selectedPlan,
                    //   onChanged: (value) => widget.changePlan(value),
                    //   activeColor:  widget.plan == "Monthly" ? primaryGreen : Colors.white,
                    // ),
                    Text(
                      widget.plan.tr(),
                      style: TextStylesPaytoneOne.textViewRegular24.copyWith(color:  widget.plan == "Monthly" ? Colors.black : Colors.white),
                    ),
                    10.pw,
                    if (widget.offerText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: primaryGreen,
                        ),
                        child: Text(
                          widget.offerText!,
                          style: TextStylesInter.textViewRegular10.copyWith(color: Colors.white),
                        ),
                      ),

                  ],
                ),
                // Spacer(),
                10.ph,
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${widget.price}/month",
                        textAlign: TextAlign.center, style: TextStylesInter.textViewSemiBold20.copyWith(fontSize: 16.sp, color:  widget.plan == "Monthly" ? Colors.black : Colors.white)),
                    10.pw,
                    if(widget.beforeDiscountPrice != null)
                      Text('${widget.currencyCode} ${widget.beforeDiscountPrice!.toStringAsFixed(2)}',
                         style: TextStylesInter.textViewSemiBold20.copyWith(fontSize: 13.sp,color: Colors.grey, decoration: TextDecoration.lineThrough)),
                  ],
                ),
                if(widget.plan == "Yearly")
                  Text(
                    "(Equivalent to ${(widget.priceDouble! / 12).toStringAsFixed(2)} ${widget.currencyCode}/month)",
                    // "Equivalent to ${widget.price} / month",
                    style: TextStylesInter.textViewRegular10.copyWith(color:  widget.plan == "Monthly" ? Colors.black : Colors.white),
                  ),
              ],
            ),
          ),
          if(widget.plan == "Yearly")
          Container(
            width: 80,
            // height: 15,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 4, left: 30),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: brightOrange),
            child: Text(
              "Best Value".tr(),
              style: TextStylesInter.textViewRegular12.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
