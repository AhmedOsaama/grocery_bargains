// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:bargainb/features/onboarding/presentation/views/confirm_subscription_screen.dart';
// import 'package:bargainb/features/onboarding/presentation/views/customize_experience_screen.dart';
// import 'package:bargainb/providers/user_provider.dart';
// import 'package:bargainb/services/purchase_service.dart';
// import 'package:bargainb/utils/tracking_utils.dart';
// import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
// import 'package:bargainb/view/widgets/otp_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:http/http.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// import '../../config/routes/app_navigator.dart';
// import '../../features/onboarding/presentation/views/onboarding_screen.dart';
// import '../../generated/locale_keys.g.dart';
// import '../../providers/google_sign_in_provider.dart';
// import '../../providers/tutorial_provider.dart';
// import '../../utils/app_colors.dart';
// import '../../utils/icons_manager.dart';
// import '../../utils/style_utils.dart';
// import '../../utils/utils.dart';
// import '../../utils/validator.dart';
// import '../components/button.dart';
// import '../components/generic_field.dart';
// import 'main_screen.dart';
// import 'onboarding_screen.dart';
//
// class RegisterScreen extends StatefulWidget {
//   final bool isLogin;
//   RegisterScreen({Key? key, required this.isLogin}) : super(key: key);
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final _formKey = GlobalKey<FormState>();
//   String username = "";
//   String email = "";
//   String password = "";
//
//   bool isLogin = false;
//   bool isObscured = true;
//
//   bool rememberMe = true;
//
//   String phoneNumber = '';
//
//   var photoURL = "";
//
//   var resendToken;
//
//   Future<void> saveRememberMePref() async {
//     var pref = await SharedPreferences.getInstance();
//     pref.setBool("rememberMe", rememberMe);
//   }
//
//
//   Future<void> _submitAuthForm(String email, String username,
//       String phoneNumber, BuildContext ctx) async {
//     FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: false);
//     try {
//       if (!isLogin) {
//         print("Signing Up...");
//         var result = await FirebaseFirestore.instance
//             .collection('users')
//             .where('phoneNumber', isEqualTo: phoneNumber)
//             .get();
//         if (result.docs.isNotEmpty) {                                           //phone number check
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               backgroundColor: Theme.of(context).colorScheme.error,
//               content: Text("PhoneNumberAlready".tr())));
//           return;
//         }
//         var result1 = await FirebaseFirestore.instance
//             .collection('users')
//             .where('email', isEqualTo: email)
//             .get();
//         if (result1.docs.isNotEmpty) {                                                      // email check
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               backgroundColor: Theme.of(context).colorScheme.error,
//               content: Text("EmailAlready".tr())));
//           return;
//         }
//         var userCredential = await loginWithPhoneNumber(phoneNumber);
//         if (userCredential == null) {
//           throw "credential error";
//         }
//         this.phoneNumber = userCredential.user!.phoneNumber!;
//         await finalizePhoneSignup(userCredential);
//         goToNextScreen(context);
//       } else {
//         print("Logging in...");
//         var result = await FirebaseFirestore.instance
//             .collection('users')
//             .where('phoneNumber', isEqualTo: phoneNumber)
//             .get();
//         if (result.docs.isEmpty) {
//           //phone number doesn't exist
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               backgroundColor: Theme.of(context).colorScheme.error,
//               content: Text("ThisPhoneNumber".tr())));
//           return;
//         }
//         var userCredential = await loginWithPhoneNumber(phoneNumber);
//         if (userCredential == null) {
//           throw "credential error";
//         }
//         finalizePhoneLogin(userCredential, result);
//         goToNextScreen(context);
//       }
//     } on FirebaseAuthException catch (error) {
//       var message = "An error occurred, please check your credentials";
//
//       if (error.message != null) {
//         message = error.message!;
//       }
//       // print(message);
//       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
//         content: Text(message),
//         backgroundColor: Theme.of(ctx).colorScheme.error,
//       ));
//     }
//   }
//
//   Future<void> finalizePhoneSignup(UserCredential userCredential) async {
//      await saveUserData(userCredential);
//     TrackingUtils().trackSignup(userCredential.user!.uid, DateTime.now().toUtc().toString());
//     saveRememberMePref();
//   }
//
//   Future<void> finalizePhoneLogin(UserCredential userCredential, QuerySnapshot<Map<String, dynamic>> result) async {
//     var deviceToken = await FirebaseMessaging.instance.getToken() ?? "default token";
//     var userMap = result.docs.first.data();
//     TrackingUtils().trackLogin(userCredential.user!.uid, DateTime.now().toUtc().toString());
//     saveRememberMePref();
//     if(!userMap.containsKey('token')) saveUserDeviceToken(userCredential);
//       Provider.of<UserProvider>(context, listen: false).setUserData(userCredential.user!.uid, userMap['username'],  userMap['email'], userMap['phoneNumber'], deviceToken, userMap['imageURL']);
//   }
//
//   @override
//   void initState() {
//     isLogin = widget.isLogin;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 15.w),
//         // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 100.h,
//                 ),
//                 if (isLogin) Center(child: SvgPicture.asset(bargainbIcon)),
//                 30.ph,
//                 Center(
//                   child: Text(
//                     isLogin
//                         ? LocaleKeys.welcomeBack.tr()
//                         : LocaleKeys.createAnAccount.tr(),
//                     style:
//                         TextStyles.textViewSemiBold30.copyWith(color: prussian),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 12.h,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 35),
//                   child: Text(
//                     isLogin
//                         ? LocaleKeys.getTheLatestDiscounts.tr()
//                         : LocaleKeys.getTheLatestDiscounts.tr(),
//                     style:
//                         TextStyles.textViewRegular14.copyWith(color: gunmetal),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//                 if (!isLogin) ...[
//                   Text(
//                     LocaleKeys.fullName.tr(),
//                     style: TextStylesInter.textViewBold12
//                         .copyWith(color: gunmetal),
//                   ),
//                   SizedBox(
//                     height: 10.h,
//                   ),
//                   GenericField(
//                     hintText: "Brandone Louis",
//                     validation: (value) => Validator.text(value),
//                     onSaved: (value) {
//                       username = value!;
//                     },
//                   ),
//                 ],
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 if (!isLogin) ...[
//                   Text(
//                     LocaleKeys.email.tr(),
//                     style: TextStylesInter.textViewBold12
//                         .copyWith(color: gunmetal),
//                   ),
//                   SizedBox(
//                     height: 10.h,
//                   ),
//                   GenericField(
//                     hintText: "Brandonelouis@gmail.com",
//                     validation: (value) => Validator.email(value),
//                     onSaved: (value) {
//                       email = value!;
//                     },
//                   ),
//                 ],
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Text(
//                   LocaleKeys.phone.tr(),
//                   style:
//                       TextStylesInter.textViewBold12.copyWith(color: gunmetal),
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(boxShadow: Utils.boxShadow),
//                   child: IntlPhoneField(
//                     disableLengthCheck: false,
//                     initialCountryCode: "NL",
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.transparent,
//                             ),
//                             borderRadius: BorderRadius.circular(10)),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.transparent,
//                             ),
//                             borderRadius: BorderRadius.circular(10)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.transparent,
//                             ),
//                             borderRadius: BorderRadius.circular(10)),
//                         errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.transparent,
//                             ),
//                             borderRadius: BorderRadius.circular(10)),
//                         fillColor: Colors.white,
//                         filled: true,
//                         hintText: "789 123 456",
//                         hintStyle: TextStylesInter.textViewRegular16),
//                     // inputFormatters: [],
//                     onSaved: (phone) {
//                       print(phone?.completeNumber);
//                       phoneNumber = phone!.completeNumber;
//                     },
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (value) {
//                       return Validator.phoneValidator(value!.number);
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Checkbox(
//                             checkColor: Color.fromRGBO(255, 146, 40, 1),
//                             fillColor: MaterialStateProperty.all(
//                                 Color.fromRGBO(201, 242, 232, 1)),
//                             value: rememberMe,
//                             onChanged: (value) {
//                               setState(() {
//                                 rememberMe = value!;
//                               });
//                             }),
//                         SizedBox(
//                           width: 5.w,
//                         ),
//                         Text(
//                           LocaleKeys.rememberMe.tr(),
//                           style: TextStylesInter.textViewRegular12.copyWith(
//                               color: Color.fromRGBO(170, 166, 185, 1)),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 GenericButton(
//                     shadow: [
//                       BoxShadow(
//                           blurRadius: 9,
//                           offset: Offset(0, 10),
//                           color: verdigris.withOpacity(0.25))
//                     ],
//                     height: 70.h,
//                     color: brightOrange,
//                     borderRadius: BorderRadius.circular(6),
//                     width: double.infinity,
//                     onPressed: () async {
//                       await authenticateUser(context);
//                     },
//                     child: Text(
//                       isLogin ? LocaleKeys.login.tr() : LocaleKeys.signUp.tr(),
//                       style: TextStyles.textViewSemiBold16,
//                     )),
//                 SizedBox(
//                   height: 12.h,
//                 ),
//                 GenericButton(
//                     borderRadius: BorderRadius.circular(6),
//                     borderColor: borderColor,
//                     color: Colors.white,
//                     height: 70.h,
//                     width: double.infinity,
//                     onPressed: () async =>
//                         await loginWithSocial(context, false),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(google2),
//                         SizedBox(
//                           width: 10.w,
//                         ),
//                         Text(
//                           !isLogin ? LocaleKeys.signUpWithGoogle.tr() : "Sign in with Google".tr(),
//                           style: TextStyles.textViewSemiBold16
//                               .copyWith(color: Colors.black),
//                         ),
//                       ],
//                     )),
//                 10.ph,
//                 if (Platform.isIOS)
//                   GenericButton(
//                       borderRadius: BorderRadius.circular(6),
//                       borderColor: borderColor,
//                       color: Colors.black,
//                       height: 70.h,
//                       width: double.infinity,
//                       onPressed: () async =>
//                           await loginWithSocial(context, true),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(apple),
//                           SizedBox(
//                             width: 10.w,
//                           ),
//                           Text(
//                            !isLogin ? LocaleKeys.signUpWithApple.tr() : "Sign in with Apple".tr(),
//                             style: TextStyles.textViewSemiBold16
//                                 .copyWith(color: Colors.white),
//                           ),
//                         ],
//                       )),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isLogin = !isLogin;
//                       });
//                     },
//                     child: Text.rich(
//                       TextSpan(
//                           text: isLogin
//                               ? LocaleKeys.youDontHaveAnAccount.tr()
//                               : LocaleKeys.alreadyHaveAnAccount.tr(),
//                           style: TextStylesInter.textViewRegular12.copyWith(
//                             color: Color.fromRGBO(82, 75, 107, 1),
//                           ),
//                           children: [
//                             TextSpan(
//                                 text:
//                                     " ${isLogin ? LocaleKeys.signUp.tr() : LocaleKeys.signIn.tr()}",
//                                 style: TextStyles.textViewRegular12.copyWith(
//                                     decoration: TextDecoration.underline,
//                                     color: Color.fromRGBO(255, 146, 40, 1)))
//                           ]),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 50.h,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> authenticateUser(BuildContext context) async {
//     var isValid = _formKey.currentState?.validate();
//     FocusScope.of(context).unfocus();
//     if (isValid!) {
//       _formKey.currentState?.save();
//       await _submitAuthForm(email, username, phoneNumber, context).timeout(
//         Duration(seconds: 180),
//       );
//     }
//   }
//
//   Future<UserCredential> loginWithPhoneNumber(String phoneNumber) async {
//     var userCredential;
//     final completer = Completer<UserCredential>();
//     print("AUTHENTICATING: " + phoneNumber);
//
//     await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (phoneCredential) async {
//           print("verification completed");
//           userCredential = await _auth.signInWithCredential(phoneCredential);
//           completer.complete(userCredential);
//         },
//         verificationFailed: (e) {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text(e.message.toString())));
//           TrackingUtils().trackPhoneNumberVerified("Guest", DateTime.now().toUtc().toString(), false);
//           completer.complete(userCredential);
//         },
//         forceResendingToken: resendToken,
//         codeSent: (String verificationId, int? resendToken) async {
//           // Update the UI - wait for the user to enter the SMS code
//           this.resendToken = resendToken;
//
//           var otp = await showOtpDialog();
//
//           String smsCode = otp;
//
//           PhoneAuthCredential credential = PhoneAuthProvider.credential(
//               verificationId: verificationId, smsCode: smsCode);
//           try {
//             userCredential = await _auth.signInWithCredential(credential);
//             TrackingUtils().trackPhoneNumberVerified(userCredential.user!.uid , DateTime.now().toUtc().toString(), true);
//           } on FirebaseAuthException catch (e) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 backgroundColor: Theme.of(context).colorScheme.error,
//                 content: Text(e.message ?? "invalidOTP".tr())));
//             TrackingUtils().trackPhoneNumberVerified("Guest", DateTime.now().toUtc().toString(), false);
//           }
//
//           print("Signed In...");
//
//           completer.complete(userCredential);
//         },
//         timeout: const Duration(seconds: 30),
//         codeAutoRetrievalTimeout: (message) {
//           print("Code auto retrieval failed");
//           completer.complete(userCredential);
//         });
//     return completer.future;
//   }
//
//   Future showOtpDialog() async {
//     return await showDialog(
//         context: context,
//         builder: (ctx) => OtpDialog(
//               phoneNumber: phoneNumber,
//               resendOtp: () =>
//                   _submitAuthForm(email, username, phoneNumber, context),
//               canResend: true,
//               isSignUp: true,
//             ));
//   }
//
//   Future<void> loginWithSocial(BuildContext context, bool isApple) async {
//     UserCredential? userCredential;
//     if (isApple) {
//       userCredential = await loginWithApple();
//     } else {
//       userCredential =
//           await Provider.of<GoogleSignInProvider>(context, listen: false)
//               .loginWithGoogle();
//     }
//     if(userCredential != null)
//     finalizeSocialLogin(userCredential, context);
//   }
//
//   Future<UserCredential?> loginWithApple() async {
//     UserCredential? userCredential;
//     try {
//       final credential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );
//       final appleCredential = OAuthProvider('apple.com').credential(
//         idToken: credential.identityToken,
//         accessToken: credential.authorizationCode,
//       );
//     userCredential = await FirebaseAuth.instance.signInWithCredential(appleCredential);
//     }catch(e){
//       print(e);
//       return null;
//     }
//     return userCredential;
//   }
//
//   Future<void> finalizeSocialLogin(UserCredential userCredential, BuildContext context) async {
//     goToNextScreen(context);
//     checkAndStoreUserInfo(userCredential);
//   }
//
//   Future<void> checkAndStoreUserInfo(UserCredential userCredential) async {
//     if (userCredential.user != null) {
//       var userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();
//
//       if (!userSnapshot.exists) { //user doc doesn't exist
//         try {
//           email = userCredential.user!.email!;
//           username = userCredential.user!.displayName ?? "User";
//           photoURL = userCredential.user!.photoURL ?? "";
//           phoneNumber = "";
//         } catch (e) {
//           print(e);
//         }
//         await saveUserData(userCredential);
//       }
//       var userMap = userSnapshot.data()!;
//       Provider.of<UserProvider>(context, listen: false).setUserData(userCredential.user!.uid, userMap['username'],  userMap['email'], userMap['phoneNumber'], userMap['token'], userMap['imageURL']);
//       saveRememberMePref();
//       TrackingUtils().trackLogin(userCredential.user!.uid, DateTime.now().toUtc().toString());
//     }
//   }
//
//   Future<void> goToNextScreen(BuildContext context) async {
//       await PurchaseApi.init();
//       if (!PurchaseApi.isSubscribed) {
//         await AppNavigator.pushReplacement(context: context, screen: ConfirmSubscriptionScreen());
//       }else{
//         AppNavigator.pushReplacement(context: context, screen: CustomizeExperienceScreen());
//       }
//       // AppNavigator.pushReplacement(context: context, screen: MainScreen());
//   }
//
//   Future<void> saveUserData(UserCredential userCredential) async {
//     print("Saving user data");
//     //in case of phone auth: only phone number is provided in usercredential
//     //in case of email auth: only email is provided in usercredential
//     //in case of social auth: email, username and photo are provided in usercredential
//     try {
//       var language = context.locale.languageCode;
//       // log("startup language: $language");
//       var deviceToken = await FirebaseMessaging.instance
//           .getToken(); //could produce a problem if permission is not accepted especially on iOS
//       var userData = {
//         "email": email,
//         "username": username,
//         'imageURL': photoURL,
//         'phoneNumber': phoneNumber,
//         'token': deviceToken,
//         "message_tokens": 30,
//         'timestamp': DateTime.now().toUtc().toString(),
//         'language': language,
//         'status': "Hello! I'm using BargainB. Join the app",
//         'privacy': {
//           'connectContacts': true,
//           'locationServices': false,
//         },
//         'preferences': {
//           'emailMarketing': true,
//           'weekly': true,
//           'daily': false,
//         },
//       };
//       // log("USER ID: ");
//       // log(userCredential.user!.uid);
//       TrackingUtils().mixpanel.identify(userCredential.user!.uid);
//       TrackingUtils().mixpanel.getPeople()
//         ..set("\$name", username)
//         ..set('\$email', email)
//         ..set('email', email)
//         ..set('username', username)
//         ..set('imageURL', photoURL)
//         ..set('phoneNumber', phoneNumber)
//         ..set('token', deviceToken)
//         ..set('timestamp', DateTime.now().toUtc().toString())
//         ..set('language', language)
//         ..set('status', "Hello! I'm using BargainB. Join the app")
//         ..set('privacy', {
//               'connectContacts': true,
//               'locationServices': false,
//             })
//         ..set('preferences', {
//           'emailMarketing': true,
//           'weekly': true,
//           'daily': false,
//         });
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .set(userData);
//       Provider.of<UserProvider>(context, listen: false).setUserData(userCredential.user!.uid, username, email, phoneNumber, deviceToken!, photoURL);
//     }catch(e){
//       print(e);
//     }
//   }
//
//   Future<String> saveUserDeviceToken(UserCredential userCredential) async {           //duplicate in main screen
//     var deviceToken = await FirebaseMessaging.instance.getToken();              //could produce a problem if permission is not accepted especially on iOS
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userCredential.user!.uid)
//         .update({
//       'token': deviceToken,
//       'timestamp': Timestamp.now(),
//     });
//     return deviceToken!;
//     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added device token")));
//   }
//
// }
