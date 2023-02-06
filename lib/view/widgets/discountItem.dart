import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/assets_manager.dart';
import '../../utils/style_utils.dart';

class DiscountItem extends StatelessWidget {
  final String name;
  final String priceBefore;
  final String priceAfter;
  final String measurement;
  const DiscountItem({Key? key, required this.name, required this.priceBefore, required this.priceAfter, required this.measurement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(right: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w,vertical: 30.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(peach),
          ),
          SizedBox(height: 10.h,),
          Text(name,style: TextStyles.textViewSemiBold14,),
          Text(measurement,style: TextStyles.textViewMedium12.copyWith(color: Color.fromRGBO(108, 108, 112, 1)),),
          Text.rich(TextSpan(text: "\$$priceBefore",style: TextStyles.textViewMedium12.copyWith(decoration: TextDecoration.lineThrough,color: Colors.grey),children: [
            TextSpan(
              text: " \$$priceAfter",style: TextStyles.textViewMedium12.copyWith(color: Color.fromRGBO(108, 197, 29, 1),decoration: TextDecoration.none),
            )
          ])),
        ],
      ),
    );
  }
}
