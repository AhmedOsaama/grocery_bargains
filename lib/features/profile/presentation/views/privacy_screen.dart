import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/policy_terms_widget.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/style_utils.dart';
import '../../../../utils/tracking_utils.dart';

enum Language { english, dutch }

class PrivacyScreen extends StatefulWidget {
  PrivacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
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
    TrackingUtils().trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Privacy Screen");
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
          builder: (context, snapshot) {
            return Stack(
              children: [
                (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
                snapshot.hasData
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            12.ph,
                            Text(
                              "Privacy".tr(),
                              style: TextStyles.textViewSemiBold26
                                  .copyWith(color: black2),
                            ),
                            23.ph,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "LocationServices".tr(),
                                  style: TextStyles.textViewMedium16
                                      .copyWith(color: black2),
                                ),
                                Switch.adaptive(
                                    value: snapshot.data!["privacy"]
                                        ["locationServices"],
                                    onChanged: (value) async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                          .update({
                                        "privacy": {
                                          "locationServices": value,
                                          "connectContacts":
                                              snapshot.data!["privacy"]
                                                  ["connectContacts"]
                                        }
                                      });
                                      setState(() {
                                        updateUserDataFuture();
                                      });
                                      TrackingUtils().trackBooleanToggleClicks(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), value, 'Location services', "Privacy Screen");
                                    })
                              ],
                            ),
                            Divider(),
                            Text(
                              "LocationServicesHelps2".tr(),
                              style: TextStyles.textViewMedium13
                                  .copyWith(color: Colors.grey),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "ConnectContacts".tr(),
                                  style: TextStyles.textViewMedium16
                                      .copyWith(color: black2),
                                ),
                                Switch.adaptive(
                                    value: snapshot.data!["privacy"]
                                        ["connectContacts"],
                                    onChanged: (value) async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        "privacy": {
                                          "locationServices":
                                              snapshot.data!["privacy"]
                                                  ["locationServices"],
                                          "connectContacts": value
                                        }
                                      });
                                      setState(() {
                                        updateUserDataFuture();
                                      });
                                      TrackingUtils().trackBooleanToggleClicks(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), value, 'Connect Contacts', "Privacy Screen");
                                    })
                              ],
                            ),
                            Divider(),
                            Text(
                              "ToHelpYouConnect".tr(),
                              style: TextStyles.textViewMedium13
                                  .copyWith(color: Colors.grey),
                            ),
                            Spacer(),
                            PolicyTermsWidget(),
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
