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
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: yellow,
            borderRadius: BorderRadius.circular(7)
        ),
        child: Center(
          child: Icon(Icons.add,color: Colors.black,size: 20,),
        ),
      ),
    );
  }
}
