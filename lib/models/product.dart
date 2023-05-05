class Product {
  String name;
  String imageURL;
  String description;
  String? price;
  String? price2;
  String? oldPrice;
  String size;
  String? size2;
  String category;
  String? subCategory;
  String? offer;
  String url;
  int id;
  String storeName;

  Product(
      {
        required this.storeName,
        required this.id, this.price,
      required this.description,
      required this.imageURL,
      required this.name,
      this.oldPrice,
        this.size2,this.price2,
      required this.size,
      required this.category,
      required this.url,
      this.offer,
      this.subCategory});
}
