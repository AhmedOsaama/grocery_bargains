import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swaav/services/network_services.dart';

import '../utils/assets_manager.dart';

class ProductsProvider with ChangeNotifier{
  List allProducts = [];
  Future<int> getAllProducts() async {
    var response = await NetworkServices.getAllProducts();
    allProducts = jsonDecode(response.body);
    print("Total number of products: ${allProducts.length}");
    notifyListeners();
    return response.statusCode;
  }

  String getImage(String storeName) {
    if(storeName == 'Albert Heijn') return albert;
    if(storeName == 'Jumbo') return jumbo;
    return spar;
  }
}