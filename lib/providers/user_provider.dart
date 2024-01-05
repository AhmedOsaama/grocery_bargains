import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void setUserData(String id, String name, String email, String phoneNumber, String deviceToken, String photoURL){
    print("SETTING USER DATA:");
    print(id);
    print(name);
    print(email);
    print(phoneNumber);
    print(deviceToken);
    print(photoURL);
    this.id = id;
    this.name = name;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.photoURL = photoURL;
    this.deviceToken = deviceToken;
  }

}