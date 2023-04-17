import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/utils/assets_manager.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 105.h,
              ),
              Text(
                LocaleKeys.checkEmail.tr(),
                style: TextStyles.textViewSemiBold30.copyWith(color: prussian),
              ),
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.w),
                child: Text(
                  LocaleKeys.weHaveSentResetPassword.tr() +
                      " brandonlouis@gmail.com",
                  style: TextStyles.textViewRegular14.copyWith(color: gunmetal),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 58.h,
              ),
              SvgPicture.asset(verifyEmail),
              SizedBox(
                height: 100.h,
              ),
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
                  onPressed: () {},
                  child: Text(
                    LocaleKeys.openEmail.tr(),
                    style: TextStyles.textViewSemiBold16,
                  )),
              SizedBox(
                height: 10.h,
              ),
              GenericButton(
                  shadow: [
                    BoxShadow(
                        blurRadius: 9,
                        offset: Offset(0, 10),
                        color: Color.fromRGBO(134, 141, 195, 0.53)
                            .withOpacity(0.25))
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
              SizedBox(
                height: 15.h,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Text.rich(
                    TextSpan(
                        text: LocaleKeys.youHaveNotReceivedEmail.tr(),
                        style: TextStylesDMSans.textViewRegular12.copyWith(
                          color: Color.fromRGBO(82, 75, 107, 1),
                        ),
                        children: [
                          TextSpan(
                              text: LocaleKeys.resend.tr(),
                              style: TextStyles.textViewRegular12.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: Color.fromRGBO(255, 146, 40, 1)))
                        ]),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
