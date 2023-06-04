// To parse this JSON data, do
//
//     final productCategory = productCategoryFromJson(jsonString);

import 'dart:convert';

List<ProductCategory> productCategoryFromJson(String str) =>
    List<ProductCategory>.from(
        json.decode(str).map((x) => ProductCategory.fromJson(x)));

String productCategoryToJson(List<ProductCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductCategory {
  ProductCategory({
    required this.id,
    required this.image,
    required this.category,
    required this.englishCategory,
    required this.subcategories,
  });

  int id;
  String category;
  String englishCategory;
  String image;
  String subcategories;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        id: json["id"],
        category: json["category"],
        englishCategory: json["category_english"],
        image: "assets/images/categories/" + json["category"] + ".png",
        subcategories: json["subcategories"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "subcategories": subcategories,
      };
}
