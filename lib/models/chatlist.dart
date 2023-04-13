import 'package:cloud_firestore/cloud_firestore.dart';

class ChatList {
  String id;
  String lastMessage;
  Timestamp lastMessageDate;
  String lastMessageUserId;
  String lastMessageUserName;
  String name;
  int itemLength;
  String storeImageUrl;
  String storeName;
  double totalPrice;
  List userIds;

  ChatList(
      {required this.id,
        required this.name,
      required this.storeName,
      required this.userIds,
      required this.totalPrice,
      required this.storeImageUrl,
      required this.itemLength,
      required this.lastMessage,
      required this.lastMessageDate,
      required this.lastMessageUserId,
      required this.lastMessageUserName});
}
