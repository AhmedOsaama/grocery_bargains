import 'dart:developer';
import 'dart:io';

import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi{

  static var subscriptionPeriod = "None";
  static var subscriptionPrice = "None";
  // static bool isSubscribed = true;

  static Future init() async{
    var apiKey = Platform.isIOS ? 'appl_HUpmOoVSBSzFEjDWMemOoWSxdBq' : 'goog_TKFhZiVZKEYVhHGVqldnltUOYyJ';
    try {
      await Purchases.configure(PurchasesConfiguration(apiKey)
        ..appUserID = FirebaseAuth.instance.currentUser!.uid);
      // print("USER ID: ${FirebaseAuth.instance.currentUser!.uid}");
    }catch(e){
      debugPrint("ISSUE WITH INIT PURCHASE API: current user is null");
      await Purchases.configure(PurchasesConfiguration(apiKey));
    }
    // await checkSubscriptionStatus();
  }

  static Future<List<Offering>> fetchOffers() async {
    // await init();
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
    } on PlatformException catch(e){
      print(e);
      return [];
    }
  }

  static Future<bool> checkSubscriptionStatus() async {
   var value = await Purchases.getCustomerInfo();
   if(value.entitlements.all.containsKey('all_analysis_features')) {
     try {
       if (value.entitlements.all['all_analysis_features']!.isActive) {
         var productIdentifier = value.entitlements.all['all_analysis_features']!.productIdentifier;
         var product = await getSubscriptionProduct(productIdentifier);
         subscriptionPeriod = getSubscriptionPeriod(productIdentifier);
         subscriptionPrice = getSubscriptionPriceString(product);
         return true;
       }
     } catch (e) {
       log("ERROR GETTING SUBSCRIPTION STATUS: $e");
     }
   }
   return false;
  }

  static Future<StoreProduct> getSubscriptionProduct(String productIdentifier) async {
    var products = await Purchases.getProducts([productIdentifier]);
    var product = products.first;
    return product;
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      log(customerInfo.toString());
      await checkSubscriptionStatus();
      return true;
    }catch(e){
      print("Error in purchasing: $e");
      return false;
    }
  }

  static Future<bool> purchaseSubscriptionOption(SubscriptionOption subscriptionOption) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchaseSubscriptionOption(subscriptionOption);
      log(customerInfo.toString());
      await checkSubscriptionStatus();
      return true;
    }catch(e){
      print("Error in purchasing: $e");
      return false;
    }
  }

  static Future<bool> purchaseDiscountedPackage(Package package, PromotionalOffer offer) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchaseDiscountedPackage(package, offer);
      log(customerInfo.toString());
      await checkSubscriptionStatus();
      return true;
    }catch(e){
      print("Error in purchasing: $e");
      return false;
    }
  }

  static String getSubscriptionPriceString(StoreProduct product) {
    return product.priceString;
  }

  static double getSubscriptionPrice(StoreProduct product) {
    return product.price;
  }

  static String getPricePerMonth(String subscriptionPeriod, double subscriptionPrice){
    if(subscriptionPeriod == "Monthly"){
      return "$subscriptionPrice / Month";
    }if(subscriptionPeriod == "Yearly"){
      return "${(subscriptionPrice / 12).toStringAsFixed(2)} / Month";
    }
    return LocaleKeys.onePayment.tr();
  }

  static String getSubscriptionPeriod(String productIdentifier) {
    if (Platform.isIOS) {
      if (productIdentifier == "bargain_0109_1m") {
        return "Monthly";
      }
      if (productIdentifier == "bargain_0949_1m") {
        return "Yearly";
      }
    } else {
      if (productIdentifier == "bargain_0109_1m") {
        return "Monthly";
      }
      if (productIdentifier == "bargain_0949_1y") {
        return "Yearly";
      }
    }
    return "None";
  }

  static String getProductIdentifier(String productPeriod) {
    if (Platform.isIOS) {
      if (productPeriod == "Monthly") {
        return "bargain_0109_1m";
      }
      if (productPeriod == "Yearly") {
        return "bargain_0949_1m";
      }
    } else {
      if (productPeriod == "Monthly") {
        return "bargain_0109_1m";
      }
      if (productPeriod == "Yearly") {
        return "bargain_0949_1y";
      }
    }
    return "None";
  }


}