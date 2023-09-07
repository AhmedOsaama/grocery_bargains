import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/screens/settings_screen.dart';
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

class LanguageScreen extends StatefulWidget {
  LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  void updateUserDataFuture() {
    getUserDataFuture = FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  @override
  void initState() {
    TrackingUtils().trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Language Screen");
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
        leading: IconButton(
            onPressed: () {
              AppNavigator.pushReplacement(
                  context: context, screen: SettingsScreen());
            },
            icon: Icon(
              Icons.arrow_back,
              color: black,
            )),
        title: Text(
          LocaleKeys.language.tr(),
          style: TextStyles.textViewSemiBold16.copyWith(color: black1),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          AppNavigator.pushReplacement(
              context: context, screen: SettingsScreen());
          return Future.value(true);
        },
        child: FutureBuilder(
            future: getUserDataFuture,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (ScreenUtil().screenHeight / 3).round().toInt().ph,
                    CircularProgressIndicator(),
                  ],
                ));
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    32.ph,
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'language': "en",
                        });
                        context.setLocale(Locale('en'));
                        setState(() {
                          updateUserDataFuture();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "English",
                            style: TextStyles.textViewMedium16
                                .copyWith(color: black2),
                          ),
                          snap.data!["language"] == "en"
                              ? Icon(
                                  Icons.done,
                                  color: mainPurple,
                                )
                              : SizedBox(
                                  width: 1,
                                )
                        ],
                      ),
                    ),
                    23.ph,
                    Divider(),
                    23.ph,
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'language': "nl",
                        });
                        context.setLocale(Locale('nl'));
                        setState(() {
                          updateUserDataFuture();
                        });
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Dutch",
                              style: TextStyles.textViewMedium16
                                  .copyWith(color: black2),
                            ),
                            snap.data!["language"] != "en"
                                ? Icon(
                                    Icons.done,
                                    color: mainPurple,
                                  )
                                : SizedBox(
                                    width: 5,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
