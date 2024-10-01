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





  void getAllCategories() async {
    try {
      categories = [
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/100.jpg', category: "Vegetable and fruit"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/200.jpg', category: "meat and seafood"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/300.jpg', category: "dairy"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/700.jpg', category: "bakery"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/400.jpg', category: "ready meals"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/600.jpg', category: "frozen food"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/800.jpg', category: "breakfast"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/1100.jpg', category: "snacks"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/900.jpg', category: "drinks"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/1300.jpg', category: "international"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/1400.jpg', category: "sauces"),
        ProductCategory(image: 'https://firebasestorage.googleapis.com/v0/b/discountly.appspot.com/o/categories%2Fhealth.png?alt=media&token=add04c4e-6394-490f-b46c-9bf46898b48b', category: "health"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/1800.jpg', category: "pet"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/1500.jpg', category: "household"),
        ProductCategory(image: 'https://cdn.hoogvliet.com/Images/Content/Category/1600.jpg', category: "baby kids"),
        ProductCategory(image: 'https://firebasestorage.googleapis.com/v0/b/discountly.appspot.com/o/categories%2FIMG_6406.png?alt=media&token=a7060fa1-d47e-42f0-b519-9fcf2fc13ce9', category: "Non food"),
      ];
    }catch(e){
      print("Error getting all categories: $e");
    }
    notifyListeners();
  }

  // Future<void> goToProductPage(String storeName, BuildContext context, int productId) async {
  //   var product = await getProductById(productId);
  //   if(product == null) return;
  //   // var product = products.firstWhere((element) => element.id == productId);
  //   AppNavigator.push(
  //       context: context,
  //       screen: ProductDetailScreen(
  //       product: product,
  //       ));
  //   try{
  //     TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open product page", DateTime.now().toUtc().toString(), "Chatlist screen");
  //   }catch(e){
  //     print(e);
  //     TrackingUtils().trackButtonClick("Guest", "Open product page", DateTime.now().toUtc().toString(), "Chatlist screen");
  //   }
  // }

  // void shareProductViaDeepLink(String itemName, int itemId, String storeName, BuildContext context) async {
  //   BranchUniversalObject buo = BranchUniversalObject(
  //       canonicalIdentifier: 'invite_to_product',
  //       title: itemName,
  //       imageUrl:
  //           'https://play-lh.googleusercontent.com/u6LMBvrIXH6r1LFQftqjSzebxflasn-nhcoZUlP6DjWHV6fmrwgNFyjJeFwFmckrySHF=w240-h480-rw',
  //       contentDescription: 'Hey, check out this product ${itemName} from BargainB',
  //       publiclyIndex: true,
  //       locallyIndex: true,
  //       contentMetadata: BranchContentMetaData()
  //         ..addCustomMetadata('product_data', jsonEncode({"product_id": itemId, "store_name": storeName})));
  //   BranchLinkProperties lp = BranchLinkProperties(
  //       channel: 'facebook', feature: 'sharing product', stage: 'new share', tags: ['one', 'two', 'three']);
  //   BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
  //
  //   if (response.success) {
  //     print('Link generated: ${response.result}');
  //   } else {
  //     print('Error : ${response.errorCode} - ${response.errorMessage}');
  //   }
  //   var productCategory = 'N/A';
  //   try {
  //     var product =
  //     await Provider
  //         .of<ProductsProvider>(context, listen: false)
  //         .getProductById(itemId);
  //     productCategory = product.category;
  //   }catch(e){
  //     print(e);
  //   }
  //   await Share.share(response.result);
  //   TrackingUtils().trackShareProduct(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), itemId.toString(), itemName, productCategory);
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

}
