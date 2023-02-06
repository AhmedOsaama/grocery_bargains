class Item{
  String id;
  String categoryId;
  String name;
  String imageUrl;
  // String quantity;
  String createdAt;
  String createdBy;
  String description;

  Item({required this.name,required this.description,required this.id, required this.imageUrl,required this.categoryId,required this.createdAt,required this.createdBy});
}