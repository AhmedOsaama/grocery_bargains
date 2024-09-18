import 'dart:convert';
import 'dart:developer';

import 'package:bargainb/features/home/data/models/product_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:bargainb/services/network_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../config/routes/app_navigator.dart';
import '../features/home/data/models/product.dart';
import '../utils/assets_manager.dart';
import '../utils/icons_manager.dart';
import '../utils/tracking_utils.dart';
import '../features/home/presentation/views/product_detail_screen.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> deals = [];

  List<Product> products = [];

  List<ProductCategory> categories = [];


  ///gettingAll

  Future<List<Product>> getProducts(int startingIndex,) async {
    List<Product> products = [];
    var response = await NetworkServices.getLimitedProducts(startingIndex, 100);
    List productsList = jsonDecode(response.body);
    for(var decodedProduct in productsList) {
      var product = Product.fromJson(decodedProduct);
      if(product.availableNow == 1) products.add(product);
    }
    // products.shuffle();
    this.products.addAll(products);
    notifyListeners();
    return products;
  }

  Future<List<Product>> getSimilarProducts(int id) async {
    List<Product> products = [];
    try {
      var response = await NetworkServices.getSimilarProducts(id);
      List productsList = jsonDecode(response.body)['data'];
      for (var decodedProduct in productsList) {
        var product = Product.fromJson(decodedProduct);
        products.add(product);
      }
    }catch(e){
      log("Error getting similar products: $e");
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
    notifyListeners();
  }

  Future<int> getAllCategories() async {
    var response = await NetworkServices.getAllCategories();
    try {
      categories = productCategoryFromJson(response.body);
    }catch(e){
      print("Error getting all categories: $e");
    }
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





  Future<void> goToProductPage(String storeName, BuildContext context, int productId) async {
    var product = await getProductById(productId);
    if(product == null) return;
    // var product = products.firstWhere((element) => element.id == productId);
    AppNavigator.push(
        context: context,
        screen: ProductDetailScreen(
        product: product,
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

  // String getImage(String storeName) {
  //   if (storeName == 'AH') return albert;
  //   if (storeName == 'Albert') return albert;
  //   if (storeName == 'Jumbo') return jumbo;
  //   if (storeName == 'Hoogvliet') return hoogLogo;
  //   if (storeName == 'Dirk') return dirkLogo;
  //   return albert;
  // }

  String getStoreLogoPath(String selectedStore){
    if(selectedStore == "albert"){
      return albertLogo;
    }if(selectedStore == "jumbo"){
      return jumbo;
    }if(selectedStore == "hoogvliet"){
      return hoogvlietLogo;
    }
    if(selectedStore == "Dirk"){
      return dirkLogo;
    }
    if(selectedStore == "edeka24"){
      return edeka;
    }
    if(selectedStore == "Plus"){
      return plus;
    }
    if(selectedStore == "Rewe"){
      return rewe;
    }
    if(selectedStore == "Coop"){
      return coop;
    }
    if(selectedStore == "Spar"){
      return spar;
    }
    if(selectedStore == "Aldi"){
      return aldi;
    }
    return imageError;
  }

  // String getStoreName(int storeId){
  //   if(storeId == 1) return "Albert";
  //   if(storeId == 2) return "Jumbo";
  //   if(storeId == 3) return "Hoogvliet";
  //   if(storeId == 4) return "Dirk";
  //   return "N/A";
  // }
}
