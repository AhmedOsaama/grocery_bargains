import 'dart:developer';
import 'dart:io';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/providers/google_sign_in_provider.dart';
import 'package:bargainb/view/screens/subscription_screen.dart';
import 'package:bargainb/view/widgets/otp_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/screens/settings_screen.dart';
import 'package:bargainb/view/screens/support_screen.dart';
import 'package:bargainb/view/widgets/setting_row.dart';
import 'package:provider/provider.dart';

import '../../utils/assets_manager.dart';
import '../widgets/image_source_picker_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  @override
  void initState() {
    updateUserDataFuture();
    super.initState();
  }

  void updateUserDataFuture() {
    getUserDataFuture = FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  bool isEditing = false;
  bool isEdited = false;
  bool isPhoneEdited = false;
  String name = "";
  String phone = "";
  String status = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<GoogleSignInProvider>(builder: (ctx, provider, _) {
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
                onPressed: () async {
                  if (isEditing && isEdited) {
                    Map<String, Object?> data = {};

                    if (name.isNotEmpty) {
                      data.addAll({'username': name});
                    }
                    if (status.isNotEmpty) {
                      data.addAll({'status': status});
                    }
                    log(phone);
                    if (phone.isNotEmpty && isPhoneEdited) {
                      await verifyPhoneNumber(phone);
                    }
                    if (!isPhoneEdited) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update(data);
                      setState(() {
                        updateUserDataFuture();
                      });
                    }
                  }
                  if (!isPhoneEdited || !isEditing)
                    setState(() {
                      isEditing = !isEditing;
                      isEdited = !isEdited;
                    });
                },
                child: Text(
                  isEditing ? "Save" : LocaleKeys.edit.tr(),
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 17.sp),
                ))
          ],
          leading: isEditing
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: mainPurple,
                  ))
              : Container(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: FutureBuilder(
                  future: getUserDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        24.ph,
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    getUserImage(snapshot) as ImageProvider,
                                radius: isEditing ? 50 : 100,
                              ),
                              if (isEditing) ...[
                                TextButton(
                                    onPressed: () async {
                                      ImageSource sourcePicker =
                                          Platform.isAndroid
                                              ? await showModalBottomSheet(
                                                  context: context,
                                                  builder: (ctx) =>
                                                      ImageSourcePickerSheet())
                                              : await showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (ctx) =>
                                                      ImageSourcePickerSheet());
                                      // if(sourcePicker == ImageSource.gallery){
                                      try {
                                        final image = await ImagePicker()
                                            .pickImage(source: sourcePicker);
                                        if (image == null) return;
                                        final imageFile = File(image.path);
                                        final userImageRef = FirebaseStorage
                                            .instance
                                            .ref()
                                            .child('user_image')
                                            .child(
                                                '${FirebaseAuth.instance.currentUser!.uid}.jpg');
                                        await userImageRef
                                            .putFile(imageFile)
                                            .whenComplete(() => null);
                                        final url =
                                            await userImageRef.getDownloadURL();
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          'imageURL': url,
                                        });
                                        setState(() {
                                          updateUserDataFuture();
                                        });
                                      } on PlatformException catch (e) {
                                        print("Failed to pick image: $e");
                                      }
                                      // }
                                    },
                                    child: Text(
                                      "Change",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17.sp,
                                          color: mainPurple),
                                    ))
                              ],
                              !isEditing ? 10.ph : Container(),
                              if (!isEditing) ...[
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
                        ),
                        30.ph,
                        if (!isEditing) ...[
                          SettingRow(
                            icon: Icon(
                              Icons.person,
                              color: mainPurple,
                            ),
                            settingText: "Your Status",
                            value: snapshot.data!['status'],
                            onTap: () => {
                              setState(() {
                                isEditing = !isEditing;
                              })
                            },
                          ),
                          Divider(),
                          10.ph,
                          SettingRow(
                            icon: SvgPicture.asset(
                              masterCard,
                              color: mainPurple,
                            ),
                            settingText: "Subscription",
                            onTap: () => AppNavigator.push(
                                context: context, screen: SubscriptionScreen()),
                          ),
                          Divider(),
                          10.ph,
                          SettingRow(
                            icon: Icon(
                              Icons.settings,
                              color: mainPurple,
                            ),
                            settingText: LocaleKeys.settings.tr(),
                            onTap: () => AppNavigator.push(
                                context: context, screen: SettingsScreen()),
                          ),
                          Divider(),
                          10.ph,
                          SettingRow(
                            icon: const Icon(
                              Icons.help_outline_outlined,
                              color: mainPurple,
                            ),
                            settingText: LocaleKeys.support.tr(),
                            onTap: () => AppNavigator.push(
                                context: context, screen: SupportScreen()),
                          ),
                        ],
                        if (isEditing) ...[
                          Text(
                            "Name",
                            style: TextStylesDMSans.textViewMedium13
                                .copyWith(color: Colors.grey),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                name = value;
                                isEdited = true;
                              });
                            },
                            initialValue: snapshot.data!['username'],
                          ),
                          20.ph,
                          Text(
                            LocaleKeys.phone.tr(),
                            style: TextStylesDMSans.textViewMedium13
                                .copyWith(color: Colors.grey),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                phone = value;
                                isPhoneEdited = true;
                              });
                            },
                            initialValue: snapshot.data!['phoneNumber'],
                            decoration:
                                InputDecoration(hintText: "+31 (097) 999-9999"),
                          ),
                          20.ph,
                          Text(
                            "Your Status",
                            style: TextStylesDMSans.textViewMedium13
                                .copyWith(color: Colors.grey),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                status = value;
                                isEdited = true;
                              });
                            },
                            initialValue:
                                snapshot.data!['status'].toString().isEmpty
                                    ? status
                                    : snapshot.data!['status'],
                          ),
                          10.ph,
                        ]
                      ],
                    );
                  }),
            ),
          ),
        ),
      );
    });
  }

  Object getUserImage(
      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    return snapshot.data!['imageURL'] != ""
        ? NetworkImage(snapshot.data!['imageURL'])
        : AssetImage(personImage);
  }

  Future<void> verifyPhoneNumber(String phone) async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isEqualTo: phone)
        .get();
    if (result.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
              "Phone number is already registered with another account. Please enter a different phone number")));
      return;
    }
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (phoneCredential) {},
        verificationFailed: (e) {
          log("failed");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
        },
        codeSent: (String verificationId, int? resendToken) async {
          var otp = await showOtpDialog();

          String smsCode = otp;
          log(smsCode);
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            Map<String, Object?> data = {};

            data.addAll({'phoneNumber': phone});
            if (name.isNotEmpty) {
              data.addAll({'username': name});
            }
            if (status.isNotEmpty) {
              data.addAll({'status': status});
            }
            await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update(data);
            setState(() {
              updateUserDataFuture();
              isEditing = !isEditing;
              isEdited = !isEdited;
            });
          } on FirebaseAuthException catch (e) {
            log(e.message!);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).colorScheme.error,
                content: Text(e.message ??
                    "The verification code from SMS/TOTP is invalid. Please check and enter the correct verification code again.")));
          }
        },
        codeAutoRetrievalTimeout: (message) {});
  }

  Future showOtpDialog() async {
    return await showDialog(
        context: context,
        builder: (ctx) => OtpDialog(
              phoneNumber: phone,
              resendOtp: () => verifyPhoneNumber(phone),
              isSignUp: false,
            ));
  }
}

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(height: toDouble().h);
  SizedBox get pw => SizedBox(width: toDouble().w);
}
