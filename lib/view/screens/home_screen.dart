import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/widgets/list_type_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(home,width: 18.w,height: 20.h,),
                SizedBox(width: 70.w,child: Text("Welcome Laura Let's List !",style: TextStyles.textViewBold10.copyWith(color: Color.fromRGBO(137, 137, 137, 1)),)),
                Image.asset(userIcon),
                SvgPicture.asset(options,width: 10.w,height: 10.h,),
              ],
            ),
            SizedBox(height: 40.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTypeWidget(color: green, text: "Grocery"),
                  ListTypeWidget(color: grey, text: "Blank",textColor: darkBlue,),
                ],
              ),
            ),
            SizedBox(height: 16.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTypeWidget(color: lightGreen, text: "Clothing"),
                  ListTypeWidget(color: darkBlue, text: "Basics",),
                ],
              ),
            ),
            SizedBox(height: 16.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTypeWidget(color: grey, text: "Inspiration",textColor: green,),
                  ListTypeWidget(color: lightBlue, text: """Party "must haves" """,),
                ],
              ),
            ),
            SizedBox(height: 30.h,),
            Container(
              width: 138.w,
              height: 28.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: darkGrey
              ) ,
            ),
          ],
        ),
      ),
    );
  }
}
