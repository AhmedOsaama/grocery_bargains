class ListItem {
  int id;
  String name;
  String size;
  String brand;
  String imageURL;
  int quantity;
  double price;
  double? oldPrice;
  String storeName;
  bool isChecked;
  String text;
  String? category;
  ListItem(
      {this.oldPrice,
      required this.storeName,
      required this.brand,
      required this.id,
      required this.name,
      required this.price,
      required this.text,
      required this.isChecked,
      required this.quantity,
      required this.imageURL,
        this.category,
      required this.size});
}
