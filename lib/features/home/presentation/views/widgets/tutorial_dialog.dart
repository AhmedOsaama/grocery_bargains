import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../../config/routes/app_navigator.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../../providers/tutorial_provider.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/icons_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tooltips_keys.dart';

class TutorialDialog extends StatelessWidget {
  final BuildContext showcaseContext;
  const TutorialDialog({Key? key, required this.showcaseContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final tutorialProvider = Provider.of<TutorialProvider>(context);
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(15),
        width: ScreenUtil().screenWidth * 0.95,
        height: 250.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: purple70,
        ),
        child: Column(children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${LocaleKeys.welcome.tr()}!",
                  style: TextStyles.textViewSemiBold24.copyWith(color: white),
                ),
                GestureDetector(
                    onTap: () {
                      skipTutorial(context, showcaseContext);
                    },
                    child: SvgPicture.asset(closeCircle))
              ],
            ),
          ),
          Expanded(
            child: Text(
              "Let's take a quick tour of our app's features before diving into your AI sidekick".tr(),
              maxLines: 4,
              style: TextStyles.textViewRegular16.copyWith(color: white),
            ),
          ),
          GestureDetector(
            onTap: () {
              startHomeTutorial(context, showcaseContext);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  LocaleKeys.next.tr(),
                  style: TextStyles.textViewSemiBold14.copyWith(color: white),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: white,
                  size: 15.sp,
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
  void startHomeTutorial(BuildContext context, BuildContext builder) {
    AppNavigator.pop(context: context);
    try {
      ShowCaseWidget.of(builder).startShowCase([TooltipKeys.showCase1, TooltipKeys.showCase2]);
    } catch (e) {
      log(e.toString());
    }
    Provider.of<TutorialProvider>(context, listen: false).startTutorial();
  }

  void skipTutorial(BuildContext context, BuildContext builder) {
    AppNavigator.pop(context: context);
    Provider.of<TutorialProvider>(context, listen: false).stopTutorial(builder);
  }
}
