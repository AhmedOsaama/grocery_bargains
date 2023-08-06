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
    id = json['id'];
    name = json['name'];
    gtin = json['gtin'];
    link = json['link'];
    category = json['category'];
    subCategory = json['sub_category'];
    price = json['price'];
    unit = json['unit'];
    pricePerUnit = json['price_per_unit'];
    oldPrice = json['old_price'];
    offer = json['offer'];
    brand = json['brand'] ?? 'N/A';
    image = json['image'];
    description = json['description'];
    englishName = json['english_name'];
    storeId = json['store_id'];
    similarId = json['similar_id'];
    similarStId = json['similar_st_id'];
    availableNow = json['available_now'];
    dateAdded = json['date_added'];
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