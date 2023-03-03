import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/providers/google_sign_in_provider.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/screens/invite_screen.dart';
import 'package:swaav/view/screens/register_screen.dart';
import 'package:swaav/view/screens/settings_screen.dart';
import 'package:swaav/view/screens/support_screen.dart';
import 'package:swaav/view/widgets/backbutton.dart';
import 'package:swaav/view/widgets/setting_row.dart';

import '../../utils/assets_manager.dart';
import '../../utils/utils.dart';
import '../components/generic_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  @override
  void initState() {
    getUserDataFuture = FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    super.initState();
  }

  bool isEditing = false;
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.2,
        backgroundColor: Colors.white,
        title: Text(
          LocaleKeys.profile.tr(),
          style: TextStyles.textViewSemiBold16.copyWith(color: black1),
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  isEditing = !isEditing;
                });
              },
              child: Text(
                LocaleKeys.edit.tr(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.sp),
              ))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.ph,
              FutureBuilder(
                  future: getUserDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    return snapshot.data!['imageURL'] != ""
                        ? Center(
                          child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(snapshot.data!['imageURL']),
                                  radius: 100,
                                ),
                                10.ph,
                                if(!isEditing)
                                  ...[
                                Text(
                                  snapshot.data!['username'],
                                  style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                4.ph,
                                Text(
                                  snapshot.data!['email'],
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey),
                                ),
                                  ],
                              ],
                            ),
                        )
                        : SvgPicture.asset(personIcon);
                  }),
              30.ph,
              if(!isEditing) ...[
              SettingRow(
                  icon: SvgPicture.asset(
                    masterCard,
                  ),
                  settingText: LocaleKeys.settings.tr(),
                  route: SettingsScreen()),
              Divider(),
              10.ph,
              SettingRow(
                  icon: const Icon(
                    Icons.help_outline_outlined,
                  ),
                  settingText: LocaleKeys.support.tr(),
                  route: SupportScreen()),
              Divider(),
              10.ph,
              GestureDetector(
                  onTap: () => showDialog(
                      context: context,
                      builder: (ctx) => Dialog(
                            child: Container(),
                          )),
                  child: SettingRow(
                      icon: const Icon(
                        Icons.logout_outlined,
                      ),
                      settingText: LocaleKeys.signout.tr())),
              10.ph,
              Divider(),
            60.ph,
          ],
              if(isEditing)
                ...[
                  Text(LocaleKeys.yourName.tr(),style: TextStylesDMSans.textViewBold12.copyWith(color: black1),),
                  10.ph,
                  GenericField(
                    hintText: "Dina Tairovic",
                    boxShadow: Utils.boxShadow[0],
                    colorStyle: Color.fromRGBO(237, 237, 237, 1),
                  ),
                  20.ph,
                  Text(LocaleKeys.email.tr(),style: TextStylesDMSans.textViewBold12.copyWith(color: black1),),
                  10.ph,
                  GenericField(
                    hintText: "dina@me.com",
                    boxShadow: Utils.boxShadow[0],
                    colorStyle: Color.fromRGBO(237, 237, 237, 1),
                  ),
                ]
            ],
          ),
        ),
      ),
    );
  }
}

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(height: toDouble().h);
  SizedBox get pw => SizedBox(width: toDouble().w);
}
