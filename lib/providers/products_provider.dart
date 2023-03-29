import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bargainb/services/network_services.dart';

import '../models/bestValue_item.dart';
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

  Future<List<BestValueItem>> populateBestValueBargains() async {
    List<BestValueItem> bestValueBargains = [];
    await getAllProducts();
    for(var product in allProducts) {
      var id = product['id'];
      var productName = product['name'];
      var imageURL = product['image_url'];
      var subCategory = product['type_of_product'];
      var storeName = product['product_brand'];
      var description = product['product_description'];
      var price1 = product['price_1'] ?? "";
      var price2 = product['price_2'];
      var oldPrice = product['befor_offer'];
      var size1 = product['unit_size_1'] ?? "";
      var size2 = product['unit_size_2'];

      if (price1.isNotEmpty && price2.isNotEmpty) {
        var numSize1 = 0;
        var numSize2 = 0;
        var numPrice1 = 0.0;
        var numPrice2 = 0.0;
        if (size1.contains("KG")) numSize1 = 1000;
        numSize2 = int.tryParse(size2.split(' ')[0]) ?? 0;
        numPrice1 = double.parse(price1);
        numPrice2 = double.parse(price2);
        var ratio1 = numPrice1 / numSize1;
        var ratio2 = numPrice2 / numSize2;
        if (ratio1 > ratio2) {
          bestValueBargains.add(BestValueItem(itemImage: imageURL,
              subCategory: subCategory,
              itemName: productName,
              oldPrice: oldPrice,
              description: description,
              size: size1,
              itemId: id,
              price: price1, store: storeName));
        } else if (ratio2 > ratio1) {
          bestValueBargains.add(BestValueItem(itemImage: imageURL,
              subCategory: subCategory,
              itemName: productName,
              oldPrice: oldPrice,
              description: description,
              size: size2,
              itemId: id,
              price: price2, store: storeName));
        }
      }
    }
    return bestValueBargains;
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