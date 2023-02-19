import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swaav/view/components/plus_button.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets_manager.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';

class ProductItemWidget extends StatelessWidget {
  final String price;
  final String fullPrice;
  final String name;
  final String description;
  final String imagePath;
  final Function? onTap;
  const ProductItemWidget({Key? key, required this.price, required this.name, required this.description, required this.imagePath, required this.fullPrice, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174.w,
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                offset: Offset(0,4),
                color: Color.fromRGBO(59, 59, 59, 0.12),
                blurRadius: 28
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h,),
          Center(child: Image.asset(imagePath)),
          SizedBox(height: 18.h,),
          Text(name,style: TextStyles.textViewBold16.copyWith(color: prussian),),
          SizedBox(height: 5.h,),
          Text(description,style: TextStyles.textViewSemiBold14.copyWith(color: Colors.grey),),
          SizedBox(height: 17.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("€$price",style: TextStyles.textViewSemiBold14.copyWith(color: prussian),),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("€$fullPrice",style: TextStyles.textViewMedium10.copyWith(color: Colors.grey,decoration: TextDecoration.lineThrough),),
                      SizedBox(width: 5.w,),
                      Text("€${(double.tryParse(fullPrice)! - double.tryParse(price)!).toStringAsFixed(2)} less",style: TextStyles.textViewMedium10.copyWith(color: verdigris),),
                    ],
                  ),
                ],
              ),
             onTap != null ? PlusButton(onTap: () => onTap!()) : Container(),
            ],
          ),
          SizedBox(height: 10.w,),
        ],
      ),
    );
  }
}
