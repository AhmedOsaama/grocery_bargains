import 'dart:async';
import 'dart:io';

import 'package:bargainb/utils/mixpanel_utils.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/otp_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../providers/google_sign_in_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../../utils/utils.dart';
import '../../utils/validator.dart';
import '../components/button.dart';
import '../components/generic_field.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String email = "";
  String password = "";

  bool isLogin = true;
  bool isObscured = true;

  bool rememberMe = true;

  String phoneNumber = '';

  var photoURL = "";

  var resendToken = null;

  Future<void> saveRememberMePref() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("rememberMe", rememberMe);
  }

  Future<void> saveFirstTimePref() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("firstTime", false);
  }

  Future<void> _submitAuthForm(String email, String username,
      String phoneNumber, BuildContext ctx) async {
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: false);
    try {
      if (!isLogin) {
        // userCredential = await _auth.createUserWithEmailAndPassword(
        //     email: email, password: password);
        var result = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get();
        if (result.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(
                  "Phone number is already registered with another account. Please enter a different phone number")));
          return;
        }
        var userCredential = await loginWithPhoneNumber(phoneNumber);
        if (userCredential == null) {
          throw "credential error";
        }

        this.phoneNumber = userCredential.user!.phoneNumber!;
        await saveUserData(userCredential);

        saveRememberMePref();
        //saveFirstTimePref();
        AppNavigator.pushReplacement(
            context: context, screen: OnBoardingScreen());
      } else {
        // userCredential = await _auth.signInWithEmailAndPassword(
        //     email: email, password: phoneNumber);
        print("Logging in...");
        var result = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get();
        if (result.docs.isEmpty) {
          //phone number doesn't exist
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(
                  "This phone number doesn't appear to be associated with any account. Please enter a different phone number")));
          return;
        }
        var userCredential = await loginWithPhoneNumber(phoneNumber);
        if (userCredential == null) {
          throw "credential error";
        }
        print("logged in");
        saveRememberMePref();
        //saveFirstTimePref();
        AppNavigator.pushReplacement(context: context, screen: MainScreen());
      }
    } on FirebaseAuthException catch (error) {
      var message = "An error occurred, please check your credentials";

      if (error.message != null) {
        message = error.message!;
      }
      print(message);
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).colorScheme.error,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100.h,
                ),
                if (isLogin) Center(child: SvgPicture.asset(bargainbIcon)),
                30.ph,
                Center(
                  child: Text(
                    isLogin
                        ? LocaleKeys.welcomeBack.tr()
                        : LocaleKeys.createAnAccount.tr(),
                    style:
                        TextStyles.textViewSemiBold30.copyWith(color: prussian),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Text(
                    isLogin
                        ? LocaleKeys.getTheLatestDiscounts.tr()
                        : LocaleKeys.getTheLatestDiscounts.tr(),
                    style:
                        TextStyles.textViewRegular14.copyWith(color: gunmetal),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                if (!isLogin) ...[
                  Text(
                    LocaleKeys.fullName.tr(),
                    style: TextStylesDMSans.textViewBold12
                        .copyWith(color: gunmetal),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GenericField(
                    hintText: "Brandone Louis",
                    validation: (value) => Validator.text(value),
                    onSaved: (value) {
                      username = value!;
                    },
                  ),
                ],
                SizedBox(
                  height: 15.h,
                ),
                if (!isLogin) ...[
                  Text(
                    LocaleKeys.email.tr(),
                    style: TextStylesDMSans.textViewBold12
                        .copyWith(color: gunmetal),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GenericField(
                    hintText: "Brandonelouis@gmail.com",
                    validation: (value) => Validator.email(value),
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                ],
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  LocaleKeys.phone.tr(),
                  style:
                      TextStylesDMSans.textViewBold12.copyWith(color: gunmetal),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: Utils.boxShadow),
                  child: IntlPhoneField(
                    disableLengthCheck: false,
                    initialCountryCode: "NL",
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "789 123 456",
                        hintStyle: TextStylesInter.textViewRegular16),
                    // inputFormatters: [],
                    onSaved: (phone) {
                      print(phone?.completeNumber);
                      phoneNumber = phone!.completeNumber;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return Validator.phoneValidator(value!.number);
                    },
                  ),
                ),
                // GenericField(
                //   hintText: "***********",
                //   suffixIcon: GestureDetector(
                //       onTap: () {
                //         setState(() {
                //           isObscured = !isObscured;
                //         });
                //       },
                //       child: Icon(isObscured
                //           ? Icons.visibility
                //           : Icons.visibility_off)),
                //   validation: (value) => Validator.password(value),
                //   obscureText: isObscured,
                //   onSaved: (value) {
                //     password = value!;
                //   },
                // ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            checkColor: Color.fromRGBO(255, 146, 40, 1),
                            fillColor: MaterialStateProperty.all(
                                Color.fromRGBO(201, 242, 232, 1)),
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            }),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          LocaleKeys.rememberMe.tr(),
                          style: TextStylesDMSans.textViewRegular12.copyWith(
                              color: Color.fromRGBO(170, 166, 185, 1)),
                        ),
                      ],
                    ),
                    // TextButton(
                    //   onPressed: () => AppNavigator.push(
                    //       context: context, screen: ForgotPasswordScreen()),
                    //   child: Text(
                    //     LocaleKeys.forgotPassword.tr(),
                    //     style: TextStylesDMSans.textViewRegular12
                    //         .copyWith(color: Color.fromRGBO(13, 1, 64, 1)),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                GenericButton(
                    shadow: [
                      BoxShadow(
                          blurRadius: 9,
                          offset: Offset(0, 10),
                          color: verdigris.withOpacity(0.25))
                    ],
                    height: 70.h,
                    color: verdigris,
                    borderRadius: BorderRadius.circular(6),
                    width: double.infinity,
                    onPressed: () async {
                      await authenticateUser(context);
                    },
                    child: Text(
                      isLogin ? LocaleKeys.login.tr() : LocaleKeys.signUp.tr(),
                      style: TextStyles.textViewSemiBold16,
                    )),
                SizedBox(
                  height: 12.h,
                ),
                GenericButton(
                    borderRadius: BorderRadius.circular(6),
                    borderColor: borderColor,
                    color: Colors.white,
                    height: 70.h,
                    width: double.infinity,
                    onPressed: () async =>
                        await loginWithSocial(context, false),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(google2),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          LocaleKeys.signUpWithGoogle.tr(),
                          style: TextStyles.textViewSemiBold16
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    )),
                10.ph,
                if (Platform.isIOS)
                  GenericButton(
                      borderRadius: BorderRadius.circular(6),
                      borderColor: borderColor,
                      color: Colors.black,
                      height: 70.h,
                      width: double.infinity,
                      onPressed: () async =>
                          await loginWithSocial(context, true),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(apple),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            LocaleKeys.signUpWithApple.tr(),
                            style: TextStyles.textViewSemiBold16
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      )),
                SizedBox(
                  height: 10.h,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text.rich(
                      TextSpan(
                          text: isLogin
                              ? LocaleKeys.youDontHaveAnAccount.tr()
                              : LocaleKeys.alreadyHaveAnAccount.tr(),
                          style: TextStylesDMSans.textViewRegular12.copyWith(
                            color: Color.fromRGBO(82, 75, 107, 1),
                          ),
                          children: [
                            TextSpan(
                                text:
                                    " ${isLogin ? LocaleKeys.signUp.tr() : LocaleKeys.signIn.tr()}",
                                style: TextStyles.textViewRegular12.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: Color.fromRGBO(255, 146, 40, 1)))
                          ]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> authenticateUser(BuildContext context) async {
    var isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid!) {
      _formKey.currentState?.save();
      await _submitAuthForm(email, username, phoneNumber, context).timeout(
        Duration(seconds: 180),
        // onTimeout: () {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text(
        //         "Failed to login or signup, Please check your internet and try again later")));
        // }
      );
    }
  }

  Future<UserCredential> loginWithPhoneNumber(String phoneNumber) async {
    var userCredential;
    final completer = Completer<UserCredential>();
    print("AUTHENTICATING: " + phoneNumber);

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneCredential) async {
          print("verification completed");
          userCredential = await _auth.signInWithCredential(phoneCredential);
          completer.complete(userCredential);
        },
        verificationFailed: (e) {
          print("Verification failed");
          print(e.toString());
          print(e.message);
          print(e.code);
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
          completer.complete(userCredential);
        },
        forceResendingToken: resendToken,
        codeSent: (String verificationId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code
          this.resendToken = resendToken;

          var otp = await showOtpDialog();

          String smsCode = otp;

          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);

          userCredential = await _auth.signInWithCredential(credential);
          print("Signed In...");
          print(userCredential);
          completer.complete(userCredential);
        },
        timeout: const Duration(seconds: 30),
        codeAutoRetrievalTimeout: (message) {
          print("Code auto retrieval failed");
          completer.complete(userCredential);
        });
    return completer.future;
  }

  Future showOtpDialog() async {
    return await showDialog(
        context: context,
        builder: (ctx) => OtpDialog(
            phoneNumber: phoneNumber,
            resendOtp: () =>
                _submitAuthForm(email, username, phoneNumber, context)));
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
    if (userCredential.user != null) {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userSnapshot.exists) {
        try {
          email = userCredential.user!.email!;
          print(email);
          username = userCredential.user!.displayName ?? "User";
          print(username);
          photoURL = userCredential.user!.photoURL ?? "";
          print(photoURL);
          phoneNumber = "";
        } catch (e) {
          print(e);
        }
        await saveUserData(userCredential);
      }
      saveRememberMePref();
      MixpanelUtils().createUser(
          userName: "TEST NAME",
          email: userCredential.user!.email.toString(),
          id: userCredential.user!.uid);
      MixpanelUtils().trackSocialLogin(providerName: providerName);

      var pref = await SharedPreferences.getInstance();
      var isFirstTime = pref.getBool("firstTime") ?? true;
      print("IS FIRST TIME:" + isFirstTime.toString());
      if (isFirstTime) {
        // pref.setBool("firstTime", false);

        AppNavigator.pushReplacement(
            context: context, screen: OnBoardingScreen());
      } else {
        AppNavigator.pushReplacement(context: context, screen: MainScreen());
      }
    }
  }

  Future<void> saveUserData(UserCredential userCredential) async {
    print("Saving user data");
    //in case of phone auth: only phone number is provided in usercredential
    //in case of email auth: only email is provided in usercredential
    //in case of social auth: email, username and photo are provided in usercredential
    print(email);
    print(username);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      "email": email,
      "username": username,
      'imageURL': photoURL,
      'phoneNumber': phoneNumber,
      'language': 'en',
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
    });
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userCredential.user!.uid)
    //     .set({
    //   "email": email.isEmpty ? userCredential.user?.email : email,
    //   "username":
    //       username.isEmpty ? userCredential.user?.displayName : username,
    //   'imageURL': userCredential.user?.photoURL,
    //   'phoneNumber': userCredential.user?.phoneNumber,
    // });
  }
}
