class BestValueItem {
  int itemId;
  String itemName;
  String itemImage;
  String price1;
  String price2;
  String oldPrice;
  String description;
  String bestValueSize;
  String size1;
  String size2;
  String subCategory;
  String store;

  BestValueItem(
      {
       required this.price1,
        required this.price2,
        required this.size2,
      required this.size1,
      required this.bestValueSize,
      required this.store,
      required this.oldPrice,
      required this.description,
      required this.subCategory,
      required this.itemImage,
      required this.itemName,
      required this.itemId,});
}
