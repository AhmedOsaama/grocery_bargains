import 'dart:developer';
import 'dart:io';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/profile/presentation/views/widgets/profile_settings_widget.dart';
import 'package:bargainb/features/profile/presentation/views/widgets/user_image_widget.dart';
import 'package:bargainb/providers/google_sign_in_provider.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/screens/register_screen.dart';
import 'package:bargainb/view/screens/subscription_screen.dart';
import 'package:bargainb/view/screens/support_screen.dart';
import 'package:bargainb/view/widgets/otp_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../providers/tutorial_provider.dart';
import '../../../../utils/assets_manager.dart';
import '../../../../view/widgets/image_source_picker_dialog.dart';

class ProfileScreen extends StatefulWidget {
  bool isEditing;
  bool isBackButton;
  ProfileScreen({Key? key, this.isEditing = false, this.isBackButton = false}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  bool isEditing = false;
  bool isEdited = false;
  bool isPhoneEdited = false;
  String name = "";
  String phone = "";
  String status = "";

  @override
  void initState() {
    updateUserDataFuture();
    TrackingUtils()
        .trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Profile Screen");
    isEditing = widget.isEditing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 250.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topLeft,
                  image: AssetImage(ellipses)),
              borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(100,20)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.fromRGBO(255, 255, 255, 1), Color.fromRGBO(52, 99, 237, 1)]
              ),
            ),
            // child: SvgPicture.asset(ellipses),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                  if (snapshot.data!.data() == null) buildNoProfileData(context);
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        70.ph,
                        Center(child: Text(LocaleKeys.profile.tr(), style: TextStylesInter.textViewSemiBold18.copyWith(color: Colors.white),)),
                        80.ph,
                        UserImageWidget(
                          userProfileSnapshot: snapshot,
                          updateUserDataFuture: updateUserDataFuture,
                        ),
                        if(isEditing)
                          buildCancelSaveChangesRow(),
                        30.ph,
                        if (!isEditing) ProfileSettingsWidget(snapshot: snapshot, editProfile: switchEditProfile),
                        if (isEditing) ...buildProfileTextFields(snapshot)
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  List<Widget> buildProfileTextFields(AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    return [
      Text(
        "Name".tr(),
        style: TextStylesDMSans.textViewMedium13.copyWith(color: Colors.grey),
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
        style: TextStylesDMSans.textViewMedium13.copyWith(color: Colors.grey),
      ),
      TextFormField(
        onChanged: (value) {
          setState(() {
            phone = value;
            isPhoneEdited = true;
            isEdited = true;
          });
        },
        initialValue: snapshot.data!['phoneNumber'],
        decoration: InputDecoration(hintText: "+31 (097) 999-9999"),
      ),
      20.ph,
      Text(
        "YourStatus".tr(),
        style: TextStylesDMSans.textViewMedium13.copyWith(color: Colors.grey),
      ),
      TextFormField(
        onChanged: (value) {
          setState(() {
            status = value;
            isEdited = true;
          });
        },
        initialValue: snapshot.data!['status'].toString().isEmpty ? status : snapshot.data!['status'],
      ),
      10.ph,
    ];
  }

  void switchEditProfile() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Row buildCancelSaveChangesRow() {
    return Row(
      children: [
        if (isEditing)
          TextButton(
              onPressed: () async {
                try {
                  TrackingUtils().trackTextLinkClicked(FirebaseAuth.instance.currentUser!.uid,
                      DateTime.now().toUtc().toString(), "Profile screen", "Cancel profile editing");
                } catch (e) {
                  print(e);
                }
                setState(() {
                  isEditing = !isEditing;
                });
              },
              child: Text(LocaleKeys.cancel.tr())),
        Spacer(),
        if (isEditing)
          TextButton(
              onPressed: () async {
                await saveProfileChanges();
                try {
                  TrackingUtils().trackTextLinkClicked(FirebaseAuth.instance.currentUser!.uid,
                      DateTime.now().toUtc().toString(), "Profile screen", "Save profile edits");
                } catch (e) {
                  print(e);
                }
              },
              child: Text(LocaleKeys.save.tr()))
      ],
    );
  }

  TextButton buildNoProfileData(BuildContext context) {
    {
      return TextButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: "${FirebaseAuth.instance.currentUser!.uid}"));
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("UID Copied successfully, please send it to the developer")));
            FirebaseAuth.instance.signOut();
            AppNavigator.pushReplacement(context: context, screen: RegisterScreen(isLogin: true));
            try {
              TrackingUtils().trackTextLinkClicked(FirebaseAuth.instance.currentUser!.uid,
                  DateTime.now().toUtc().toString(), "Profile Screen", "Error profile sign-out link");
            } catch (e) {
              print(e);
            }
          },
          child: Text(
              "Something went wrong while fetching the profile data. \n\n UID: ${FirebaseAuth.instance.currentUser!.uid}\n\nClick to logout"));
    }
  }

  void updateUserDataFuture() {
    setState(() {
      getUserDataFuture =
          FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    });
  }

  void shareProfileDeepLink() async {
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'invite_to_profile',
        //canonicalUrl: '',
        title: "Profile Page",
        imageUrl:
            'https://play-lh.googleusercontent.com/u6LMBvrIXH6r1LFQftqjSzebxflasn-nhcoZUlP6DjWHV6fmrwgNFyjJeFwFmckrySHF=w240-h480-rw',
        contentDescription: 'Hey, Check out this profile page',
        // keywords: ['Plugin', 'Branch', 'Flutter'],
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()..addCustomMetadata('page', '/profile-screen'));
    BranchLinkProperties lp = BranchLinkProperties(
        //alias: 'flutterplugin', //define link url,
        channel: 'Profile',
        feature: 'sharing',
        stage: 'new share',
        campaign: "Profile sharing",
        tags: ['tag-1']);
    BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    FlutterBranchSdk.trackContent(
        buo: [buo],
        branchEvent: BranchEvent.standardEvent(BranchStandardEvent.INVITE)..addCustomData("shared-page", "Profile"));
    if (response.success) {
      print('Link generated: ${response.result}');
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
    }
    Share.share(response.result);
  }

  Future<void> saveProfileChanges() async {
    if (isEditing && isEdited) {
      Map<String, Object?> data = {};

      if (name.isNotEmpty) {
        data.addAll({'username': name});
      }
      if (status.isNotEmpty) {
        data.addAll({'status': status});
      }

      if (phone.isNotEmpty && isPhoneEdited) {
        await verifyPhoneNumber(phone);
      }
      if (!isPhoneEdited) {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(data);
        updateUserDataFuture();
      }
    }
    if (!isPhoneEdited || !isEditing)
      setState(() {
        isEditing = !isEditing;
        isEdited = !isEdited;
      });
  }

  Future<void> verifyPhoneNumber(String phone) async {
    print("Entered Verify Phone number");
    setState(() {
      if (isEditing) isPhoneEdited = false;
    });

    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: false);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (phoneCredential) {},
        verificationFailed: (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
        },
        codeSent: (String verificationId, int? resendToken) async {
          try {
            var otp = await showOtpDialog();

            String smsCode = otp;

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
                backgroundColor: Theme.of(context).colorScheme.error, content: Text(e.message ?? "invalidOTP".tr())));
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
              canResend: true,
            ));
  }
}

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(height: toDouble().h);
  SizedBox get pw => SizedBox(width: toDouble().w);
}
