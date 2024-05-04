import 'dart:developer';

import 'package:bargainb/features/profile/data/repos/profile_repo.dart';
import 'package:flutter/material.dart';

import '../../data/models/User.dart';

//a class to provide authenticated user data from firebase
class AuthUserProvider with ChangeNotifier {
  final ProfileRepo profileRepo;
  AuthUser? user;
  String? errorMessage;
  AuthUserProvider(this.profileRepo);

  Future<void> fetchUser() async {
    var result = await profileRepo.fetchUserData();
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      notifyListeners();
    }, (user) {
      this.user = user;
      notifyListeners();
    });
  }

  Future<void> updateUser(Map<Object, dynamic> data) async {
    var result = await profileRepo.updateUserData(data);
    result.fold((failure) {
      errorMessage = failure.errorMessage;
      notifyListeners();
    }, (hasUpdated) {
      fetchUser();
      // notifyListeners();
    });
  }
}
