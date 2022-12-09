import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/components/generic_field.dart';

import 'home_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 31.h,),
              SvgPicture.asset(splashImage),
              SizedBox(height: 50.h,),
              Text("Sign up with: ",style: TextStyles.textViewBold10,),
              SizedBox(height: 10.h,),
              GenericField(borderRaduis: 10,hintText: "Email",colorStyle: borderColor,),
              SizedBox(height: 5.h,),
              GenericField(borderRaduis: 10,hintText: "Password",colorStyle: borderColor,),
              SizedBox(height: 5.h,),
              GenericField(borderRaduis: 10,hintText: "Confirm Password",colorStyle: borderColor,),
              SizedBox(height: 10.h,),
              GenericButton(onPressed: () => AppNavigator.push(context: context, screen: HomeScreen()), child: Text("Submit",style: TextStyles.textViewLight12),height: 8.h,borderRadius: BorderRadius.circular(10),),
              Text("Or continue with: ",style: TextStyles.textViewBold10,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(twitter),
                  Image.asset(fbIcon),
                  Image.asset(google),
                  Image.asset(apple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
