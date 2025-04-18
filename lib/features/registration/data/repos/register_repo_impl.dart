import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bargainb/features/onboarding/presentation/views/free_trial_screen.dart';
import 'package:bargainb/features/registration/data/repos/register_repo.dart';
import 'package:bargainb/features/registration/presentation/views/email_address_screen.dart';
import 'package:bargainb/models/bargainb_user.dart';
import 'package:bargainb/features/home/presentation/views/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:segment_analytics/event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../config/routes/app_navigator.dart';
import '../../../../providers/google_sign_in_provider.dart';
import '../../../../providers/subscription_provider.dart';
import '../../../../providers/tutorial_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../../services/purchase_service.dart';
import '../../../../utils/tracking_utils.dart';
import '../../../../view/widgets/otp_dialog.dart';

class RegisterRepoImpl implements RegisterRepo {

  //Main Auth Functions

  @override
  Future<void> authenticateUser({required BuildContext context, required BargainbUser user,
      required GlobalKey<FormState> formKey, required bool isLogin, required bool rememberMe}) async {
    FocusScope.of(context).unfocus();
      await submitAuthForm(context: context, user: user, isLogin: isLogin).timeout(
        const Duration(seconds: 180),
      );
      saveRememberMePref(rememberMe);
  }

  @override
  Future<void> submitAuthForm({required BargainbUser user, required BuildContext context, required bool isLogin}) async {
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: kDebugMode);
    // FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
    try {
      if (!isLogin) {
        signup(context, user);
      }
      else {
        login(context, user);
      }
    } on FirebaseAuthException catch (error) {
      var message = "An error occurred, please check your credentials";
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
  }

  @override
  Future<void> loginWithSocial(BuildContext context, bool isApple, bool rememberMe) async {
    UserCredential? userCredential;
    if (isApple) {
      userCredential = await loginWithApple();
    } else {
      userCredential = await Provider.of<GoogleSignInProvider>(context, listen: false).loginWithGoogle();
    }
    await storeUserInfo(context: context, userCredential: userCredential!);
    saveRememberMePref(rememberMe);
    goToNextScreen(context, false);
    TrackingUtils().trackLogin(userCredential.user!.uid, DateTime.now().toUtc().toString());
  }

  //Helper Auth Functions

  @override
  Future<void> storeUserInfo({required BuildContext context,
    required UserCredential userCredential}) async {
    if (userCredential.user != null) {
      await saveUserData(userCredential, context);
    }
  }

  @override
  Future<void> finalizePhoneLogin(BuildContext context, UserCredential userCredential,
      QuerySnapshot<Map<String, dynamic>> result) async {
    var deviceToken = await FirebaseMessaging.instance.getToken() ?? "default token";
    var userMap = result.docs.first.data();
    TrackingUtils().trackLogin(userCredential.user!.uid, DateTime.now().toUtc().toString());
    if (!userMap.containsKey('token')) saveUserDeviceToken(userCredential);
    Provider.of<UserProvider>(context, listen: false).setUserData(userCredential.user!.uid,
        userMap['username'],
        userMap['email'],
        userMap['phoneNumber'],
        deviceToken,
        userMap['imageURL']);
  }

  @override
  Future<void> finalizePhoneSignup(UserCredential userCredential, BuildContext context) async {
    await saveUserData(userCredential, context);
    TrackingUtils().trackSignup(userCredential.user!.uid, DateTime.now().toUtc().toString());
  }

  @override
  Future<void> goToNextScreen(BuildContext context, bool isSignup) async {
      if(isSignup){
        AppNavigator.pushReplacement(context: context, screen: const EmailAddressScreen());
      } else {
        if(SubscriptionProvider.get(context).isSubscribed){
          AppNavigator.pushReplacement(context: context, screen: const MainScreen());
        } else {
          AppNavigator.pushReplacement(context: context, screen: const FreeTrialScreen());
        }
      }
  }

  @override
  Future<UserCredential?> loginWithApple() async {
    UserCredential? userCredential;
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        webAuthenticationOptions: WebAuthenticationOptions(clientId: "com.bargainb.client", redirectUri: Uri.parse("https://thebargainb.com")),
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final appleCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      userCredential = await FirebaseAuth.instance.signInWithCredential(appleCredential);
    } catch (e) {
      print("Error signing in with apple: $e");
      return null;
    }
    return userCredential;
  }

  @override
  Future<UserCredential> loginWithPhoneNumber(String phoneNumber, BuildContext context) async {
    var token;
    final _auth = FirebaseAuth.instance;
    late UserCredential userCredential;
    final completer = Completer<UserCredential>();

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneCredential) async {
          userCredential = await _auth.signInWithCredential(phoneCredential);
          completer.complete(userCredential);
        },
        verificationFailed: (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
          TrackingUtils().trackPhoneNumberVerified("Guest", DateTime.now().toUtc().toString(), false);
          completer.complete(userCredential);
        },
        forceResendingToken: token,
        codeSent: (String verificationId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code
          token = resendToken;

          var otp = await showOtpDialog(context, phoneNumber);

          String smsCode = otp;

          PhoneAuthCredential credential =
              PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
          try {
            userCredential = await _auth.signInWithCredential(credential);
            TrackingUtils().trackPhoneNumberVerified(userCredential.user!.uid, DateTime.now().toUtc().toString(), true);
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).colorScheme.error, content: Text(e.message ?? "invalidOTP".tr())));
            TrackingUtils().trackPhoneNumberVerified("Guest", DateTime.now().toUtc().toString(), false);
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


  @override
  Future<void> saveRememberMePref(bool rememberMe) async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("rememberMe", rememberMe);
  }

  @override
  Future<void> saveUserData(UserCredential userCredential, BuildContext context) async {
    log("Saving user data");
    //in case of phone auth: only phone number is provided in usercredential
    //in case of email auth: only email is provided in usercredential
    //in case of social auth: email, username and photo are provided in usercredential
    try {
      String email = userCredential.user!.email ?? "";
      String username = userCredential.user!.displayName ?? "User";
      String imageURL = userCredential.user!.photoURL ?? "";
      String phoneNumber = userCredential.user?.phoneNumber ?? '';
      String country = "";
      String city = "";
      var language = context.locale.languageCode;
      // log("startup language: $language");
      var deviceToken = await FirebaseMessaging.instance
          .getToken(); //could produce a problem if permission is not accepted especially on iOS
      var userData = {
        "email": email,               //email will be empty as this is before email address screen
        "username": username,
        'imageURL': imageURL,
        'phoneNumber': phoneNumber,
        'token': deviceToken,
        "message_tokens": 30,
        'timestamp': DateTime.now().toUtc().toString(),
        'language': language,
        'status': "Hello! I'm using BargainB. Join the app",
        'privacy': {
          'connectContacts': true,
          'locationServices': false,
        },
        'preferences': {
          'emailMarketing': true,
          'weekly': true,
          'daily': false,
        },
      };
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(userData);

      Provider.of<UserProvider>(context, listen: false)
          .setUserData(userCredential.user!.uid, username, email, phoneNumber, deviceToken!, imageURL);


      TrackingUtils.segment.identify(
          userId: userCredential.user!.uid,
          userTraits: UserTraits(
            email: email,
            name: username,
            phone: phoneNumber,
            createdAt: DateTime.now().toUtc().toString(),
            custom: {
              'connectContacts': true,
              'locationServices': false,
              'emailMarketing': true,
              'weekly': true,
              'daily': false,
              "status": "Hello! I'm using BargainB. Join the app"
            },

          )
      );
      } catch (e) {
        log("Error occurred in saveUserData: $e");
      }
  }

  Future<void> createHubspotContact(String email, String username, String phoneNumber, String country, String city) async {
    try {
      var response = await get(Uri.parse("http://ip-api.com/json"));
      if (response.statusCode == 200) {
        var responseMap = jsonDecode(response.body);
        country = responseMap['country'];
        city = responseMap['city'];
      }
    }catch(e){
      log(e.toString());
    }


  }

  @override
  Future<String> saveUserDeviceToken(UserCredential userCredential) async {
    var deviceToken = await FirebaseMessaging.instance
        .getToken(); //could produce a problem if permission is not accepted especially on iOS
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).update({
      'token': deviceToken,
      'timestamp': Timestamp.now(),
    });
    return deviceToken!;
  }

  @override
  Future showOtpDialog(BuildContext context, String phoneNumber) async {
    return await showDialog(
        context: context,
        builder: (ctx) => OtpDialog(
              phoneNumber: phoneNumber,
              resendOtp: () => loginWithPhoneNumber(phoneNumber, context),
              canResend: true,
              isSignUp: true,
            ));
  }

  Future<void> signup(BuildContext context, BargainbUser user) async {
    print("Signing Up...");
    var result =
        await FirebaseFirestore.instance.collection('users').where('phoneNumber', isEqualTo: user.phoneNumber).get();
    // log(result.docs.first.data().toString());
    if (result.docs.isNotEmpty) {
      //phone number check
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Theme.of(context).colorScheme.error, content: Text("PhoneNumberAlready".tr())));
      return;
    }
    var userCredential = await loginWithPhoneNumber(user.phoneNumber, context);
    if (userCredential == null) {
      throw "credential error";
    }
    user.phoneNumber = userCredential.user!.phoneNumber!;
    await finalizePhoneSignup(userCredential, context);
    goToNextScreen(context, true);
  }

  Future<void> login(BuildContext context, BargainbUser user) async {
    print("Logging in...");
    var result =
        await FirebaseFirestore.instance.collection('users').where('phoneNumber', isEqualTo: user.phoneNumber).get();
    if (result.docs.isEmpty) {
      //phone number doesn't exist
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Theme.of(context).colorScheme.error, content: Text("ThisPhoneNumber".tr())));
      return;
    }
    var userCredential = await loginWithPhoneNumber(user.phoneNumber, context);
    if (userCredential == null) {
      throw "credential error";
    }
    await finalizePhoneLogin(
      context,
      userCredential,
      result,
    );
    goToNextScreen(context, false);
  }


}
