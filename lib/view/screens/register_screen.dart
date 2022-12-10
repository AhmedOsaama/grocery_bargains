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

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 165.h,
              ),
              SvgPicture.asset(splashImage),
              SizedBox(
                height: 65.h,
              ),
              Text(
                !isLogin ? "Sign up with: " : "Log in",
                style: TextStyles.textViewBold20,
              ),
              SizedBox(
                height: 40.h,
              ),
              const GenericField(
                borderRaduis: 10,
                hintText: "Email",
                isFilled: true,
                colorStyle: borderColor,
              ),
              SizedBox(
                height: 20.h,
              ),
              const GenericField(
                borderRaduis: 10,
                hintText: "Password",
                isFilled: true,
                colorStyle: borderColor,
              ),
              SizedBox(
                height: 20.h,
              ),
              if(!isLogin)
              const GenericField(
                borderRaduis: 10,
                hintText: "Confirm Password",
                isFilled: true,
                colorStyle: borderColor,
              ),
              SizedBox(
                height: 20.h,
              ),
              !isLogin
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = true;
                        });
                      },
                      child: Text.rich(TextSpan(
                          text: "Already have an account ? ",
                          children: [
                            TextSpan(
                                text: "Login",
                                style: TextStyles.textViewRegular15.copyWith(
                                    color:
                                        const Color.fromRGBO(77, 191, 163, 1)))
                          ],
                          style: TextStyles.textViewRegular15)))
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = false;
                        });
                      },
                      child: Text.rich(TextSpan(
                          text: "Don't have an account ? ",
                          children: [
                            TextSpan(
                                text: "Register",
                                style: TextStyles.textViewRegular15.copyWith(
                                    color:
                                        const Color.fromRGBO(77, 191, 163, 1)))
                          ],
                          style: TextStyles.textViewRegular15)),
                    ),
              SizedBox(
                height: 30.h,
              ),
              GenericButton(
                onPressed: () => AppNavigator.push(
                    context: context, screen: const HomeScreen()),
                height: 32.h,
                // width: 95.w,
                color: const Color.fromRGBO(217, 217, 217, 1),
                borderRadius: BorderRadius.circular(10),
                child: Text(isLogin ? "Login" : "Register",
                    style: TextStyles.textViewRegular18
                        .copyWith(color: Colors.black)),
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                "Or continue with: ",
                style: TextStyles.textViewBold15,
              ),
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
