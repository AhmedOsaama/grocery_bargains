import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets_manager.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';

class ProductItem extends StatelessWidget {
  final String price;
  final String name;
  final String quantity;
  final String imagePath;
  const ProductItem({Key? key, required this.price, required this.name, required this.quantity, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174.w,
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
        children: [
          SizedBox(height: 20.h,),
          Image.asset(imagePath),
          SizedBox(height: 18.h,),
          Text("\$$price",style: TextStyles.textViewMedium12.copyWith(color: Color.fromRGBO(108, 197, 29, 1)),),
          SizedBox(height: 5.h,),
          Text(name,style: TextStyles.textViewSemiBold14.copyWith(color: prussian),),
          SizedBox(height: 5.h,),
          Text(quantity,style: TextStyles.textViewSemiBold14.copyWith(color: Colors.grey),),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(cartIcon),
                SizedBox(width: 10.w,),
                Text(LocaleKeys.addToCart.tr(),style: TextStyles.textViewSemiBold14.copyWith(color: prussian),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
