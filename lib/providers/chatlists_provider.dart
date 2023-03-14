import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bargainb/models/list_item.dart';

import '../view/widgets/choose_list_dialog.dart';

class ChatlistsProvider with ChangeNotifier{
  List chatlists = [];
  late Future<QuerySnapshot> chatlistsFuture;

  Future<void> getAllChatlists() async {
  var snapshot = await getAllChatlistsFuture();
  chatlists = snapshot.docs;
  notifyListeners();
  }

  Future<QuerySnapshot> getAllChatlistsFuture() async {
    chatlistsFuture = FirebaseFirestore.instance
      .collection('/lists')
      .where("userIds", arrayContains: FirebaseAuth.instance.currentUser?.uid)
      .get();
    return chatlistsFuture;
  }

  Future<void> showChooseListDialog({required BuildContext context, required bool isSharing, required ListItem listItem}) async {
    var allLists = [];                              //TODO: use the provider's chatlist instead of allLists
    var allListsSnapshot = await chatlistsFuture;
      for (var list in allListsSnapshot.docs) {
        allLists.add({
          "list_name": list['list_name'],
          'list_id': list.id,
        });
      }
    showDialog(
        context: context,
        builder: (ctx) => ChooseListDialog(
          allLists: allLists,
          isSharing: isSharing,
          item: listItem
        ));
  }

  Future<void> addItemToList(ListItem item, String docId) async {
    final userData = await FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    await FirebaseFirestore.instance.collection('/lists/$docId/items').add(
        {
          "item_name": item.name,
          "item_size" : item.size,
          "item_price" : item.price,
          "item_image" : item.imageURL,
          "item_isChecked" : false,
          "text": "",
          "owner": userData['username'],
          "time": Timestamp.now(),
        });
  }



  //chat methods
  Future<void> sendMessage(String message, String listId) async {
    if (message.isNotEmpty) {
      final userData = await FirebaseFirestore.instance
          .collection('/users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      await FirebaseFirestore.instance
          .collection('/lists/${listId}/messages')
          .add({
        'item_name': "",
        'item_image': "",
        'item_description': "",
        'store_name': "",
        'isAddedToList': false,
        'item_price': 0.0,
        'item_oldPrice': "",
        'message': message,
        'createdAt': Timestamp.now(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'username': userData['username'],
        'userImageURL': userData['imageURL'],
      });
      FirebaseFirestore.instance
          .collection('/lists')
          .doc(listId)
          .update({
        "last_message": message,
        "last_message_date": Timestamp.now(),
        "last_message_userId": FirebaseAuth.instance.currentUser?.uid,
        "last_message_userName": userData['username'],
      });
    }
  }

  Future<void> shareItemAsMessage({itemName,itemImage,itemSize,itemPrice,itemOldPrice,storeName,listId}) async {
    final userData = await FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    await FirebaseFirestore.instance
        .collection('/lists/$listId/messages')
        .add({
      'item_name': itemName,
      'item_image': itemImage,
      'item_description': itemSize,
      'store_name': storeName,
      'isAddedToList': false,
      'item_price': itemPrice,
      'item_oldPrice': itemOldPrice,
      'message': "",
      'createdAt': Timestamp.now(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'username': userData['username'],
      'userImageURL': userData['imageURL'],
    });
    FirebaseFirestore.instance
        .collection('/lists')
        .doc(listId)
        .update({
      "last_message": "Shared $itemName",
      "last_message_date": Timestamp.now(),
      "last_message_userId": FirebaseAuth.instance.currentUser?.uid,
      "last_message_userName": userData['username'],
    });
  }




}