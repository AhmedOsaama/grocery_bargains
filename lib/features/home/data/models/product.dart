import 'dart:developer';

class Product {
  late int id;
  late String name;
  late String gtin;
  late String link;
  late String category;
  late String subCategory;
  late double price;
  late String unit;
  String? pricePerUnit;
  double? oldPrice;
  String? offer;
  late String brand;
  late String image;
  late String description;
  late String englishName;
  late int storeId;
  late String storeName;
  late int availableNow;
  String? dateAdded;

  Product({
    required this.id,
    required this.name,
    required this.gtin,
    required this.link,
    required this.category,
    required this.subCategory,
    required this.price,
    required this.unit,
    this.pricePerUnit,
    this.oldPrice,
    this.offer,
    required this.brand,
    required this.image,
    required this.description,
    required this.englishName,
    required this.storeId,
    required this.availableNow,
    this.dateAdded,
  });


  Product.fromJson(Map<String, dynamic> json){
    if(json['price'].runtimeType == String){
      json['price'] = double.parse(json['price']);
    }
    try {
      id = json['id'] ?? -1;
      name = json['product_name'] ?? 'N/A';
      gtin = json['gtin'] ?? 'N/A';
      link = json['link'] ?? 'N/A';
      category = json['category_name'] ?? 'N/A';
      subCategory = json['subcategory_name'] ?? 'N/A';
      price = json['price'] ?? 0.0;
      unit = json['unit'] ?? 'N/A';
      pricePerUnit = json['price_per_unit'] ?? 'N/A';
      oldPrice = json['old_price'] ?? 0.0;
      offer = json['offer'] ?? 'N/A';
      brand = json['brand'] ?? 'N/A';
      image = json['image_path'] ?? 'N/A';
      description = json['description'] ?? 'N/A';
      englishName = json['english_name'] ?? 'N/A';
      storeId = json['store_id'] ?? -1;
      storeName = json['store_name'] ?? 'N/A';
      availableNow = json['available_now'] ?? -1;
      dateAdded = json['date_added'] ?? 'N/A';
    }catch(e){
      log("ERROR IN Product.fromJson: $e");
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['product_name'] = name;
    _data['gtin'] = gtin;
    _data['link'] = link;
    _data['category_name'] = category;
    _data['subcategory_name'] = subCategory;
    _data['price'] = price;
    _data['unit'] = unit;
    _data['price_per_unit'] = pricePerUnit;
    _data['old_price'] = oldPrice;
    _data['offer'] = offer;
    _data['brand'] = brand;
    _data['image_path'] = image;
    _data['description'] = description;
    _data['english_name'] = englishName;
    _data['store_id'] = storeId;
    _data['available_now'] = availableNow;
    // _data['date_added'] = dateAdded;
    return _data;
  }
}