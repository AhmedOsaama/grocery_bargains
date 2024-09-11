import 'dart:io';

import 'package:bargainb/features/profile/data/models/User.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/features/profile/presentation/views/subscription_screen.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../config/routes/app_navigator.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../../providers/tutorial_provider.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/icons_manager.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../home/presentation/views/main_screen.dart';
import '../settings_screen.dart';
import '../support_screen.dart';
import '../../../../../view/widgets/setting_row.dart';

class ProfileSettingsWidget extends StatelessWidget {
  final String userStatus;
  final Function editProfile;
  const ProfileSettingsWidget ({Key? key, required this.userStatus, required this.editProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      SettingRow(
          icon: Icon(Icons.star, color: primaryGreen,),
          settingText: "Rate Us".tr(),
          onTap: () async {
            Uri url =  Uri.parse(
                Platform.isIOS ?
                'https://apps.apple.com/us/app/bargainb-grocery-savings/id6446258008'
                    : 'https://play.google.com/store/apps/details?id=thebargainb.app');
            if(await canLaunchUrl(url)) {
              launchUrl(
                  url,
                mode: LaunchMode.externalApplication
              );
            }else{
              throw "Can't launch url";
            }
            TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid,
                "Open google/apple store rating page", DateTime.now().toUtc().toString(), "Profile screen");
          }),
        const Divider(),
        SettingRow(
          icon: Icon(
            Icons.person,
            color: primaryGreen,
          ),
          settingText: "Your Status",
          value: userStatus,
          onTap: () {
            editProfile();
            TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "open status",
                DateTime.now().toUtc().toString(), "Profile screen");
          },
        ),
        10.ph,
        SettingRow(
          icon: SvgPicture.asset(
            masterCard,
            color: primaryGreen,
          ),
          settingText: "Subscription",
          onTap: () {
            pushNewScreen(context, screen: SubscriptionScreen());
            TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid,
                "Open Subscription screen", DateTime.now().toUtc().toString(), "Profile screen");
          },
        ),
        10.ph,
        SettingRow(
          icon: Icon(
            Icons.settings_outlined,
            color: primaryGreen,
          ),
          settingText: LocaleKeys.settings.tr(),
          onTap: () {
            AppNavigator.push(context: context, screen: SettingsScreen());
            TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid,
                "Open Settings screen", DateTime.now().toUtc().toString(), "Profile screen");
          },
        ),
        10.ph,
        SettingRow(
            icon: SvgPicture.asset(tutorial, color: primaryGreen,),
            settingText: "Tutorial".tr(),
            onTap: () {
              Provider.of<TutorialProvider>(context, listen: false).setTutorialStatus(false);
              Provider.of<TutorialProvider>(context, listen: false).activateWelcomeTutorial();
              NavigatorController.jumpToTab(0);
              TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid,
                  "Activate tutorial", DateTime.now().toUtc().toString(), "Profile screen");
            }),
        10.ph,
        SettingRow(
            icon: Icon(
              Icons.help_outline_outlined,
              color: primaryGreen,
            ),
            settingText: LocaleKeys.support.tr(),
            onTap: () {
              pushNewScreen(context, screen: const SupportScreen(), withNavBar: true);
              TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid,
                  "Open Support screen", DateTime.now().toUtc().toString(), "Profile screen");
            }),
        10.ph,
      // SettingRow(
      //     icon: const Icon(
      //       Icons.logout,
      //       color: mainPurple,
      //     ),
      //     settingText: LocaleKeys.signout.tr(),
      //     onTap: () {
      //       // pushNewScreen(context, screen: SupportScreen(), withNavBar: true);
      //       TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid,
      //           "Open Support screen", DateTime.now().toUtc().toString(), "Profile screen");
      //     })
    ],
    );
  }
}
