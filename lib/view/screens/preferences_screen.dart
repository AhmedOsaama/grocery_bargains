import 'dart:developer';

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
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.ph,
                  Text(
                    "Preferences",
                    style:
                        TextStyles.textViewSemiBold26.copyWith(color: black2),
                  ),
                  23.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email marketing",
                        style:
                            TextStyles.textViewMedium16.copyWith(color: black2),
                      ),
                      Switch.adaptive(
                          value: snap.data!["preferences"]["emailMarketing"],
                          onChanged: (value) async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              "preferences": {
                                "emailMarketing": value,
                                "weekly": snap.data!["preferences"]["weekly"],
                                "daily": snap.data!["preferences"]["daily"]
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
                    "Location services helps us to offer persionalized reccomendations",
                    style: TextStyles.textViewMedium13
                        .copyWith(color: Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Daily",
                        style:
                            TextStyles.textViewMedium16.copyWith(color: black2),
                      ),
                      Switch.adaptive(
                          value: snap.data!["preferences"]["daily"] &&
                              snap.data!["preferences"]["emailMarketing"],
                          onChanged: (value) async {
                            if (snap.data!["preferences"]["emailMarketing"]) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "preferences": {
                                  "emailMarketing": snap.data!["preferences"]
                                      ["emailMarketing"],
                                  "weekly": snap.data!["preferences"]["weekly"],
                                  "daily": value
                                }
                              });
                              setState(() {
                                updateUserDataFuture();
                              });
                            }
                          })
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Weekly",
                        style:
                            TextStyles.textViewMedium16.copyWith(color: black2),
                      ),
                      Switch.adaptive(
                          value: snap.data!["preferences"]["weekly"] &&
                              snap.data!["preferences"]["emailMarketing"],
                          onChanged: (value) async {
                            if (snap.data!["preferences"]["emailMarketing"]) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "preferences": {
                                  "emailMarketing": snap.data!["preferences"]
                                      ["emailMarketing"],
                                  "weekly": value,
                                  "daily": snap.data!["preferences"]["daily"]
                                }
                              });
                              setState(() {
                                updateUserDataFuture();
                              });
                            }
                          })
                    ],
                  ),
                  Divider(),
                  Text(
                    "Change the frequency of your emails",
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
                            "Privacy Policy  |  Terms of Service",
                            style: TextStyles.textViewMedium10
                                .copyWith(color: Colors.grey),
                          ))),
                  100.ph
                ],
              ),
            );
          }),
    );
  }
}
