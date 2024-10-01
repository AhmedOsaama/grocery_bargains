import 'dart:convert';

List<ProductCategory> productCategoryFromJson(String str) =>
    List<ProductCategory>.from(
        json.decode(str).map((x) => ProductCategory.fromJson(x)));

String productCategoryToJson(List<ProductCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductCategory {
  ProductCategory({
    required this.image,
    required this.category,
  });

  String image;
  String category;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        category: json["category"],
        image: json["image"],
        // image: "assets/images/categories/" + json["category"] + ".png",
      );

  Map<String, dynamic> toJson() => {
        "category": category,
      };
}
