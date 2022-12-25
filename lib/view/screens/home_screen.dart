import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/nav_bar.dart';
import 'package:swaav/view/screens/lists_screen.dart';
import 'package:swaav/view/screens/profile_screen.dart';
import 'package:swaav/view/widgets/list_type_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 90.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(home,width: 40.w,height: 44.h,),
                SizedBox(width: 156.w,child: Text("Welcome Laura Let's List !",style: TextStyles.textViewBold20.copyWith(color: Color.fromRGBO(137, 137, 137, 1)),)),
                Image.asset(userIcon),
                GestureDetector(
                  onTap: () => AppNavigator.push(context: context, screen: ProfileScreen()),
                    child: SvgPicture.asset(options,width: 22.w,height: 22.h,)),
              ],
            ),
            SizedBox(height: 50.h,),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Text("Shopping Categories",style: TextStyles.textViewBold15,),
            ),
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
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Text("Pre made",style: TextStyles.textViewBold15,),
                      ),
                      ListTypeWidget(color: darkBlue, text: "Basics",),
                    ],
                  ),
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
            SizedBox(height: 20.h,),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Text("Recent",style: TextStyles.textViewBold15,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Container(
              width: 109.w,
              height: 137.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Color.fromRGBO(217, 217, 217, 1)
              ) ,
            ),
                Container(
                  width: 109.w,
                  height: 137.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Color.fromRGBO(217, 217, 217, 1)
                  ) ,
                ),
                Container(
                  width: 109.w,
                  height: 137.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                      color: Color.fromRGBO(217, 217, 217, 1)
                  ) ,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
