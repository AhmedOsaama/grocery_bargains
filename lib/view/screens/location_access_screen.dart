import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/tutorial_provider.dart';
import 'package:bargainb/providers/user_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:gdpr_dialog/gdpr_dialog.dart';

class LocationAccessScreen extends StatelessWidget {
  LocationAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70.h,
              ),
              SvgPicture.asset(bargainbIcon),
              25.ph,
              Text(
                LocaleKeys.dataAccess.tr(),
                style: TextStyles.textViewSemiBold28.copyWith(color: blackSecondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                  LocaleKeys.itIsImportantToUnderstandWhy.tr(),
                  style: TextStyles.textViewRegular14.copyWith(color: gunmetal),
              ),
              // 16.ph,
              Text(
                  LocaleKeys.bargainBUsesLocationData.tr(),
                style: TextStyles.textViewRegular14.copyWith(color: gunmetal),
              ),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse(
                                  'https://thebargainb.com/privacy-policy');
                              try {
                                await launchUrl(url);
                              } catch (e) {
                                log(e.toString());
                              }
                            },
                          text: ' ' + LocaleKeys.privacyPolicy.tr(),
                          style: TextStyles.textViewRegular14
                              .copyWith(color: mainPurple))
                    ],
                    style: TextStyles.textViewRegular14.copyWith(color: gunmetal),
                    text:
                    LocaleKeys.forFullDetailsOnDataUsage.tr(),
                ),
              ),
              // Text(
              //   LocaleKeys.forFullDetailsOnDataUsage.tr(),
              //   style: TextStyles.textViewRegular14.copyWith(color: gunmetal),
              //   textAlign: TextAlign.center,
              // ),
              20.ph,
              GenericButton(
                borderRadius: BorderRadius.circular(6),
                // borderColor: borderColor,
                color: mainYellow,
                height: 60.h,
                width: double.infinity,
                onPressed: () async {
                  if (await AppTrackingTransparency.trackingAuthorizationStatus ==
                      TrackingStatus.notDetermined) {
                    await AppTrackingTransparency.requestTrackingAuthorization();
                  }
                  AppNavigator.pushReplacement(
                      context: context, screen: MainScreen());
                  Provider.of<UserProvider>(context, listen: false).turnOffFirstTime();
                  Provider.of<TutorialProvider>(context, listen: false).activateWelcomeTutorial();
                },
                child: Text(
                    LocaleKeys.accept.tr(),
                  style: TextStyles.textViewSemiBold16.copyWith(color: white),
                ),
              ),
              10.ph,
              GenericButton(
                borderRadius: BorderRadius.circular(6),
                borderColor: borderColor,
                color: Colors.transparent,
                height: 60.h,
                width: double.infinity,
                onPressed: () async {
                  exit(1);
                },
                child: Text(
                  LocaleKeys.cancelAndExit.tr(),
                  style: TextStyles.textViewSemiBold16.copyWith(color: black),
                ),
              ),
              30.ph,
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
