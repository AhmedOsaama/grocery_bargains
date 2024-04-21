import 'package:bargainb/models/bargainb_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class RegisterRepo {
  Future<void> saveRememberMePref(bool rememberMe);

  Future<void> submitAuthForm({required BargainbUser user, required BuildContext context, required bool isLogin});

  Future<void> finalizePhoneSignup(UserCredential userCredential, BuildContext context);

  Future<void> finalizePhoneLogin(BuildContext context, UserCredential userCredential, QuerySnapshot<Map<String, dynamic>> result);

  Future<void> authenticateUser({required BuildContext context, required BargainbUser user,
  required GlobalKey<FormState> formKey, required bool isLogin, required bool rememberMe});

  Future<UserCredential> loginWithPhoneNumber(String phoneNumber, BuildContext context);

  Future showOtpDialog(BuildContext context, String phoneNumber);

  Future<void> loginWithSocial(BuildContext context, bool isApple, bool rememberMe);

  Future<UserCredential?> loginWithApple();

  Future<void> storeUserInfo({required BuildContext context,
    required UserCredential userCredential});

  Future<void> goToNextScreen(BuildContext context);

  Future<void> saveUserData(UserCredential userCredential, BuildContext context);

  Future<String> saveUserDeviceToken(UserCredential userCredential);
}
