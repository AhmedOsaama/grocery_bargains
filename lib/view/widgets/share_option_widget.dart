import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/style_utils.dart';

class ShareOption extends StatelessWidget {
  final Function() optionFunction;
  final String optionName;
  const ShareOption({Key? key, required this.optionFunction, required this.optionName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: optionFunction,
      child: Container(
        width: 53.w,
        height: 53.h,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(217, 217, 217, 1),
            shape: BoxShape.circle
        ),
        child: Center(child: Text(optionName,style: TextStyles.textViewBold15.copyWith(color: Colors.black),)),
      ),
    );
  }
}
