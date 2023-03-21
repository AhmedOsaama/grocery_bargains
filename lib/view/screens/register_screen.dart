import 'dart:io';

import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../providers/google_sign_in_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
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

  bool rememberMe = false;

  Future<void> saveRememberMePref() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("rememberMe", rememberMe);
  }

  Future<void> _submitAuthForm(String email, String username, File? pickedImage,
      String password, BuildContext ctx) async {
    UserCredential userCredential;
    try {
      if (!isLogin) {
        setState(() {
          _isLoading = true;
        });
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await saveUserData(userCredential);
        AppNavigator.pushReplacement(context: context, screen: OnBoardingScreen());
      } else {
        setState(() {
          _isLoading = true;
        });
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      saveRememberMePref();
      //TODO: make a condition if the user is first time in app then go to oboarding, else go to homescreen
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
                  height: 58.h,
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
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  LocaleKeys.password.tr(),
                  style:
                      TextStylesDMSans.textViewBold12.copyWith(color: gunmetal),
                ),
                SizedBox(
                  height: 10.h,
                ),
                GenericField(
                  hintText: "***********",
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                      child: Icon(isObscured ? Icons.visibility : Icons.visibility_off)),
                  validation: (value) => Validator.password(value),
                  obscureText: isObscured,
                  onSaved: (value) {
                    password = value!;
                  },
                ),
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
                    TextButton(
                      onPressed: () => AppNavigator.push(context: context, screen: ForgotPasswordScreen()),
                      child: Text(
                        LocaleKeys.forgotPassword.tr(),
                        style: TextStylesDMSans.textViewRegular12
                            .copyWith(color: Color.fromRGBO(13, 1, 64, 1)),
                      ),
                    ),
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
                      var isValid = _formKey.currentState?.validate();
                      FocusScope.of(context).unfocus();
                      if (isValid!) {
                        _formKey.currentState?.save();
                        await _submitAuthForm(
                            email, username, null, password, context).timeout(Duration(seconds: 10),onTimeout: (){
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to login or signup, Please check your internet and try again later")));
                        });
                      }
                    },
                    child: Text(
                      isLogin ? LocaleKeys.login.tr() : LocaleKeys.signUp.tr(),
                      style: TextStyles.textViewSemiBold16,
                    )),
                SizedBox(
                  height: 12.h,
                ),
                // if(Platform.isAndroid)
                GenericButton(
                    borderRadius: BorderRadius.circular(6),
                    borderColor: borderColor,
                    color: Colors.white,
                    height: 70.h,
                    width: double.infinity,
                    onPressed: () async => await loginWithGoogle(context,false),
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
                GenericButton(
                    borderRadius: BorderRadius.circular(6),
                    borderColor: borderColor,
                    color: Colors.black,
                    height: 70.h,
                    width: double.infinity,
                    onPressed: () async => await loginWithGoogle(context,true),
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
                                text: " ${isLogin ? LocaleKeys.signUp.tr() : LocaleKeys.signIn.tr()}",
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

  Future<void> loginWithGoogle(BuildContext context,bool isApple) async {
    late UserCredential userCredential;
    if(isApple){
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
      print(appleCredential);
      userCredential =
      await FirebaseAuth.instance.signInWithCredential(appleCredential);
      print(userCredential);
    }else{
      userCredential = await Provider.of<GoogleSignInProvider>(context,
           listen: false)
       .loginWithGoogle();
    }
    if(userCredential.user != null){
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid).get();
      if(!userSnapshot.exists)
        await saveUserData(userCredential);
    saveRememberMePref();
    var pref = await SharedPreferences.getInstance();
    var isFirstTime = pref.getBool("firstTime") ?? true;
    if(isFirstTime) {
      pref.setBool("firstTime", false);
     AppNavigator.pushReplacement(context: context, screen: OnBoardingScreen());
    } else {
      AppNavigator.pushReplacement(context: context, screen: MainScreen());
    }
    }
  }

  Future<void> saveUserData(UserCredential userCredential) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      "email": email.isEmpty ? userCredential.user?.email : email,
      "username": username.isEmpty ? userCredential.user?.displayName : username,
      'imageURL': userCredential.user?.photoURL,
    });
  }
}
