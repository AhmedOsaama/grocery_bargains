import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/view/screens/profile_screen.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

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
            if (snapshot.connectionState == ConnectionState.waiting) {
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
                    "Privacy",
                    style:
                        TextStyles.textViewSemiBold26.copyWith(color: black2),
                  ),
                  23.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Location services",
                        style:
                            TextStyles.textViewMedium16.copyWith(color: black2),
                      ),
                      Switch.adaptive(
                          value: snapshot.data!["privacy"]["locationServices"],
                          onChanged: (value) async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              "privacy": {
                                "locationServices": value,
                                "connectContacts": snapshot.data!["privacy"]
                                    ["connectContacts"]
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
                    "Location services helps us to offer persionalized reccomendations. It uses GPS, Bluetooth and crowd sources WI-FI hotspot and mobile phone locations to determine your approximate location. You can disconnect at any time and request for data to be deleted in support.",
                    style: TextStyles.textViewMedium13
                        .copyWith(color: Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Connect contacts",
                        style:
                            TextStyles.textViewMedium16.copyWith(color: black2),
                      ),
                      Switch.adaptive(
                          value: snapshot.data!["privacy"]["connectContacts"],
                          onChanged: (value) async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              "privacy": {
                                "locationServices": snapshot.data!["privacy"]
                                    ["locationServices"],
                                "connectContacts": value
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
                    "To help you connect to friends who also have accounts you can choose to have your contacts be synced and stored on your servers. You can disconnect it anytime.",
                    style: TextStyles.textViewMedium13
                        .copyWith(color: Colors.grey),
                  ),
                  Spacer(),
                  Center(
                    child: Text(
                      "Privacy Policy  |  Terms of Service",
                      style: TextStyles.textViewMedium10
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                  100.ph
                ],
              ),
            );
          }),
    );
  }
}
