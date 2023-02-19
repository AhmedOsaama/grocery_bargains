import 'package:swaav/models/list_item.dart';

class StoreList{
  String docId;
  String name;
  List<ListItem> items;
  List people;
  String storeName;
  String storeImageUrl;

  StoreList({required this.docId,required this.items,required this.storeName,required this.name,required this.people,required this.storeImageUrl});
}
