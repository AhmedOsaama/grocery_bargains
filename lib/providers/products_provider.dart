import 'dart:convert';
import 'dart:developer';

import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/models/product_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:bargainb/services/network_services.dart';

import '../models/bestValue_item.dart';
import '../models/product.dart';
import '../utils/assets_manager.dart';

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
        var storeName = decodedProduct['product_brand'];
        var description = decodedProduct['product_description'];
        var category = decodedProduct['product_category'] ?? "";
        var subCategory = decodedProduct['type_of_product'];
        var price1 = decodedProduct['price_1'] ?? "";
        var price2 =  decodedProduct['price_2'] ?? "";
        var oldPrice = decodedProduct['befor_offer'] ?? "";
        var size1 = decodedProduct['unit_size_1'] ?? "";
        var size2 = decodedProduct['unit_size_2'] ?? "";
        var offer = decodedProduct['new_offer'] ?? "";
        var productURL = decodedProduct['product_link'];

       albertProduct = Product(
            storeName: storeName,
            id: id,
            offer: offer,
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
      print("Error in converting Albert json to product");
      print(e);
    }
    return albertProduct;
  }
  Product? convertToJumboProductFromJson(decodedProduct) {
    Product? jumboProduct;
    try {
        var id = decodedProduct['id'];
        var productName = decodedProduct['name'];
        var imageURL = decodedProduct['image_url'];
        var storeName = "Jumbo";
        var description = decodedProduct['product_description'] ?? "";
        var category = decodedProduct['product_category'] ?? "";
        var subCategory = "";
        var price1 = decodedProduct['price'];
        var price2 = "";
        var oldPrice = decodedProduct['old_price'] ?? "";
        var size1 = decodedProduct['unit_size'];
        var size2 = "";
        var offer = decodedProduct['offer'] ?? "";
        var productURL = decodedProduct['product_link'];

        jumboProduct = Product(
            storeName: storeName,
            id: id,
            offer: offer,
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
        var productName = decodedProduct['name'] ?? "";
        var imageURL = decodedProduct['image_link'] ?? "";
        var storeName = "Hoogvliet";
        var description = decodedProduct['description'] ?? "";
        var category = decodedProduct['category'] ?? "";
        var subCategory = decodedProduct['type_of_product'] ?? "";
        var price1 = decodedProduct['price'] ?? "";
        var price2 = "";
        var oldPrice = decodedProduct['was_price'] ?? "";
        var size1 = decodedProduct['unit'] ?? "";
        var size2 = "";
        var offer = decodedProduct['offer'] ?? "";
        var productURL = decodedProduct['product_link'] ?? "";

        hoogvlietProduct = Product(
            storeName: storeName,
            id: id,
            offer: offer,
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
        var storeName = product.containsKey('product_brand')
            ? product['product_brand']
            : "Jumbo";
        var description = product['product_description'];
        var category = product['product_category'] ?? "";
        var subCategory = product.containsKey('type_of_product')
            ? product['type_of_product']
            : null;
        var price1 = product.containsKey('price_1')
            ? product['price_1'] ?? product['price_2']
            : product['price'];
        var price2 = product.containsKey('price_2') ? product['price_2'] : null;
        var oldPrice = product.containsKey('befor_offer')
            ? product['befor_offer']
            : product['old_price'];
        var size1 = product.containsKey('unit_size_1')
            ? product['unit_size_1'] ?? ""
            : product['unit_size'] ?? "";
        var size2 =
            product.containsKey('unit_size_2') ? product['unit_size_2'] : null;
        var offer = product.containsKey('new_offer')
            ? product['new_offer']
            : product['offer'];
        var productURL = product['product_link'];
        productList.add(Product(
            storeName: storeName,
            id: id,
            offer: offer,
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
            url: productURL));
      }
    } catch (e) {
      print("SDAOIJDIUWAHIUEHUIWQHEUIWHQIUEHOIUQWHE");
      print(e);
    }
    print("PRODUCTS LENGTH: " + productList.length.toString());
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
        productList.add(Product(
            storeName: storeName,
            id: id,
            offer: offer,
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
        //Jumbo
        var jumboName = product['jumbo_product_name'];
        var jumboLink = product['jumbo_product_link'];
        await addJumboProduct(jumboLink);
        var jumboImageURL = product['jumbo_image_url'];
        if (jumboImageURL == null) continue;
        var jumboPrice = product['jumbo_price'];
        if (jumboPrice == null) continue;
        var jumboSize = product['jumbo_unit'];
        //Albert
        var albertName = product['albert_product_name'];
        var albertLink = product['albert_product_link'];
        await addAlbertProduct(albertLink);
        var albertId = product['albert_product_id'];
        var albertImageURL = product['albert_image_url'];
        var albertPrice = product['albert_price'];
        var albertSize = product['albert_unit_size'];
        //Hoogvliet
        var hoogvlietName = product['hoogvliet_product_name'];
        var hoogvlietLink = product['hoogvliet_product_link'];
        await addHoogvlietProduct(hoogvlietLink);
        var hoogvlietOldPrice = product['hoogvliet_was_price'] ?? "";
        var hoogvlietImageURL = product['hoogvliet_image_link'];
        var hoogvlietPrice = product['hoogvliet_price'];
        var hoogvlietUnit = product['hoogvliet_unit'];

        comparisonList.add(
        ComparisonProduct(
          id: id,
            albertId: albertId,
            albertImageURL: albertImageURL,
            albertLink: albertLink,
            albertName: albertName,
            albertPrice: albertPrice,
            albertSize: albertSize,
          jumboSize: jumboSize,
            jumboImageURL: jumboImageURL,
            jumboLink: jumboLink,
            jumboName: jumboName,
            jumboPrice: jumboPrice,
            hoogvlietImageURL: hoogvlietImageURL,
            hoogvlietLink: hoogvlietLink,
            hoogvlietOldPrice: hoogvlietOldPrice,
            hoogvlietName: hoogvlietName,
            hoogvlietPrice: hoogvlietPrice,
            hoogvlietSize: hoogvlietUnit
        ));
        log('Comparison Finished',time: Timestamp.now().toDate());
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
    var response = await NetworkServices.searchAlbertProductByLink(albertLink);
    //convert json Albert to Product
    var albertProduct = convertToAlbertProductFromJson(jsonDecode(response.body)[0]);               //might fail with range error if it couldn't find the albert product in the above function. e.g. array is empty
    //add Albert product to the list of Albert products
    if(albertProduct != null){
      albertProducts.add(albertProduct);
    }else{
      throw "Invalid Albert product: product is null";
    }
  }

  Future<void> addJumboProduct(jumboLink) async {
     //get jumbo product using link
    var response = await NetworkServices.searchJumboProductByLink(jumboLink);
    //convert json jumbo to Product
    var jumboProduct = convertToJumboProductFromJson(jsonDecode(response.body)[0]);
    //add jumbo product to the list of jumbo products
    if(jumboProduct != null){
      jumboProducts.add(jumboProduct);
    }else{
      throw "Invalid Jumbo product: product is null";
    }
  }

  Future<void> addHoogvlietProduct(hoogvlietLink) async {
     //get hoogvliet product using link
    var response = await NetworkServices.searchHoogvlietProductByLink(hoogvlietLink);
    //convert json hoogvliet to Product
    var hoogvlietProduct = convertToHoogvlietProductFromJson(jsonDecode(response.body)[0]);
    //add hoogvliet product to the list of hoogvliet products
    if(hoogvlietProduct != null){
      hoogvlietProducts.add(hoogvlietProduct);
    }else{
      throw "Invalid Hoogvliet product: product is null";
    }
  }

  Future<int> getAllPriceComparisons() async {
    var decodedProductsList = [];
    var response = await NetworkServices.getAllPriceComparisons();
    decodedProductsList = jsonDecode(response.body);
    comparisonProducts = await convertToComparisonProductListFromJson(decodedProductsList);
    print("Total number of comparison products: ${comparisonProducts.length}");
    notifyListeners();
    return response.statusCode;
  }

  Future<int> getAllAlbertProducts() async {
    var decodedProductsList = [];
    var response = await NetworkServices.getAllAlbertProducts();
    try {
      decodedProductsList = jsonDecode(response.body);
      albertProducts = convertToProductListFromJson(decodedProductsList);

      if (albertProducts.isNotEmpty) {
        albertProducts.forEach((element) {
          if (element.oldPrice != null) {
            if (double.parse(element.oldPrice!) > double.parse(element.price)) {
              deals.add(element);
            }
          }
        });
      }
    } catch (e) {
      // print(e);
    }
    print("Total number of Albert products: ${albertProducts.length}");
    notifyListeners();
    return response.statusCode;
  }

  Future<int> getAllJumboProducts() async {
    var decodedProductsList = [];
    var response = await NetworkServices.getAllJumboProducts();
    decodedProductsList = jsonDecode(response.body);
    jumboProducts = convertToProductListFromJson(decodedProductsList);

    if (jumboProducts.isNotEmpty) {
      jumboProducts.forEach((element) {
        try {
          if (element.oldPrice != null) {
            if (double.parse(element.oldPrice!) > double.parse(element.price)) {
              deals.add(element);
            }
          }
        }catch(e){
          // print(e);
        }
      });
    }
    print("jumbo products length: ${jumboProducts.length}");
    notifyListeners();
    return response.statusCode;
  }

  Future<int> getAllHoogvlietProducts() async {
    var decodedProductsList = [];
    var response = await NetworkServices.getAllHoogvlietProducts();
    decodedProductsList = jsonDecode(response.body);
    hoogvlietProducts = convertToHoogvlietProductListFromJson(decodedProductsList);

    if (hoogvlietProducts.isNotEmpty) {
      hoogvlietProducts.forEach((element) {
        try {
          if (element.oldPrice != null) {
            if (double.parse(element.oldPrice!) > double.parse(element.price)) {
              deals.add(element);
            }
          }
        }catch(e){
          // print("Error getting hoogvliet deals");
          // print(e);
        }
      });
    }
    print("Hoogvliet products length: ${hoogvlietProducts.length}");
    notifyListeners();
    return response.statusCode;
  }

  Future<int> getAllCategories() async {
    var response = await NetworkServices.getAllAlbertCategories();

    categories = productCategoryFromJson(response.body);

    print("categories length: ${categories.length}");
    notifyListeners();
    return response.statusCode;
  }

  List<Product> getProductsByCategory(String category) {
    List<Product> products = [];
    albertProducts.forEach((element) {
      if (element.category != "") {
        if (element.category.toLowerCase() == category.toLowerCase()) {
          products.add(element);
        }
      }
    });
    jumboProducts.forEach((element) {
      if (element.category != "") {
        if (element.category.toLowerCase() == category.toLowerCase()) {
          products.add(element);
        }
      }
    });
    hoogvlietProducts.forEach((element) {
      if (element.category != "") {
        if (element.category.toLowerCase() == category.toLowerCase()) {
          products.add(element);
        }
      }
    });
    return products;
  }

  List<Product> getProductsBySubCategory(String category) {
    List<Product> products = [];
    albertProducts.forEach((element) {
      if (element.subCategory != null && element.subCategory != "") {
        if (element.subCategory!.toLowerCase() == category.toLowerCase()) {
          products.add(element);
        }
      }
    });
    jumboProducts.forEach((element) {
      if (element.subCategory != null && element.subCategory != "") {
        if (element.subCategory!.toLowerCase() == category.toLowerCase()) {
          products.add(element);
        }
      }
    });
    hoogvlietProducts.forEach((element) {
      if (element.subCategory != null && element.subCategory != "") {
        if (element.subCategory!.toLowerCase() == category.toLowerCase()) {
          products.add(element);
        }
      }
    });
    return products;
  }

  int getMeasurementConversion(String measurement) {
    if (measurement == "g" || measurement == "gram" || measurement == "ml") {
      return 1;
    }
    if (measurement == "KG" ||
        measurement == "kg" ||
        measurement == "LT" ||
        measurement == "l") {
      return 1000;
    }
    if (measurement == "100g") {
      return 100; //case ca. 100g where this will be considered as 1 * 100 = 100 g
    }
    return 1;
  }

  Future<List<BestValueItem>> populateBestValueBargains() async {
    // await getAllAlbertProducts(); //stuk: piece, tros: bunch
    bestValueBargains.clear();
    try {
      for (var product in albertProducts) {
        var id = product.id;
        var productName = product.name;
        var imageURL = product.imageURL;
        var subCategory = product.subCategory ?? "";
        var storeName = "Albert";
        var description = product.description;
        var price1 = product.price;
        var price2 = product.price2 ?? "";
        var oldPrice = product.oldPrice ?? "";
        String size1 = product.size;
        String size2 = product.size2 ?? "";

        if (size2.contains("stuk") || size2.contains("stuks")) continue;

        if (price1.isNotEmpty && price2.isNotEmpty) {
          //if both prices are not empty strings then sizes are not either
          var numSize1 = 0;
          var numSize2 = 0;
          var numPrice1 = 0.0;
          var numPrice2 = 0.0;
          var ratio1;
          var ratio2;
          try {
            numSize1 = getMeasurementConversion(size1);
            numSize2 = int.tryParse(size2.split(' ')[0]) ?? 1; //case: per stuk

            if (size2.split(' ').length == 2)
              numSize2 = numSize2 *
                  getMeasurementConversion(
                      size2.split(' ')[1]); //case: 150 g or 1 kg or 12 stuks
            if (size2.split(' ').length == 3)
              numSize2 = numSize2 *
                  (int.tryParse(size2.split(' ')[1]) ?? 1) *
                  getMeasurementConversion(size2.split(' ')[
                      2]); //case: ca. 120 g or per 2 stuks        note: ca. means approx.
            if (size2.split(' ').length == 4)
              numSize2 = numSize2 *
                  (int.tryParse(size2.split(' ')[2]) ?? 1) *
                  getMeasurementConversion(
                      size2.split(' ')[3]); //case: 2 x 160 g or 2 x 90 gram

            numPrice1 = double.parse(price1);
            numPrice2 = double.parse(price2);
            ratio1 = numSize1 / numPrice1;
            ratio2 = numSize2 / numPrice2;
          } catch (e) {
            print("ERROR IN BEST VALUE BARGAINS CALCULATION");
            print(e);
          }

          if (ratio1 > ratio2) {
            bestValueBargains.add(BestValueItem(
                itemImage: imageURL,
                subCategory: subCategory,
                itemName: productName,
                oldPrice: oldPrice,
                description: description,
                size1: size1,
                size2: size2,
                bestValueSize: size1,
                itemId: id,
                price1: price1,
                price2: price2,
                store: storeName));
          } else if (ratio2 > ratio1) {
            bestValueBargains.add(BestValueItem(
                itemImage: imageURL,
                subCategory: subCategory,
                itemName: productName,
                oldPrice: oldPrice,
                description: description,
                bestValueSize: size2,
                size2: size2,
                size1: size1,
                itemId: id,
                price1: price1,
                price2: price2,
                store: storeName));
          }
        }
      }
    } catch (e) {
      print(e);
    }
    print( "Best value bargains length: " + bestValueBargains.length.toString());
    notifyListeners();
    return bestValueBargains;
  }

  Future<int> getProducts(int startingIndex) async {
    var decodedProductsList = [];
    if (startingIndex == 0) albertProducts.clear();
    var response = await NetworkServices.getProducts(startingIndex);
    decodedProductsList = jsonDecode(response.body);

    albertProducts.addAll(convertToProductListFromJson(decodedProductsList));
    // albertProducts.removeAt(0);

    print(
        "Total number of products from Index $startingIndex: ${albertProducts.length}");
    notifyListeners();
    return response.statusCode;
  }

  Future<int> getLimitedPriceComparisons(int startingIndex) async {
    var decodedProductsList = [];
    if (startingIndex == 0) comparisonProducts.clear();
    var response = await NetworkServices.getLimitedPriceComparisons(startingIndex);
    decodedProductsList = jsonDecode(response.body);

    comparisonProducts.addAll(await convertToComparisonProductListFromJson(decodedProductsList));

    print("Total number of comparisons from Index $startingIndex: ${comparisonProducts.length}");
    print("Albert Products Length: $startingIndex: ${albertProducts.length}");
    print("Jumbo Products Length: $startingIndex: ${jumboProducts.length}");
    print("Hoogvliet Products Length: $startingIndex: ${hoogvlietProducts.length}");
    notifyListeners();
    return response.statusCode;
  }

  Future<List<Product>> searchProducts(String searchTerm) async {
    var albertResponse = jsonDecode(
        (await NetworkServices.searchAlbertProducts(searchTerm)).body);
    var jumboResponse = jsonDecode(
        (await NetworkServices.searchJumboProducts(searchTerm)).body);
    var hoogvlietResponse = jsonDecode(
        (await NetworkServices.searchHoogvlietProducts(searchTerm)).body);
    var albertProducts = convertToProductListFromJson(albertResponse);
    var jumboProducts = convertToProductListFromJson(jumboResponse);
    var hoogvlietProducts = convertToHoogvlietProductListFromJson(hoogvlietResponse);
    var searchResult = [...jumboProducts, ...albertProducts,...hoogvlietProducts]..shuffle();
    return searchResult;
  }

  String getImage(String storeName) {
    if (storeName == 'AH') return albert;
    if (storeName == 'Albert') return albert;
    if (storeName == 'Jumbo') return jumbo;
    if (storeName == 'Hoogvliet') return hoogLogo;
    return albert;
  }
}
