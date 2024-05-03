import 'package:bargainb/core/utils/firestore_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'google_sign_in_provider.dart';

class UserProvider with ChangeNotifier{
  bool isFirstTime = false;
  String id = 'GuestID';
  String name = 'Guest';
  String email = 'GuestEmail';
  String phoneNumber = 'GuestNumber';
  String photoURL = 'GuestNumber';
  String deviceToken = 'GuestNumber';
  String onboardingSubscriptionPlan = 'Yearly';
  String onboardingSubscriptionPlanPrice = '11.84';
  String onboardingStore = 'Store';

  Future<Null> setOnboardingSubscriptionPlan(String plan, String price) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("plan", plan);
    prefs.setString("planPrice", price);
    onboardingSubscriptionPlan = plan;
    onboardingSubscriptionPlanPrice = price;
    notifyListeners();
  }

  Future<Null> setOnboardingStore(String store) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("store", store);
    onboardingStore = store;
    notifyListeners();
  }

  Future<Null> getOnboardingStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var store = prefs.getString("store") ?? "Store";
    onboardingStore = store;
    notifyListeners();
  }

  Future<Null> getFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstTime = prefs.getBool("firstTime") ?? true;
  }

  Future<Null> turnOffFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("firstTime", false);
    isFirstTime = false;
    notifyListeners();
  }

  Future<Null> turnOnFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("firstTime", true);
    isFirstTime = true;
    notifyListeners();
  }

  ///Checks whether a logged in user is a hubspot contact
  Future<bool> getHubSpotStatus() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser != null) {
     var docRef = await FirestoreUtils.firestoreUserCollection.doc(currentUser.uid).get();
     bool hubspotStatus = docRef.get('isHubspotContact');
     return hubspotStatus;
    }
    return false;
  }

  Future<void> signOut(BuildContext context) async {
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
    print("SIGNED OUT...................");
  }

  void setUserData(String id, String name, String email, String phoneNumber, String deviceToken, String photoURL){
    this.id = id;
    this.name = name;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.photoURL = photoURL;
    this.deviceToken = deviceToken;
  }

}