import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/view/screens/language_screen.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/screens/preferences_screen.dart';
import 'package:bargainb/view/screens/privacy_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/view/widgets/profile_dialog.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/tracking_utils.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  @override
  void initState() {
    updateUserDataFuture();
    TrackingUtils().trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Settings screen");

    super.initState();
  }

  void updateUserDataFuture() {
    getUserDataFuture = FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // leading: backButt,
        title: Text(
          LocaleKeys.settings.tr(),
          style: TextStyles.textViewSemiBold16.copyWith(color: black1),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            32.ph,
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                AppNavigator.push(context: context, screen: PrivacyScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Privacy".tr(),
                    style: TextStyles.textViewMedium16.copyWith(color: black2),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: mainPurple,
                  )
                ],
              ),
            ),
            23.ph,
            const Divider(),
            23.ph,
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                AppNavigator.push(
                    context: context, screen: PreferencesScreen());
                TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open Preferences screen", DateTime.now().toUtc().toString(), "Profile screen");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Preferences".tr(),
                    style: TextStyles.textViewMedium16.copyWith(color: black2),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: mainPurple,
                  )
                ],
              ),
            ),
            23.ph,
            const Divider(),
            23.ph,
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                AppNavigator.pushReplacement(
                    context: context, screen: LanguageScreen());
                TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open Language screen", DateTime.now().toUtc().toString(), "Profile screen");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.language.tr(),
                    style: TextStyles.textViewMedium16.copyWith(color: black2),
                  ),
                  FutureBuilder(
                      future: getUserDataFuture,
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Icon(
                            Icons.arrow_forward_ios,
                            color: mainPurple,
                          );
                        }
                        return Row(
                          children: [
                            Text(
                             context.locale.languageCode == "en"
                                  ? "English"
                                  : "Dutch",
                              style: TextStyles.textViewMedium17
                                  .copyWith(color: Colors.grey),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: mainPurple,
                            ),
                          ],
                        );
                      })
                ],
              ),
            ),
            const Spacer(),
            GenericButton(
              onPressed: () async {
                bool isSignedOut = await showDialog(
                  context: context,
                  builder: (ctx) => ProfileDialog(
                        title: LocaleKeys.signout.tr(),
                        body: LocaleKeys.logoutFromAccount.tr(),
                        buttonText: LocaleKeys.signout.tr(),
                        isSigningOut: true,
                      ));
                if(isSignedOut) {
                  AppNavigator.popToFrist(context: context);
                  NavigatorController.jumpToTab(0);
                }
                TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Signout", DateTime.now().toUtc().toString(), "Profile screen");
              },
              width: double.infinity,
              height: 60.h,
              borderRadius: BorderRadius.circular(6),
              borderColor: const Color.fromRGBO(137, 137, 137, 1),
              child: Text(
                LocaleKeys.signout.tr().toUpperCase(),
                style: TextStylesInter.textViewBold14.copyWith(color: black2),
              ),
              color: Colors.white,
            ),
            10.ph,
            GenericButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => ProfileDialog(
                        title: LocaleKeys.deleteYourAccount.tr(),
                        body: LocaleKeys.allDataWillBeRemoved.tr(),
                        buttonText: LocaleKeys.delete.tr(),
                        isSigningOut: false,
                      ));
                TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Delete Account", DateTime.now().toUtc().toString(), "Profile screen");
              },
              width: double.infinity,
              height: 60.h,
              borderRadius: BorderRadius.circular(6),
              borderColor: const Color.fromRGBO(137, 137, 137, 1),
              child: Text(
                LocaleKeys.deleteMyAccount.tr(),
                style: TextStylesInter.textViewBold14.copyWith(color: black2),
              ),
              color: Colors.white,
            ),
            10.ph,
          ],
        ),
      ),
    );
  }
}
