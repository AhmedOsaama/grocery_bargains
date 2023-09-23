import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi{
  static const _apiKey = 'appl_HUpmOoVSBSzFEjDWMemOoWSxdBq';
  // static const _apiKey = 'goog_TKFhZiVZKEYVhHGVqldnltUOYyJ';

  static Future init() async{
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(PurchasesConfiguration(_apiKey));
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

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    }catch(e){
      print("Error in purchasing: $e");
      return false;
    }
  }

}