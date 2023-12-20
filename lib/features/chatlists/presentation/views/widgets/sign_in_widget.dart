import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../view/components/button.dart';
import '../../../../../view/components/dotted_container.dart';
import '../../../../../view/screens/register_screen.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          chatlistBackground,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            50.ph,
            DottedContainer(text: "Sign In to Use Chatlists"),
            SizedBox(
              height: 100.h,
            ),
            GenericButton(
              borderRadius: BorderRadius.circular(6),
              color: mainYellow,
              height: 60.h,
              width: 158.w,
              onPressed: () => pushNewScreen(context, screen: RegisterScreen(isLogin: false), withNavBar: false),
              child: Text(
                "Sign in",
                style: TextStyles.textViewSemiBold16.copyWith(color: white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
