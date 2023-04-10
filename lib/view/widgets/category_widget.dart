import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/assets_manager.dart';
import '../../utils/style_utils.dart';

class CategoryWidget extends StatelessWidget {
  final Color color;
  final String categoryName;
  final String categoryImagePath;
  const CategoryWidget({Key? key, required this.color, required this.categoryName, required this.categoryImagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(right: 21.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: SvgPicture.asset(categoryImagePath),
          ),
          SizedBox(height: 10.h,),
          Text(categoryName,style: TextStyles.textViewMedium10.copyWith(color: Color.fromRGBO(134, 136, 137, 1)),)
        ],
      ),
    );
  }
}
