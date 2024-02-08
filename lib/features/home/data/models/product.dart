class Product {
  late int id;
  late String name;
  late String gtin;
  late String link;
  late String category;
  late String subCategory;
  late String price;
  late String unit;
  String? pricePerUnit;
  String? oldPrice;
  String? offer;
  late String brand;
  late String image;
  late String description;
  late String englishName;
  late int storeId;
  String? similarId;
  String? similarStId;
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
    this.similarId,
    this.similarStId,
    required this.availableNow,
    this.dateAdded,
  });


  Product.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? -1;
    name = json['name'] ?? 'N/A';
    gtin = json['gtin'] ?? 'N/A';
    link = json['link'] ?? 'N/A';
    category = json['category'] ?? 'N/A';
    subCategory = json['sub_category'] ?? 'N/A';
    price = json['price'] ?? 'N/A';
    unit = json['unit'] ?? 'N/A';
    pricePerUnit = json['price_per_unit'] ?? 'N/A';
    oldPrice = json['old_price'] ?? 'N/A';
    offer = json['offer'] ?? 'N/A';
    brand = json['brand'] ?? 'N/A';
    image = json['image'] ?? 'N/A';
    description = json['description'] ?? 'N/A';
    englishName = json['english_name'] ?? 'N/A';
    storeId = json['store_id'] ?? -1;
    similarId = json['similar_id'] ?? 'N/A';
    similarStId = json['similar_st_id'] ?? 'N/A';
    availableNow = json['available_now'] ?? -1;
    dateAdded = json['date_added'] ?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['gtin'] = gtin;
    _data['link'] = link;
    _data['category'] = category;
    _data['sub_category'] = subCategory;
    _data['price'] = price;
    _data['unit'] = unit;
    _data['price_per_unit'] = pricePerUnit;
    _data['old_price'] = oldPrice;
    _data['offer'] = offer;
    _data['brand'] = brand;
    _data['image'] = image;
    _data['description'] = description;
    _data['english_name'] = englishName;
    _data['store_id'] = storeId;
    _data['similar_id'] = similarId;
    _data['similar_st_id'] = similarStId;
    _data['available_now'] = availableNow;
    _data['date_added'] = dateAdded;
    return _data;
  }
}