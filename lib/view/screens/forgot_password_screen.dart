import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/view/components/generic_field.dart';
import 'package:swaav/view/screens/check_email_screen.dart';

import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/validator.dart';
import '../components/button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 105.h,),
              Text(LocaleKeys.forgotPassword.tr(), style:
              TextStyles.textViewSemiBold30.copyWith(color: prussian),),
              SizedBox(height: 12.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.w),
                child: Text(LocaleKeys.toResetYourPassword.tr(),
                  style:   TextStyles.textViewRegular14.copyWith(color: gunmetal),
                    textAlign: TextAlign.center,),
              ),
              SizedBox(
                height: 58.h,
              ),
              SvgPicture.asset(forgotPassword),
              SizedBox(height: 10.h,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(LocaleKeys.email.tr(),style: TextStylesDMSans.textViewBold12.copyWith(color: gunmetal),),
              ),
              SizedBox(height: 10.h,),
              GenericField(
                hintText: "Brandonelouis@gmail.com",
                validation: (value) => Validator.email(value),
                onSaved: (value) {
                  email = value!;
                },
              ),
              SizedBox(height: 30.h,),
              GenericButton(
                  shadow: [
                    BoxShadow(
                        blurRadius: 9,
                        offset: Offset(0, 10),
                        color: verdigris.withOpacity(0.25))
                  ],
                  height: 70.h,
                  color: verdigris,
                  borderRadius: BorderRadius.circular(6),
                  width: double.infinity,
                  onPressed: () => AppNavigator.pushReplacement(context: context, screen: CheckEmailScreen()),
                  child: Text(
                    LocaleKeys.resetPassword.tr(),
                    style: TextStyles.textViewSemiBold16,
                  )),
              SizedBox(height: 10.h,),
              GenericButton(
                  shadow: [
                    BoxShadow(
                        blurRadius: 9,
                        offset: Offset(0, 10),
                        color: Color.fromRGBO(134, 141, 195, 0.53).withOpacity(0.25))
                  ],
                  height: 70.h,
                  color: Color.fromRGBO(134, 141, 195, 0.53),
                  borderRadius: BorderRadius.circular(6),
                  width: double.infinity,
                  onPressed: () => AppNavigator.pop(context: context),
                  child: Text(
                    LocaleKeys.backToLogin.tr(),
                    style: TextStyles.textViewSemiBold16,
                  )),
              SizedBox(height: 50.h,),
            ],
          ),
        ),
      ),
    );
  }
}
