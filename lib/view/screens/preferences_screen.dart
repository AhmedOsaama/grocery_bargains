import 'dart:developer';

import 'package:bargainb/utils/tracking_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

enum Language { english, dutch }

class PreferencesScreen extends StatefulWidget {
  PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  void updateUserDataFuture() {
    getUserDataFuture = FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  @override
  void initState() {
    updateUserDataFuture();
    TrackingUtils().trackPageVisited("Preferences Screen", FirebaseAuth.instance.currentUser!.uid);
    super.initState();
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
      body: FutureBuilder(
          future: getUserDataFuture,
          builder: (context, snap) {
            return Stack(
              children: [
                (snap.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
                snap.hasData
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            12.ph,
                            Text(
                              "Preferences".tr(),
                              style: TextStyles.textViewSemiBold26
                                  .copyWith(color: black2),
                            ),
                            23.ph,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "EmailMarketing".tr(),
                                  style: TextStyles.textViewMedium16
                                      .copyWith(color: black2),
                                ),
                                Switch.adaptive(
                                    thumbColor:
                                        MaterialStateProperty.all(mainPurple),
                                    value: snap.data!["preferences"]
                                        ["emailMarketing"],
                                    onChanged: (value) async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        "preferences": {
                                          "emailMarketing": value,
                                          "weekly": snap.data!["preferences"]
                                              ["weekly"],
                                          "daily": snap.data!["preferences"]
                                              ["daily"]
                                        }
                                      });
                                      setState(() {
                                        updateUserDataFuture();
                                      });
                                    })
                              ],
                            ),
                            Divider(),
                            Text(
                              "LocationServicesHelps".tr(),
                              style: TextStyles.textViewMedium13
                                  .copyWith(color: Colors.grey),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Daily".tr(),
                                  style: TextStyles.textViewMedium16
                                      .copyWith(color: black2),
                                ),
                                Switch.adaptive(
                                    thumbColor: !snap.data!["preferences"]
                                            ["emailMarketing"]
                                        ? MaterialStateProperty.all(grey)
                                        : MaterialStateProperty.all(mainPurple),
                                    value: snap.data!["preferences"]["daily"],
                                    onChanged: (value) async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        "preferences": {
                                          "emailMarketing":
                                              snap.data!["preferences"]
                                                  ["emailMarketing"],
                                          "weekly": snap.data!["preferences"]
                                              ["weekly"],
                                          "daily": value
                                        }
                                      });
                                      setState(() {
                                        updateUserDataFuture();
                                      });
                                    })
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Weekly".tr(),
                                  style: TextStyles.textViewMedium16
                                      .copyWith(color: black2),
                                ),
                                Switch.adaptive(
                                    value: snap.data!["preferences"]["weekly"],
                                    thumbColor: !snap.data!["preferences"]
                                            ["emailMarketing"]
                                        ? MaterialStateProperty.all(grey)
                                        : MaterialStateProperty.all(mainPurple),
                                    onChanged: (value) async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        "preferences": {
                                          "emailMarketing":
                                              snap.data!["preferences"]
                                                  ["emailMarketing"],
                                          "weekly": value,
                                          "daily": snap.data!["preferences"]
                                              ["daily"]
                                        }
                                      });
                                      setState(() {
                                        updateUserDataFuture();
                                      });
                                    })
                              ],
                            ),
                            Divider(),
                            Text(
                              "ChangeFrequency".tr(),
                              style: TextStyles.textViewMedium13
                                  .copyWith(color: Colors.grey),
                            ),
                            Spacer(),
                            Center(
                                child: TextButton(
                                    onPressed: () async {
                                      final url = Uri.parse(
                                          'https://thebargainb.com/privacy-policy');
                                      try {
                                        await launchUrl(url);
                                      } catch (e) {
                                        log(e.toString());
                                      }
                                    },
                                    child: Text(
                                      "PrivacyPolicy".tr(),
                                      style: TextStyles.textViewMedium10
                                          .copyWith(color: Colors.grey),
                                    ))),
                            100.ph
                          ],
                        ),
                      )
                    : Container(),
              ],
            );
          }),
    );
  }
}
