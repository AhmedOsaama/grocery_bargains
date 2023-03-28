import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bargainb/services/network_services.dart';

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

  Future<int> getProducts(int startingIndex) async {
    if(startingIndex == 0) allProducts.clear();
    var response = await NetworkServices.getProducts(startingIndex);
    allProducts.addAll(jsonDecode(response.body));
    allProducts.removeAt(0);
    print("Total number of products: ${allProducts.length}");
    notifyListeners();
    return response.statusCode;
  }

  // Future<void> searchProducts(String searchTerm) async {
  //   var response = await NetworkServices.searchProducts(searchTerm);
  // }

  String getImage(String storeName) {
    if(storeName == 'Albert Heijn') return albert;
    if(storeName == 'Jumbo') return jumbo;
    if(storeName == 'Spar') return spar;
    return spar;
  }
}