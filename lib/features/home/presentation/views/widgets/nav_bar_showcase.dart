import 'package:bargainb/providers/tutorial_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/down_triangle_painter.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tooltips_keys.dart';
import 'skip_tutorial_button.dart';

class NavBarTutorial extends StatelessWidget {
  final BuildContext builder;
  const NavBarTutorial({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tutorialProvider = Provider.of<TutorialProvider>(context);
    return Showcase.withWidget(
      key: tutorialProvider.isTutorialRunning ? TooltipKeys.showCase1 : GlobalKey<State<StatefulWidget>>(),
      container: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            width: 180.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: purple70,
            ),
            child: Column(children: [
              Text(
                "Navigate easily with the navigation bar: Discover deals, access your sidekick, and manage your profile".tr(),
                style: TextStyles.textViewRegular16.copyWith(color: white),
              ),
              GestureDetector(
                onTap: () {
                  ShowCaseWidget.of(builder).next();
                  // ShowCaseWidget.of(builder).dismiss();
                },
                child: Row(
                  children: [
                    SkipTutorialButton(tutorialProvider: tutorialProvider, context: builder),
                    Spacer(),
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
          Container(
            height: 11,
            width: 13,
            child: CustomPaint(
              painter: DownTrianglePainter(
                strokeColor: purple70,
                strokeWidth: 1,
                paintingStyle: PaintingStyle.fill,
              ),
            ),
          ),
        ],
      ),
      height: 110.h,
      width: 190.h,
      child: Container(
        height: 0,
        color: Colors.transparent,
      ),
    );
  }
}
