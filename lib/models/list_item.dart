class ListItem {
  String name;
  String size;
  String imageURL;
  int quantity;
  String price;
  String? oldPrice;
  String storeName;
  bool isChecked;
  String text;
  ListItem(
      {this.oldPrice,
      this.storeName = "Albert Heijn",
      required this.name,
      required this.price,
      required this.text,
      required this.isChecked,
      required this.quantity,
      required this.imageURL,
      required this.size});
}
