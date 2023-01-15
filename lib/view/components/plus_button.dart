import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/app_colors.dart';
import '../screens/invite_screen.dart';

class PlusButton extends StatelessWidget {
  final Function() onTap;
  const PlusButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 31.w,
        height: 31.h,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(137, 137, 137, 1),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black.withOpacity(0.25),
              )
            ]),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 10,
        ),
      ),
    );
  }
}
