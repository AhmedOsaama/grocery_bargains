import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/icons_manager.dart';
import '../screens/lists_screen.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Color.fromRGBO(204, 204, 204, 1)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
              onTap: () => AppNavigator.push(context: context, screen: ListsScreen()),
              child: SvgPicture.asset(listIcon,width: 35.w,height: 51.h,)),
          SvgPicture.asset(profileIcon,width: 35.w,height: 51.h,),
          SvgPicture.asset(home,width: 35.w,height: 51.h,color: const Color.fromRGBO(81, 82, 80, 0.7),),
          SvgPicture.asset(messageIcon,width: 35.w,height: 51.h,),
        ],
      ),
    );
  }
}
