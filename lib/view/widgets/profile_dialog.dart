// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:bargainb/utils/tracking_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../providers/google_sign_in_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';
import '../screens/register_screen.dart';
import 'otp_dialog.dart';

class ProfileDialog extends StatelessWidget {
  final String title;
  final String body;
  final String buttonText;
  final bool isSigningOut;
  var resendToken = null;

  ProfileDialog(
      {Key? key,
      required this.title,
      required this.body,
      required this.buttonText,
      required this.isSigningOut})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, top: 16, right: 14, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title?',
              style: TextStyles.textViewSemiBold28.copyWith(color: black2),
            ),
            10.ph,
            Text(
              body,
              style: TextStyles.textViewRegular16
                  .copyWith(color: Color.fromRGBO(72, 72, 72, 1)),
            ),
            10.ph,
            Row(
              children: [
                Expanded(
                    child: GenericButton(
                        color: Colors.white,
                        height: 60.h,
                        borderColor: Color.fromRGBO(237, 237, 237, 1),
                        borderRadius: BorderRadius.circular(6),
                        onPressed: () => AppNavigator.pop(context: context),
                        child: Text(
                          LocaleKeys.cancel.tr(),
                          style: TextStyles.textViewSemiBold16
                              .copyWith(color: black2),
                        ))),
                10.pw,
                Expanded(
                    child: GenericButton(
                        color: yellow,
                        height: 60.h,
                        borderRadius: BorderRadius.circular(6),
                        onPressed: () async {
                          if (isSigningOut) {
                            var pref = await SharedPreferences.getInstance();
                            pref.setBool("rememberMe", false);
                            var isGoogleSignedIn =
                                await Provider.of<GoogleSignInProvider>(context,
                                        listen: false)
                                    .googleSignIn
                                    .isSignedIn();
                            if (isGoogleSignedIn) {
                              await Provider.of<GoogleSignInProvider>(context,
                                      listen: false)
                                  .logout();
                            } else {
                              FirebaseAuth.instance.signOut();
                            }
                            TrackingUtils().trackUserLoggedOut(DateTime.now().toUtc().toString(), FirebaseAuth.instance.currentUser!.uid);
                            print("SIGNED OUT...................");
                          } else {
                            var user = FirebaseAuth.instance.currentUser!;
                            var userId = user.uid;
                            await user.reload();
                            await user.delete().catchError((e) async {
                              print(e);
                              if(user.phoneNumber == null){
                                  if(Platform.isIOS){
                                    await loginWithSocial(context, true);
                                  }else{
                                    await loginWithSocial(context, false);
                                  }
                              }else{
                                await loginWithPhoneNumber(user.phoneNumber!, context);
                              }
                              await user.delete();
                            });
                            await FirebaseFirestore.instance.collection('/users').doc(userId).delete();
                          TrackingUtils().trackAccountDeleted(userId);
                          }
                          AppNavigator.pushReplacement(
                              context: context, screen: RegisterScreen());
                        },
                        child: Text(
                          buttonText,
                          style: TextStyles.textViewSemiBold16
                              .copyWith(color: black2),
                        ))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<UserCredential> loginWithPhoneNumber(String phoneNumber, BuildContext context) async {
    var userCredential;
    final completer = Completer<UserCredential>();
    var _auth = FirebaseAuth.instance;
    print("AUTHENTICATING: " + phoneNumber);

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneCredential) async {
          print("verification completed");
          userCredential = await _auth.signInWithCredential(phoneCredential);
          completer.complete(userCredential);
        },
        verificationFailed: (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
          completer.complete(userCredential);
        },
        forceResendingToken: resendToken,
        codeSent: (String verificationId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code
          this.resendToken = resendToken;

          var otp = await showOtpDialog(context, phoneNumber);

          String smsCode = otp;

          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
          try {
            userCredential = await _auth.signInWithCredential(credential);
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).colorScheme.error,
                content: Text(e.message ?? "invalidOTP".tr())));
          }

          print("Signed In...");

          completer.complete(userCredential);
        },
        timeout: const Duration(seconds: 30),
        codeAutoRetrievalTimeout: (message) {
          print("Code auto retrieval failed");
          completer.complete(userCredential);
        });
    return completer.future;
  }

  Future<void> loginWithSocial(BuildContext context, bool isApple) async {
    late UserCredential userCredential;
    String providerName;
    if (isApple) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final appleCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      // print(appleCredential);
      userCredential =
      await FirebaseAuth.instance.signInWithCredential(appleCredential);
      print(userCredential);
      providerName = 'Apple';
    } else {
      userCredential =
      await Provider.of<GoogleSignInProvider>(context, listen: false)
          .loginWithGoogle();
      providerName = "Google";
    }
  }

  Future showOtpDialog(BuildContext context, String phoneNumber) async {
    return await showDialog(
        context: context,
        builder: (ctx) => OtpDialog(
          phoneNumber: phoneNumber,
          resendOtp: (){},
          canResend: false,
              // _submitAuthForm(email, username, phoneNumber, context),
          isSignUp: false,
        ));
  }

}
