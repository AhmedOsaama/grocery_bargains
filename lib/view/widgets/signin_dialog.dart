// ignore_for_file: use_build_context_synchronously

import 'package:bargainb/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/view/screens/profile_screen.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';
import '../screens/register_screen.dart';

class SigninDialog extends StatelessWidget {
  final String title;
  final String body;
  final String buttonText;

  const SigninDialog({
    Key? key,
    required this.title,
    required this.body,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, top: 16, right: 14, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              signinDialog,
              width: 230.w,
              height: 170.h,
            ),
            10.ph,
            Text(
              '$title',
              style: TextStyles.textViewSemiBold28.copyWith(color: black2),
            ),
            10.ph,
            Text(
              body,
              textAlign: TextAlign.center,
              style: TextStyles.textViewRegular16
                  .copyWith(color: Color.fromRGBO(72, 72, 72, 1)),
            ),
            10.ph,
            Row(
              children: [
                Expanded(
                    child: GenericButton(
                        color: Colors.white,
                        height: 60.h,
                        borderColor: Color.fromRGBO(237, 237, 237, 1),
                        borderRadius: BorderRadius.circular(6),
                        onPressed: () => AppNavigator.pop(context: context),
                        child: Text(
                          "Back",
                          style: TextStyles.textViewSemiBold16
                              .copyWith(color: darkGrey),
                        ))),
                10.pw,
                Expanded(
                    child: GenericButton(
                        color: yellow,
                        height: 60.h,
                        borderRadius: BorderRadius.circular(6),
                        onPressed: () {
                          AppNavigator.pushReplacement(
                              context: context, screen: RegisterScreen());
                        },
                        child: Text(
                          buttonText,
                          style: TextStyles.textViewSemiBold16
                              .copyWith(color: white),
                        ))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
