import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/style_utils.dart';
import '../components/button.dart';

class DurationButton extends StatelessWidget {
  final String duration;
  String selectedDuration;
  final Function() onPressed;
  DurationButton({Key? key, required this.duration, required this.selectedDuration, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericButton(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(6),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
        color: selectedDuration == duration ? Color(0xFF3463ED) : Color(0x333463ED) ,
        shadow: selectedDuration == duration ? [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ] : null,
        child: Text(duration, style: TextStylesInter.textViewRegular12.copyWith(color: selectedDuration == duration ? Colors.white : Color(0xFF3463ED)),));
  }
}
