import 'dart:async';
import 'dart:io';

import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
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
import 'forgot_password_screen.dart';
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
  bool _isLoading = false;
  bool isLogin = true;
  bool isObscured = true;

  bool rememberMe = true;

  String phoneNumber = '';

  var photoURL = "";

  Future<void> saveRememberMePref() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("rememberMe", rememberMe);
  }

  Future<void> _submitAuthForm(String email, String username,
      String phoneNumber, BuildContext ctx) async {
    FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
    try {
      if (!isLogin) {
        setState(() {
          _isLoading = true;
        });
        // userCredential = await _auth.createUserWithEmailAndPassword(
        //     email: email, password: password);
        var result = await FirebaseFirestore.instance.collection('users').where('phoneNumber',isEqualTo: phoneNumber).get();
        if(result.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Theme.of(context).errorColor,content: Text(
              "Phone number is already registered with another account. Please enter a different phone number")));
          return;
        }
        var userCredential = await loginWithPhoneNumber(phoneNumber);
        if(userCredential == null){
          throw "credential error";
        }
        this.phoneNumber = userCredential.user!.phoneNumber!;

        await saveUserData(userCredential);
        saveRememberMePref();
        AppNavigator.pushReplacement(
            context: context, screen: OnBoardingScreen());
        print("SIGNED UP");
      } else {
        setState(() {
          _isLoading = true;
        });
        // userCredential = await _auth.signInWithEmailAndPassword(
        //     email: email, password: phoneNumber);
        print("Logging in...");
        var result = await FirebaseFirestore.instance.collection('users').where('phoneNumber',isEqualTo: phoneNumber).get();
        if(result.docs.isEmpty) {          //phone number doesn't exist
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Theme.of(context).errorColor,content: Text(
              "This phone number doesn't appear to be associated with any account. Please enter a different phone number")));
          return;
        }
        var userCredential = await loginWithPhoneNumber(phoneNumber);
        if(userCredential == null){
          throw "credential error";
        }
        print("logged in");
        saveRememberMePref();
        //   AppNavigator.pushReplacement(context: context, screen: HomeScreen());
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
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
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
                if(isLogin)
                  Center(child: SvgPicture.asset(bargainbIcon)),
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
                if(!isLogin)...[
                  Text(
                    LocaleKeys.email.tr(),
                    style:
                    TextStylesDMSans.textViewBold12.copyWith(color: gunmetal),
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
                  decoration: BoxDecoration(
                      boxShadow:
                            Utils.boxShadow
                  ),
                  child: IntlPhoneField(
                    disableLengthCheck: true,
                    initialCountryCode: "EG",
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

                        hintText: "+91 90001 90001",
                        hintStyle: TextStylesInter.textViewRegular16),
                    // inputFormatters: [],
                    onSaved: (phone) {
                      print(phone?.completeNumber);
                      phoneNumber = phone!.completeNumber;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      print(value?.number);
                      return Validator.phoneValidator(value?.number);
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
                if(Platform.isIOS)
                GenericButton(
                    borderRadius: BorderRadius.circular(6),
                    borderColor: borderColor,
                    color: Colors.black,
                    height: 70.h,
                    width: double.infinity,
                    onPressed: () async => await loginWithSocial(context, true),
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
      await _submitAuthForm(email, username, phoneNumber, context)
          .timeout(Duration(seconds: 180), onTimeout: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Failed to login or signup, Please check your internet and try again later")));
      });
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
          print(e.plugin);
          print(e.message);
          print(e.code);
          print(e.stackTrace);
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
          completer.complete(userCredential);
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code
          var otp = await showDialog(
              context: context,
              builder: (ctx) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Please enter your OTP",
                            style: TextStylesInter.textViewSemiBold14,
                          ),
                          Pinput(
                              // defaultPinTheme: defaultPinTheme,
                              // focusedPinTheme: focusedPinTheme,
                              // submittedPinTheme: submittedPinTheme,
                              validator: (s) {
                                return null;

                                // var otp =
                                //     widget.otp.substring(widget.otp.length - 4);
                                // print(otp);
                                // return s == otp ? null : 'Pin is incorrect';
                              },
                              length: 6,
                              pinputAutovalidateMode:
                                  PinputAutovalidateMode.onSubmit,
                              showCursor: true,
                              onCompleted: (pin) async {
                                // print('=============>WidgetOTP${widget.otp}');
                                print('=============>PIN$pin');
                                await AppNavigator.pop(
                                    context: context, object: pin);
                                // otp = pin;
                                // otpProvider.otpVendor(context: context, otp: pin);
                                // if (pin == widget.otp) {
                                //   Provider.of<AppStateProvider>(context,
                                //           listen: false)
                                //       .verified();
                                //   await AppNavigator.pushReplacement(
                                //       context: context,
                                //       screen: const StoreSetupScreen());
                                // } else {
                                //   customToast(
                                //       backgroundColor: Colors.red.shade300,
                                //       textColor: white,
                                //       content: widget.otp);
                                // }
                              }),
                        ],
                      ),
                    ),
                  ));

          String smsCode = otp;

          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);

          userCredential = await _auth.signInWithCredential(credential);
          print("Signed In...");
          print(userCredential);
          completer.complete(userCredential);
          },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (message) {
          print("Code auto retrieval failed");
          completer.complete(userCredential);
        });
    return completer.future;
  }

  Future<void> loginWithSocial(BuildContext context, bool isApple) async {
    late UserCredential userCredential;
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
    } else {
      userCredential =
          await Provider.of<GoogleSignInProvider>(context, listen: false)
              .loginWithGoogle();
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
        }catch(e){
          print(e);
        }
        await saveUserData(userCredential);
      }
      saveRememberMePref();

      var pref = await SharedPreferences.getInstance();
      var isFirstTime = pref.getBool("firstTime") ?? true;
      if (isFirstTime) {
        pref.setBool("firstTime", false);

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
      'phoneNumber':phoneNumber,
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
