import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';

class PlusButton extends StatelessWidget {
  final Function() onTap;
  const PlusButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: purple30),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: mainPurple,
            size: 30.sp,
          ),
        ),
      ),
    );
  }
}
