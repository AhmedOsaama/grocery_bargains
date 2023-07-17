import 'dart:convert';
import 'dart:developer';

import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/models/product_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:bargainb/services/network_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:share_plus/share_plus.dart';

import '../config/routes/app_navigator.dart';
import '../models/bestValue_item.dart';
import '../models/product.dart';
import '../utils/assets_manager.dart';
import '../utils/tracking_utils.dart';
import '../view/screens/product_detail_screen.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> jumboProducts = [];
  List<Product> albertProducts = [];
  List<Product> hoogvlietProducts = [];
  List<Product> deals = [];

  List<ComparisonProduct> comparisonProducts = [];
  List<BestValueItem> bestValueBargains = [];

  List<ProductCategory> categories = [];

  Product? convertToAlbertProductFromJson(decodedProduct) {
    Product? albertProduct;
    try {
      var id = decodedProduct['id'];
      var productName = decodedProduct['name'];
      var imageURL = decodedProduct['image_url'];
      var storeName = "Albert";
      var description = decodedProduct['product_description'];
      var brand = decodedProduct['product_brand'];
      var category = decodedProduct['product_category'] ?? "";
      var subCategory = decodedProduct['type_of_product'];
      var price1 = decodedProduct['price_2'];
      var price2 = '';
      if (price1 == null && price2 == null) return null;
      var oldPrice = decodedProduct['befor_offer'];
      var size1 = decodedProduct['unit_size_2'];
      var size2 = '';
      var offer = decodedProduct['new_offer'];
      var productURL = decodedProduct['product_link'];

      albertProduct = Product(
          storeName: storeName,
          id: id,
          offer: offer,
          brand: brand,
          subCategory: subCategory,
          oldPrice: oldPrice,
          price: price1,
          price2: price2,
          description: description,
          imageURL: imageURL,
          name: productName,
          size: size1,
          size2: size2,
          category: category,
          url: productURL);
    } catch (e) {
      log(e.toString());
      print(decodedProduct['name']);
      print("Error in converting Albert json to product");
      print(e);
    }

    return albertProduct;
  }

  Product? convertToJumboProductFromJson(decodedProduct) {
    Product? jumboProduct;
    try {
      var id = decodedProduct['id'];
      var productName = decodedProduct['name'] ?? "N/A";
      var imageURL = decodedProduct['image_url'] ?? "";
      var storeName = "Jumbo";
      var description = decodedProduct['product_description'] ?? "";
      var category = decodedProduct['product_category'] ?? "";
      var subCategory = decodedProduct['subcategory'] ?? "";
      var price1 = decodedProduct['price'];
      var price2 = null;
      var oldPrice = decodedProduct['old_price'];
      var size1 = decodedProduct['unit_size'] ?? "NO SIZE";
      var size2 = null;
      var offer = decodedProduct['offer'];
      var productURL = decodedProduct['product_link'];
      var brand = decodedProduct['brand'] ?? '';

      jumboProduct = Product(
          storeName: storeName,
          id: id,
          offer: offer,
          brand: brand,
          subCategory: subCategory,
          oldPrice: oldPrice,
          price: price1,
          price2: price2,
          description: description,
          imageURL: imageURL,
          name: productName,
          size: size1,
          size2: size2,
          category: category,
          url: productURL);
    } catch (e) {
      print("Error in converting Jumbo json to product");
      print(e);
    }
    return jumboProduct;
  }

  Product? convertToHoogvlietProductFromJson(decodedProduct) {
    Product? hoogvlietProduct;
    try {
      var id = decodedProduct['id'];
      var productName = decodedProduct['name'];
      if (productName == null) return null;
      var imageURL = decodedProduct['image_link'];
      if (imageURL == null) return null;
      var storeName = "Hoogvliet";
      var description = decodedProduct['description'] ?? "";
      var category = decodedProduct['category'] ?? "";
      var subCategory = decodedProduct['type_of_product'] ?? "";
      var price1 = decodedProduct['price'];
      if (price1 == null) return null;
      var price2 = "";
      var oldPrice = decodedProduct['was_price'];
      var size1 = decodedProduct['unit'];
      if (size1 == null) return null;
      var size2 = "";
      var offer = decodedProduct['offer'];
      var productURL = decodedProduct['product_link'] ?? "";
      var brand = decodedProduct['brand'] ?? "";

      hoogvlietProduct = Product(
          storeName: storeName,
          id: id,
          offer: offer,
          brand: brand,
          subCategory: subCategory,
          oldPrice: oldPrice,
          price: price1,
          price2: price2,
          description: description,
          imageURL: imageURL,
          name: productName,
          size: size1,
          size2: size2,
          category: category,
          url: productURL);
    } catch (e) {
      print("Error in converting Hoogvliet json to product");
      print(e);
    }
    return hoogvlietProduct;
  }

  List<Product> convertToProductListFromJson(decodedProductsList) {
    List<Product> productList = [];
    try {
      for (var product in decodedProductsList) {
        var id = product['id'];
        var productName = product['name'];
        var imageURL = product['image_url'];
        var storeName = product.containsKey('product_brand') ? "Albert" : "Jumbo";
        var brand = product.containsKey('product_brand') ? product['product_brand'] : "";
        var description = product['product_description'];
        var category = product['product_category'] ?? "";
        var subCategory = product.containsKey('type_of_product') ? product['type_of_product'] : null;
        var price1 = product['price_2'];
        var price2 = null;
        var oldPrice = product.containsKey('befor_offer') ? product['befor_offer'] : product['old_price'];
        var size1 = product['unit_size_2'];
        var size2 = null;
        var offer = product.containsKey('new_offer') ? product['new_offer'] : product['offer'];
        var productURL = product['product_link'];

        var productObj = Product(
            storeName: storeName,
            id: id,
            offer: offer,
            brand: brand,
            subCategory: subCategory,
            oldPrice: oldPrice,
            price: price1,
            price2: price2,
            description: description,
            imageURL: imageURL,
            name: productName,
            size: size1,
            size2: size2,
            category: category,
            url: productURL);
        productList.add(productObj);
      }
    } catch (e) {
      print("Error converting to products list from json");
      print(e);
    }
    // print("PRODUCTS LENGTH: " + productList.length.toString());
    return productList;
  }

  List<Product> convertToHoogvlietProductListFromJson(decodedProductsList) {
    List<Product> productList = [];
    try {
      for (var product in decodedProductsList) {
        var id = product['id'];
        var productName = product['name'] ?? "";
        var imageURL = product['image_link'] ?? "";
        var storeName = "Hoogvliet";
        var description = product['description'] ?? "";
        var category = product['category'] ?? "";
        var subCategory = product['type_of_product'] ?? "";
        var price = product['price'] ?? "";
        var oldPrice = product['was_price'] ?? "";
        var size1 = product['unit'] ?? "";
        var offer = product['offer'] ?? "";
        var productURL = product['product_link'] ?? "";
        var brand = product['brand'] ?? "";

        productList.add(Product(
            storeName: storeName,
            id: id,
            offer: offer,
            brand: brand,
            subCategory: subCategory,
            oldPrice: oldPrice,
            price: price,
            price2: "",
            description: description,
            imageURL: imageURL,
            name: productName,
            size: size1,
            size2: "",
            category: category,
            url: productURL));
      }
    } catch (e) {
      print(e);
    }
    print("Hoogvliet PRODUCTS LENGTH: " + productList.length.toString());
    return productList;
  }

  Future<List<ComparisonProduct>> convertToComparisonProductListFromJson(decodedProductsList) async {
    List<ComparisonProduct> comparisonList = [];

    for (var product in decodedProductsList) {
      try {
        var id = product['id'];
        var albertId = product['a_id'];
        var jumboId = product['j_id'];
        var hoogvlietId = product['h_id'];
        var albertName = product['albert_name'];
        var jumboName = product['jumbo_name'];
        var hoogvlietName = product['hoogvliet_name'];

        comparisonList.add(ComparisonProduct(
          id: id,
          albertId: albertId,
          jumboId: jumboId,
          hoogvlietId: hoogvlietId,
          jumboName: jumboName,
          albertName: albertName,
          hoogvlietName: hoogvlietName,
        ));
        // log('Comparison Finished + ${DateTime.now()}');
      } catch (e) {
        print("Error in comparisons");
        print(e);
      }
    }

    print("COMPARISON PRODUCTS LENGTH: " + comparisonList.length.toString());
    return comparisonList;
  }

  Future<void> addAlbertProduct(albertLink) async {
    //get Albert product using link
    var response = await NetworkServices.searchAlbertProductByName(albertLink);
    //convert json Albert to Product
    var decodedProducts = jsonDecode(response.body);
    if (decodedProducts.isEmpty || jsonDecode(response.body)[0] == null) return;
    var albertProduct = convertToAlbertProductFromJson(jsonDecode(response.body)[
        0]); //might fail with range error if it couldn't find the albert product in the above function. e.g. array is empty
    //add Albert product to the list of Albert products
    if (albertProduct != null) {
      albertProducts.add(albertProduct);
    } else {
      throw "Invalid Albert product: product is null";
    }
  }

  Future<void> addJumboProduct(jumboLink) async {
    //get jumbo product using link
    var response = await NetworkServices.searchJumboProductByName(jumboLink);
    //convert json jumbo to Product
    var decodedProducts = jsonDecode(response.body);
    if (decodedProducts.isEmpty || jsonDecode(response.body)[0] == null) return;
    var jumboProduct = convertToJumboProductFromJson(jsonDecode(response.body)[0]);
    //add jumbo product to the list of jumbo products
    if (jumboProduct != null) {
      jumboProducts.add(jumboProduct);
    } else {
      throw "Invalid Jumbo product: product is null";
    }
  }

  Future<void> addHoogvlietProduct(hoogvlietLink) async {
    //get hoogvliet product using link
    var response = await NetworkServices.searchHoogvlietProductByName(hoogvlietLink);
    //convert json hoogvliet to Product
    var decodedProducts = jsonDecode(response.body);
    if (decodedProducts.isEmpty || jsonDecode(response.body)[0] == null) return;
    var hoogvlietProduct = convertToHoogvlietProductFromJson(jsonDecode(response.body)[0]);
    //add hoogvliet product to the list of hoogvliet products
    if (hoogvlietProduct != null) {
      hoogvlietProducts.add(hoogvlietProduct);
    } else {
      throw "Invalid Hoogvliet product: product is null";
    }
  }

  // Future<int> getAllPriceComparisons() async {
  //   var decodedProductsList = [];
  //   var response = await NetworkServices.getAllPriceComparisons();
  //   decodedProductsList = jsonDecode(response.body);
  //   comparisonProducts = await convertToComparisonProductListFromJson(decodedProductsList);
  //   print("Total number of comparison products: ${comparisonProducts.length}");
  //   notifyListeners();
  //   return response.statusCode;
  // }

  Future<void> getAllProducts() async {
    await Future.wait([getAllComparisons(), getAllAlbertProducts(), getAllJumboProducts(), getAllHoogvlietProducts()]);
    print("Total number of comparisons: ${comparisonProducts.length}");
    print("Albert Products Length: ${albertProducts.length}");
    print("Jumbo Products Length: ${jumboProducts.length}");
    print("Hoogvliet Products Length:  ${hoogvlietProducts.length}");
    print("Best value bargains Length: ${bestValueBargains.length}");
    notifyListeners();
  }

  Future<List<ComparisonProduct>> getAllComparisons() async {
    var decodedProductsList = [];
    comparisonProducts.clear();
    var response = await NetworkServices.getAllComparisons();
    decodedProductsList = jsonDecode(response.body);
    final comparisons = await convertToComparisonProductListFromJson(decodedProductsList);
    comparisonProducts.addAll(comparisons);

    // notifyListeners();
    return comparisons;
  }

  Future<int> getAllAlbertProducts() async {
    var decodedProductsList = [];
    var response = await NetworkServices.getAllAlbertProducts();
    try {
      decodedProductsList = jsonDecode(response.body);
      albertProducts = convertToProductListFromJson(decodedProductsList);
    } catch (e) {
      print("Error getting albert products");
      print(e);
    }
    // print("Total number of Albert products: ${albertProducts.length}");
    // notifyListeners();
    return response.statusCode;
  }

  Future<int> getAllJumboProducts() async {
    var decodedProductsList = [];
    jumboProducts.clear();
    var response = await NetworkServices.getAllJumboProducts();
    try {
      decodedProductsList = jsonDecode(response.body);
      decodedProductsList.forEach((decodedProduct) {
        var jumboProduct = convertToJumboProductFromJson(decodedProduct);
        if (jumboProduct != null) {
          jumboProducts.add(jumboProduct);
        }
      });
    } catch (e) {
      print("Error getting jumbo products");
      print(e);
    }
    // notifyListeners();
    return response.statusCode;
  }

  Future<int> getAllHoogvlietProducts() async {
    var decodedProductsList = [];
    var response = await NetworkServices.getAllHoogvlietProducts();
    try {
      decodedProductsList = jsonDecode(response.body);
      hoogvlietProducts = convertToHoogvlietProductListFromJson(decodedProductsList);
    } catch (e) {
      print("Error getting hoogvliet products");
      print(e);
    }
    // notifyListeners();
    return response.statusCode;
  }

  Future<int> getAllCategories() async {
    var response = await NetworkServices.getAllCategories();

    categories = productCategoryFromJson(response.body);

    print("categories length: ${categories.length}");
    notifyListeners();
    return response.statusCode;
  }

  List<Product> getProductsByCategory(String category) {
    List<Product> products = [];
    products.addAll(albertProducts.where((product) => product.category.trim() == category.trim()));
    products.addAll(jumboProducts.where((product) => product.category.trim() == category.trim()));
    products.addAll(hoogvlietProducts.where((product) => product.category.trim() == category.trim()));
    return products;
  }

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

  List<Product> getProductsBySubCategory(String subCategory) {
    List<Product> products = [];
      products.addAll(albertProducts.where((product) => product.subCategory!.trim() == subCategory.trim()));
      products.addAll(jumboProducts.where((product) => product.subCategory!.trim() == subCategory.trim()));
      products.addAll(hoogvlietProducts.where((product) => product.subCategory!.trim() == subCategory.trim()));
    return products;
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


  Future<int> getProducts(int startingIndex) async {
    var decodedProductsList = [];
    if (startingIndex == 0) albertProducts.clear();
    var response = await NetworkServices.getProducts(startingIndex);
    decodedProductsList = jsonDecode(response.body);

    albertProducts.addAll(convertToProductListFromJson(decodedProductsList));
    // albertProducts.removeAt(0);

    print("Total number of products from Index $startingIndex: ${albertProducts.length}");
    notifyListeners();
    return response.statusCode;
  }

  Future<List<Product?>> searchProducts(String searchTerm) async {
    var response = await Future.wait([
      NetworkServices.searchAlbertProducts(searchTerm),
      NetworkServices.searchJumboProducts(searchTerm),
      NetworkServices.searchHoogvlietProducts(searchTerm),
    ]);
    var albertProducts = convertToProductListFromJson(jsonDecode(response[0].body));

    List decodedProductsList = jsonDecode(response[1].body);
    var jumboProducts = decodedProductsList.map((decodedProduct) {
      var jumboProduct = convertToJumboProductFromJson(decodedProduct);
      if (jumboProduct != null) {
        return jumboProduct;
      }
    }).toList();

    var hoogvlietProducts = convertToHoogvlietProductListFromJson(jsonDecode(response[2].body));

    var searchResult = [...jumboProducts, ...albertProducts, ...hoogvlietProducts];
    TrackingUtils().trackSearchPerformed("filter", FirebaseAuth.instance.currentUser!.uid, searchTerm);
    return searchResult;
  }

  Future<int> getComparisonId(String storeName, String productLink) async {
    var comparisonId = -1;
    var comparisonResponse;
    print("StoreName: " + storeName);
    try {
      if (storeName == "Albert") {
        comparisonResponse = await NetworkServices.searchComparisonByAlbertLink(productLink);
      }
      if (storeName == "Jumbo") {
        comparisonResponse = await NetworkServices.searchComparisonByJumboLink(productLink);
      }
      if (storeName == "Hoogvliet") {
        comparisonResponse = await NetworkServices.searchComparisonByHoogvlietLink(productLink);
      }
      var comparisons = await convertToComparisonProductListFromJson(jsonDecode(comparisonResponse.body));
      comparisonProducts.add(comparisons.first);
      comparisonId = comparisons.first.id;
    } catch (e) {
      print("Error in comparison search: couldn't find comparison for the selected product");
      print(e);
    }
    return comparisonId;
  }

  void goToProductPage(String storeName, BuildContext context, int productId) {
    late Product product;
    switch (storeName) {
      case 'Hoogvliet':
        product = hoogvlietProducts.firstWhere((product) => product.id == productId);
        break;
      case 'Jumbo':
        product = jumboProducts.firstWhere((product) => product.id == productId);
        break;
      case 'Albert':
        product = albertProducts.firstWhere((product) => product.id == productId);
        break;
    }
    AppNavigator.push(
        context: context,
        screen: ProductDetailScreen(
          productId: product.id,
          productBrand: product.brand,
          oldPrice: product.oldPrice,
          storeName: product.storeName,
          productName: product.name,
          imageURL: product.imageURL,
          description: product.description,
          size1: product.size,
          size2: product.size2 ?? "",
          price1: double.tryParse(product.price ?? "") ?? 0.0,
          price2: double.tryParse(product.price2 ?? "") ?? 0.0,
        ));
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
    await Share.share(response.result);
    TrackingUtils().trackShare(FirebaseAuth.instance.currentUser!.uid);
  }

  String getImage(String storeName) {
    if (storeName == 'AH') return albert;
    if (storeName == 'Albert') return albert;
    if (storeName == 'Jumbo') return jumbo;
    if (storeName == 'Hoogvliet') return hoogLogo;
    return albert;
  }
}
