// import 'dart:convert';
// Product productFromJson(String str) => Product.fromJson(json.decode(str));
// String productToJson(Product data) => json.encode(data.toJson());
// class Product {
//   Product({
//       num? id,
//       String? name,
//       String? gtin,
//       String? link,
//       String? category,
//       String? subCategory,
//       String? price,
//       String? unit,
//       dynamic pricePerUnit,
//       dynamic oldPrice,
//       dynamic offer,
//       String? brand,
//       String? image,
//       dynamic description,
//       String? englishName,
//       num? storeId,
//       String? similarId,
//       String? similarStId,
//       num? availableNow,
//       String? dateAdded,}){
//     _id = id;
//     _name = name;
//     _gtin = gtin;
//     _link = link;
//     _category = category;
//     _subCategory = subCategory;
//     _price = price;
//     _unit = unit;
//     _pricePerUnit = pricePerUnit;
//     _oldPrice = oldPrice;
//     _offer = offer;
//     _brand = brand;
//     _image = image;
//     _description = description;
//     _englishName = englishName;
//     _storeId = storeId;
//     _similarId = similarId;
//     _similarStId = similarStId;
//     _availableNow = availableNow;
//     _dateAdded = dateAdded;
// }
//
//   Product.fromJson(dynamic json) {
//     _id = json['id'];
//     _name = json['name'];
//     _gtin = json['gtin'];
//     _link = json['link'];
//     _category = json['category'];
//     _subCategory = json['sub_category'];
//     _price = json['price'];
//     _unit = json['unit'];
//     _pricePerUnit = json['price_per_unit'];
//     _oldPrice = json['old_price'];
//     _offer = json['offer'];
//     _brand = json['brand'];
//     _image = json['image'];
//     _description = json['description'];
//     _englishName = json['english_name'];
//     _storeId = json['store_id'];
//     _similarId = json['similar_id'];
//     _similarStId = json['similar_st_id'];
//     _availableNow = json['available_now'];
//     _dateAdded = json['date_added'];
//   }
//   num? _id;
//   String? _name;
//   String? _gtin;
//   String? _link;
//   String? _category;
//   String? _subCategory;
//   String? _price;
//   String? _unit;
//   dynamic _pricePerUnit;
//   dynamic _oldPrice;
//   dynamic _offer;
//   String? _brand;
//   String? _image;
//   dynamic _description;
//   String? _englishName;
//   num? _storeId;
//   String? _similarId;
//   String? _similarStId;
//   num? _availableNow;
//   String? _dateAdded;
// Product copyWith({  num? id,
//   String? name,
//   String? gtin,
//   String? link,
//   String? category,
//   String? subCategory,
//   String? price,
//   String? unit,
//   dynamic pricePerUnit,
//   dynamic oldPrice,
//   dynamic offer,
//   String? brand,
//   String? image,
//   dynamic description,
//   String? englishName,
//   num? storeId,
//   String? similarId,
//   String? similarStId,
//   num? availableNow,
//   String? dateAdded,
// }) => Product(  id: id ?? _id,
//   name: name ?? _name,
//   gtin: gtin ?? _gtin,
//   link: link ?? _link,
//   category: category ?? _category,
//   subCategory: subCategory ?? _subCategory,
//   price: price ?? _price,
//   unit: unit ?? _unit,
//   pricePerUnit: pricePerUnit ?? _pricePerUnit,
//   oldPrice: oldPrice ?? _oldPrice,
//   offer: offer ?? _offer,
//   brand: brand ?? _brand,
//   image: image ?? _image,
//   description: description ?? _description,
//   englishName: englishName ?? _englishName,
//   storeId: storeId ?? _storeId,
//   similarId: similarId ?? _similarId,
//   similarStId: similarStId ?? _similarStId,
//   availableNow: availableNow ?? _availableNow,
//   dateAdded: dateAdded ?? _dateAdded,
// );
//   num? get id => _id;
//   String? get name => _name;
//   String? get gtin => _gtin;
//   String? get link => _link;
//   String? get category => _category;
//   String? get subCategory => _subCategory;
//   String? get price => _price;
//   String? get unit => _unit;
//   dynamic get pricePerUnit => _pricePerUnit;
//   dynamic get oldPrice => _oldPrice;
//   dynamic get offer => _offer;
//   String? get brand => _brand;
//   String? get image => _image;
//   dynamic get description => _description;
//   String? get englishName => _englishName;
//   num? get storeId => _storeId;
//   String? get similarId => _similarId;
//   String? get similarStId => _similarStId;
//   num? get availableNow => _availableNow;
//   String? get dateAdded => _dateAdded;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['name'] = _name;
//     map['gtin'] = _gtin;
//     map['link'] = _link;
//     map['category'] = _category;
//     map['sub_category'] = _subCategory;
//     map['price'] = _price;
//     map['unit'] = _unit;
//     map['price_per_unit'] = _pricePerUnit;
//     map['old_price'] = _oldPrice;
//     map['offer'] = _offer;
//     map['brand'] = _brand;
//     map['image'] = _image;
//     map['description'] = _description;
//     map['english_name'] = _englishName;
//     map['store_id'] = _storeId;
//     map['similar_id'] = _similarId;
//     map['similar_st_id'] = _similarStId;
//     map['available_now'] = _availableNow;
//     map['date_added'] = _dateAdded;
//     return map;
//   }
//
// }