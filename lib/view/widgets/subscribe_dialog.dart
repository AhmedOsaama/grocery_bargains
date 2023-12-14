import 'package:bargainb/features/onboarding/presentation/views/confirm_subscription_screen.dart';
import 'package:bargainb/features/profile/presentation/views/subscription_screen.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/screens/subscription_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/tracking_utils.dart';
import '../components/button.dart';
import '../screens/register_screen.dart';

class SubscribeDialog extends StatefulWidget {
  final String title;
  final String body;
  final String buttonText;

  const SubscribeDialog({
    Key? key,
    required this.title,
    required this.body,
    required this.buttonText,
  }) : super(key: key);

  @override
  State<SubscribeDialog> createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<SubscribeDialog> {
  @override
  void initState() {
    try {
      TrackingUtils().trackPopPageView(
          "Guest", DateTime.now().toUtc().toString(), "Sign in popup");
    }catch(e){
      print(e);
    }
    super.initState();
  }

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
              '${widget.title}',
              style: TextStyles.textViewSemiBold28.copyWith(color: black2),
            ),
            10.ph,
            Text(
              widget.body,
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
                          "Back".tr(),
                          style: TextStyles.textViewSemiBold16
                              .copyWith(color: darkGrey),
                        ))),
                10.pw,
                Expanded(
                    child: GenericButton(
                        color: yellow,
                        height: 60.h,
                        borderRadius: BorderRadius.circular(6),
                        onPressed: () async {
                          AppNavigator.pop(context: context);
                          pushNewScreen(context,
                              screen: SubscriptionScreen(), withNavBar: true);
                          // pushNewScreen(context, screen: ConfirmSubscriptionScreen());

                        },
                        child: Text(
                          widget.buttonText,
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
