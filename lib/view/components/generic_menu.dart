import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/style_utils.dart';

class GenericMenu extends StatelessWidget {
  final String option1Text;
  final String option2Text;
  final Function() option1Func;
  final Function() option2Func;
  final double margin;
  const GenericMenu({Key? key, required this.option1Text, required this.option2Text, required this.option1Func, required this.option2Func, this.margin = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromRGBO(226, 226, 226, 1)
      ),
      margin: EdgeInsets.symmetric(
        horizontal: margin,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 45.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: option1Func,
            child: Text(
              option1Text,
              style: TextStyles.textViewBold15,
            ),
          ),
          GestureDetector(
            onTap: option2Func,
            child: Text(
              option2Text,
              style: TextStyles.textViewBold15,
            ),
          ),
        ],
      ),
    );
  }
}
