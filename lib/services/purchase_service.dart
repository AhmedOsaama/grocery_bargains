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
  static var subscriptionPricePerMonth = "None";
  static bool isSubscribed = false;

  static Future init() async{
    var apiKey = Platform.isIOS ? 'appl_HUpmOoVSBSzFEjDWMemOoWSxdBq' : 'goog_TKFhZiVZKEYVhHGVqldnltUOYyJ';
    await Purchases.setLogLevel(LogLevel.debug);
    // await Purchases.configure(PurchasesConfiguration(apiKey));
    try {
      await Purchases.configure(PurchasesConfiguration(apiKey)
        ..appUserID = FirebaseAuth.instance.currentUser!.uid);
    }catch(e){
      print(e);
      await Purchases.configure(PurchasesConfiguration(apiKey));
    }
    await checkSubscriptionStatus();
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
    } on PlatformException catch(e){
      print(e);
      return [];
    }
  }

  static Future<void> checkSubscriptionStatus() async {
   var value = await Purchases.getCustomerInfo();
   try {
     if (value.entitlements.all['all_analysis_features']!.isActive) {
       var productIdentifier = value.entitlements.all['all_analysis_features']!.productIdentifier;
       var product = await getSubscriptionProduct(productIdentifier);
       subscriptionPeriod = getSubscriptionPeriod(productIdentifier);
       subscriptionPrice = getSubscriptionPriceString(product);
       subscriptionPricePerMonth = getPricePerMonth(subscriptionPeriod, getSubscriptionPrice(product));
       isSubscribed = true;
     }
   }catch(e){
     print(e);
   }
  }

  static Future<StoreProduct> getSubscriptionProduct(String productIdentifier) async {
    print("Product identifier: $productIdentifier");
    if(productIdentifier == "bargainb_1599_l" || productIdentifier == "bargain_lifetime_1599"){
      var products = await Purchases.getProducts([productIdentifier], productCategory: ProductCategory.nonSubscription);
      print("Products: ${products}");
      var product = products.first;
      return product;
    }
    var products = await Purchases.getProducts([productIdentifier]);
    print("Products: ${products}");
    var product = products.first;
    return product;
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
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
      return (subscriptionPrice / 12).toStringAsFixed(2) + " / Month";
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
      if (productIdentifier == "bargainb_1599_l") {
        return "Lifetime";
      }
    } else {
      if (productIdentifier == "bargain_0109_1m") {
        return "Monthly";
      }
      if (productIdentifier == "bargain_0949_1y") {
        return "Yearly";
      }
      if (productIdentifier == "bargain_lifetime_1599") {
        return "Lifetime";
      }
    }
    return "None";
  }


}