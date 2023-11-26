import 'dart:convert';
import 'dart:developer';

import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/models/product_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:bargainb/services/network_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../config/routes/app_navigator.dart';
import '../models/bestValue_item.dart';
import '../models/product.dart';
import '../utils/assets_manager.dart';
import '../utils/icons_manager.dart';
import '../utils/tracking_utils.dart';
import '../view/screens/product_detail_screen.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> deals = [];

  List<Product> products = [];
  List<BestValueItem> bestValueBargains = [];

  List<ProductCategory> categories = [];


  ///gettingAll

  Future<List<Product>> getProducts(int startingIndex,) async {
    List<Product> products = [];
    var response = await NetworkServices.getLimitedProducts(startingIndex, 100);
    List productsList = jsonDecode(response.body);
    for(var decodedProduct in productsList){
      var product = Product.fromJson(decodedProduct);
      if(product.availableNow == 1) products.add(product);
    }
    // products.shuffle();
    this.products.addAll(products);
    notifyListeners();
    return products;
  }

  Future<List<Product>> getSimilarProducts(String gtin) async {
    List<Product> products = [];
    try {
      var response = await NetworkServices.getSimilarProducts(gtin);
      List productsList = jsonDecode(response.body);
      for (var decodedProduct in productsList) {
        var product = Product.fromJson(decodedProduct);
        products.add(product);
      }
    }catch(e){
      print("Error getting similar products: $e");
    }
    return products;
  }

  Future<Product> getProductById(int id) async {
    try{
    var response = await NetworkServices.getProductById(id);
    List productsList = jsonDecode(response.body);
    var product = Product.fromJson(productsList[0]);
    return product;
    }catch(e){
      print("Error getting a product by ID");
      return Future.value();
    }
  }

  Future<void> getAllProducts() async {
    await getProducts(0).catchError((e) => print(e));
    print("Total number of products: ${products.length}");
    print("Best value bargains Length: ${bestValueBargains.length}");
    notifyListeners();
  }

  Future<int> getAllCategories() async {
    var response = await NetworkServices.getAllCategories();
    try {
      categories = productCategoryFromJson(response.body);
    }catch(e){
      print("Error getting all categories: $e");
    }
    print("categories length: ${categories.length}");
    notifyListeners();
    return response.statusCode;
  }

  Future<List<Product>> getProductsByCategory(String category, int pageNumber) async {
    List<Product> products = [];
    var response = await NetworkServices.getLimitedAlbertProductsByCategory(category.trim(), pageNumber);
    List productsList = jsonDecode(response.body);
    for(var decodedProduct in productsList) {
      var product = Product.fromJson(decodedProduct);
      products.add(product);
    }
    // products.shuffle();
    return products;
  }

  Future<List<Product>> getProductsBySubCategory(String subCategory, int pageNumber) async {
    List<Product> products = [];
    var response = await NetworkServices.getLimitedAlbertProductsBySubCategory(subCategory.trim(), pageNumber);
    List productsList = jsonDecode(response.body);
    for(var decodedProduct in productsList) {
      var product = Product.fromJson(decodedProduct);
      products.add(product);
    }
    // products.shuffle();
    return products;
  }

  ///MISC

  List sortProducts(String filter, List pro) {
    var sortedProducts = pro;
    try {
      switch (filter) {
        case 'Low price':
          sortedProducts.sort((a, b) => double.parse(a!.price!).compareTo(double.parse(b!.price!)));
          break;
        case 'High price':
          sortedProducts.sort((a, b) => double.parse(b!.price!).compareTo(double.parse(a!.price!)));
          break;

        /* case 'Nutri Score A - E':

        break; */
      }
    } catch (e) {
      log(e.toString());
    }

    return sortedProducts;
  }

  int getMeasurementConversion(String measurement) {
    if (measurement == "g" || measurement == "gram" || measurement == "ml") {
      return 1;
    }
    if (measurement == "KG" || measurement == "kg" || measurement == "LT" || measurement == "l") {
      return 1000;
    }
    if (measurement == "100g") {
      return 100; //case ca. 100g where this will be considered as 1 * 100 = 100 g
    }
    return 1;
  }



  // Future<List<Product?>> searchProducts(String searchTerm) async {
  //   var isRelevant = true;
  //   if(searchTerm.contains("Relevance")){
  //     searchTerm = searchTerm.split('-')[0];
  //    isRelevant = true;
  //   }else{
  //     isRelevant = false;
  //   }
  //
  //   try {
  //     var response = await Future.wait([
  //       NetworkServices.searchAlbertProducts(searchTerm, isRelevant),
  //       NetworkServices.searchJumboProducts(searchTerm, isRelevant),
  //       NetworkServices.searchHoogvlietProducts(searchTerm, isRelevant),
  //       NetworkServices.searchDirkProducts(searchTerm, isRelevant),
  //     ]);
  //
  //     List<Product> albertProducts = [];
  //     List decodedAlbert = jsonDecode(response[0].body);
  //     for (var decodedProduct in decodedAlbert) {
  //       var product = Product.fromJson(decodedProduct);
  //       albertProducts.add(product);
  //     }
  //
  //     List<Product> jumboProducts = [];
  //     List decodedJumbo = jsonDecode(response[1].body);
  //     for (var decodedProduct in decodedJumbo) {
  //       var product = Product.fromJson(decodedProduct);
  //       jumboProducts.add(product);
  //     }
  //
  //     List<Product> hoogvlietProducts = [];
  //     List decodedHoogvliet = jsonDecode(response[2].body);
  //     for (var decodedProduct in decodedHoogvliet) {
  //       var product = Product.fromJson(decodedProduct);
  //       hoogvlietProducts.add(product);
  //     }
  //
  //     List<Product> dirkProducts = [];
  //     List decodedDirk = jsonDecode(response[3].body);
  //     for (var decodedProduct in decodedDirk) {
  //       var product = Product.fromJson(decodedProduct);
  //       dirkProducts.add(product);
  //     }
  //
  //     var searchResult = [...albertProducts, ...jumboProducts, ...hoogvlietProducts, ...dirkProducts];
  //     searchResult.shuffle();
  //     try {
  //       TrackingUtils().trackSearchPerformed("filter", FirebaseAuth.instance.currentUser!.uid, searchTerm);
  //     }catch(e){}
  //     return searchResult;
  //   }catch(e){
  //     print(e);
  //     return [];
  //   }
  //
  // }


  Future<void> goToProductPage(String storeName, BuildContext context, int productId) async {
    var product = await getProductById(productId);
    if(product == null) return;
    // var product = products.firstWhere((element) => element.id == productId);
    AppNavigator.push(
        context: context,
        screen: ProductDetailScreen(
          productId: product.id,
          productBrand: product.brand,
          oldPrice: product.oldPrice,
          storeName: getStoreName(product.storeId),
          productName: product.name,
          imageURL: product.image,
          description: product.description,
          size1: product.unit,
          productCategory: product.category,
          price1: double.tryParse(product.price ?? "") ?? 0.0, gtin: product.gtin,
        ));
    try{
      TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open product page", DateTime.now().toUtc().toString(), "Chatlist screen");
    }catch(e){
      print(e);
      TrackingUtils().trackButtonClick("Guest", "Open product page", DateTime.now().toUtc().toString(), "Chatlist screen");
    }
  }

  void shareProductViaDeepLink(String itemName, int itemId, String storeName, BuildContext context) async {
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'invite_to_product',
        title: itemName,
        imageUrl:
            'https://play-lh.googleusercontent.com/u6LMBvrIXH6r1LFQftqjSzebxflasn-nhcoZUlP6DjWHV6fmrwgNFyjJeFwFmckrySHF=w240-h480-rw',
        contentDescription: 'Hey, check out this product ${itemName} from BargainB',
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('product_data', jsonEncode({"product_id": itemId, "store_name": storeName})));
    BranchLinkProperties lp = BranchLinkProperties(
        channel: 'facebook', feature: 'sharing product', stage: 'new share', tags: ['one', 'two', 'three']);
    BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);

    if (response.success) {
      print('Link generated: ${response.result}');
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
    }
    var productCategory = 'N/A';
    try {
      var product =
      await Provider
          .of<ProductsProvider>(context, listen: false)
          .getProductById(itemId);
      productCategory = product.category;
    }catch(e){
      print(e);
    }
    await Share.share(response.result);
    TrackingUtils().trackShareProduct(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), itemId.toString(), itemName, productCategory);
  }

  String getImage(String storeName) {
    if (storeName == 'AH') return albert;
    if (storeName == 'Albert') return albert;
    if (storeName == 'Jumbo') return jumbo;
    if (storeName == 'Hoogvliet') return hoogLogo;
    if (storeName == 'Dirk') return dirkLogo;
    return albert;
  }

  String getStoreLogoPath(String selectedStore){
    if(selectedStore == "Albert"){
      return albertLogo;
    }if(selectedStore == "Jumbo"){
      return jumbo;
    }if(selectedStore == "Hoogvliet"){
      return hoogvlietLogo;
    }if(selectedStore == "Dirk"){
      return dirkLogo;
    }
    return imageError;
  }

  String getStoreName(int storeId){
    if(storeId == 1) return "Albert";
    if(storeId == 2) return "Jumbo";
    if(storeId == 3) return "Hoogvliet";
    if(storeId == 4) return "Dirk";
    return "N/A";
  }
}
