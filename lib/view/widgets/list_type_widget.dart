import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/style_utils.dart';

class ListTypeWidget extends StatelessWidget {
  final Color color;
  final String text;
  final Color? textColor;
  const ListTypeWidget({Key? key, required this.color, required this.text, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 69.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(child: Text(text,style: TextStyles.textViewBold20.copyWith(color: textColor ?? Colors.white),textAlign: TextAlign.center,)),
    );
  }
}
