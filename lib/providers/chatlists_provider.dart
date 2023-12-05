import 'dart:developer';

import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bargainb/models/list_item.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../config/routes/app_navigator.dart';
import '../generated/locale_keys.g.dart';
import '../utils/assets_manager.dart';
import '../view/screens/chatlist_view_screen.dart';
import '../features/chatlists/presentation/views/chatlists_screen.dart';
import '../view/screens/main_screen.dart';
import '../view/screens/product_detail_screen.dart';
import '../view/widgets/choose_list_dialog.dart';
import '../view/widgets/signin_dialog.dart';

class ChatlistsProvider with ChangeNotifier {
  List<ChatList> chatlists = [];
  late Future<QuerySnapshot> chatlistsFuture;
  final stopwatch = Stopwatch();
  Future<QuerySnapshot> getAllChatlistsFuture() async {
    chatlistsFuture = FirebaseFirestore.instance
        .collection('/lists')
        .where("userIds", arrayContains: FirebaseAuth.instance.currentUser?.uid)
        .get();
    return chatlistsFuture;
  }

  Future<void> getAllChatlists() async {
    chatlists.clear();
    var snapshot = await getAllChatlistsFuture();
    try {
      snapshot.docs.forEach((chatlistDoc) {
        var lastMessage = chatlistDoc['last_message'];
        var lastMessageDate = chatlistDoc['last_message_date'];
        var lastMessageUserId = chatlistDoc['last_message_userId'];
        var lastMessageUserName = chatlistDoc['last_message_userName'];
        var chatlistName = chatlistDoc['list_name'];
        var itemLength = chatlistDoc['size'];
        var storeImageUrl = chatlistDoc['storeImageUrl'];
        var storeName = chatlistDoc['storeName'];
        var totalPrice = chatlistDoc['total_price'];
        var userIds = chatlistDoc['userIds'];
        chatlists.add(ChatList(
            id: chatlistDoc.id,
            name: chatlistName,
            storeName: storeName,
            userIds: userIds,
            totalPrice: totalPrice,
            storeImageUrl: storeImageUrl,
            itemLength: itemLength,
            lastMessage: lastMessage,
            lastMessageDate: lastMessageDate,
            lastMessageUserId: lastMessageUserId,
            lastMessageUserName: lastMessageUserName));
      });
    } catch (e) {
      print("Error occurred while fetching chatlists");
      log(e.toString());
    }
    notifyListeners();
  }

  Future<List<ChatList>> searchChatLists(String searchTerm) async {
    var searchResult =
        chatlists.where((element) => (element.name.toLowerCase().contains(searchTerm.toLowerCase()))).toList();

    return searchResult;
  }

  Future<List<ChatList>> getAllSharedChatlists(String id) async {
    List<ChatList> list = [];
    var snapshot = await getAllChatlistsFuture();

    try {
      snapshot.docs.forEach((chatlistDoc) {
        if (chatlistDoc['userIds'].toString().contains(id)) {
          var lastMessage = chatlistDoc['last_message'];
          var lastMessageDate = chatlistDoc['last_message_date'];
          var lastMessageUserId = chatlistDoc['last_message_userId'];
          var lastMessageUserName = chatlistDoc['last_message_userName'];
          var chatlistName = chatlistDoc['list_name'];
          var itemLength = chatlistDoc['size'];
          var storeImageUrl = chatlistDoc['storeImageUrl'];
          var storeName = chatlistDoc['storeName'];
          var totalPrice = chatlistDoc['total_price'];
          var userIds = chatlistDoc['userIds'];
          list.add(ChatList(
              id: chatlistDoc.id,
              name: chatlistName,
              storeName: storeName,
              userIds: userIds,
              totalPrice: totalPrice,
              storeImageUrl: storeImageUrl,
              itemLength: itemLength,
              lastMessage: lastMessage,
              lastMessageDate: lastMessageDate,
              lastMessageUserId: lastMessageUserId,
              lastMessageUserName: lastMessageUserName));
        }
      });
    } catch (e) {
      print("Error occurred while fetching chatlists");
      log(e.toString());
    }
    return list;
  }

  Future<List<FriendChatLists>> getAllFriends() async {
    List<QueryDocumentSnapshot> allLists = [];
    var allUserIds = [];
    var allListsSnapshot = await chatlistsFuture;
    allLists = allListsSnapshot.docs;
    var myId = FirebaseAuth.instance.currentUser?.uid;
    List<FriendChatLists> friendsList = [];
    //getting all the users I have lists in common with
    allLists.forEach((list) {
      var userIds = list['userIds'] as List;
      allUserIds.addAll([...userIds]);
    });

    //removing duplicates
    allUserIds = allUserIds.toSet().toList();
    //removing my self
    allUserIds.remove(myId);

    //for every user we get their name, image and lists in common
    for (var userId in allUserIds) {
      var userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      var userName = userSnapshot.data()!['username'];

      var userImage = userSnapshot.data()!['imageURL'];
      var phone = userSnapshot.data()!['phoneNumber'];
      var id = userSnapshot.id;
      var userEmail = userSnapshot.data()!['email'];

      //getting all the lists with a particular user
      var userLists = allLists.where((list) {
        var userIds = list['userIds'] as List;
        return userIds.contains(userId);
      }).toList();
      print(userLists.length);
      friendsList.add(FriendChatLists(
          imageURL: userImage, email: userEmail, name: userName, chatlists: userLists, id: id, phone: phone));
    }
    return friendsList;
  }

  Future<String> createChatList(List<String> userIds, {String? name}) async {
    userIds.add(FirebaseAuth.instance.currentUser!.uid);
    print(name);
    var docRef = await FirebaseFirestore.instance.collection('/lists').add({
      "last_message": "",
      "last_message_date": Timestamp.fromDate(DateTime.now().toUtc()),
      "last_message_userId": "",
      "last_message_userName": "",
      "list_name": name ?? "Name...",
      "size": 0,
      "storeImageUrl": storePlaceholder,
      "storeName": "None",
      "total_price": 0.0,
      "userIds": userIds,
    });
    chatlists.add(ChatList(
        id: docRef.id,
        name: name ?? "Name...",
        storeName: '',
        userIds: [FirebaseAuth.instance.currentUser?.uid ?? ""],
        totalPrice: 0.0,
        storeImageUrl: storePlaceholder,
        itemLength: 0,
        lastMessage: '',
        lastMessageDate: Timestamp.fromDate(DateTime.now().toUtc()),
        lastMessageUserId: '',
        lastMessageUserName: ''));
    notifyListeners();
    return docRef.id;
  }

  void deleteList(BuildContext context, String listId) {
    try {
      FirebaseFirestore.instance.collection('/lists').doc(listId).delete().then((value) {
        // updateList();
        chatlists.removeWhere((chatlist) => chatlist.id == listId);
        notifyListeners();
        return AppNavigator.pop(context: context);
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("couldntDeleteList".tr())));
    }
    TrackingUtils().trackSideMenuItemClicked(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(),
        "Chatlist Side Menu", "Remove", "Chatlist Screen");
  }

  Future<void> deleteItemFromChatlist(
      String listId, String itemDocId, String itemPrice, String itemOldPrice, String itemQuantity, String itemId) async {
    try {
      var chatlist = chatlists.firstWhere((chatlist) => chatlist.id == listId);
      var item = await FirebaseFirestore.instance.collection('/lists/${listId}/items').doc(itemDocId).get();
      if (item.data()!.containsKey("chat_reference")) {
        if (item.data()!["chat_reference"].toString().isNotEmpty) {
          await FirebaseFirestore.instance
              .collection("/lists/$listId/messages")
              .doc(item.data()!["chat_reference"].toString().split("/").last)
              .update({
            'isAddedToList': false,
          });
        }
      }
      await FirebaseFirestore.instance.collection('/lists/${listId}/items').doc(itemDocId).delete();
      //TODO: delete item from messages here using item_id field
      await FirebaseFirestore.instance.collection('lists').doc(listId).update({
        "size": FieldValue.increment(-1),
        "total_price": FieldValue.increment((double.tryParse(itemPrice) ?? 0) * -1),
      });

      chatlist.itemLength -= 1;
      chatlist.totalPrice -= double.tryParse(itemPrice) ?? 0;
      notifyListeners();
      TrackingUtils().trackProductAction(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(),
          itemOldPrice.isNotEmpty, listId, chatlist.name, itemQuantity, 'Delete',
          productId: itemId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateListName(String value, String listId) async {
    await FirebaseFirestore.instance.collection('/lists').doc(listId).update({"list_name": value});
    var chatlist = chatlists.firstWhere((chatlist) => chatlist.id == listId);
    chatlist.name = value;
    notifyListeners();
    TrackingUtils().trackSideMenuItemClicked(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(),
        "Chatlist Side Menu", "Rename", "Chatlist Screen");
  }

  Future<void> addProductToList(BuildContext context, ListItem listItem) async {
    //adds a product from home or product page to chatlist
    // print("Adding category ${listItem.id}");
    // print("Adding category ${listItem.name}");
    // print("Adding category ${listItem.price}");
    // print("Adding item ${listItem.category}");
      if (chatlists.length > 1) showChooseListDialog(context: context, listItem: listItem);
      if (chatlists.length == 1) {
        await addItemToList(listItem, chatlists[0].id);
        TrackingUtils().trackProductAction(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(),
            listItem.oldPrice != null, chatlists[0].id, chatlists[0].name, listItem.quantity.toString(), 'Add', productId: listItem.id.toString());
        showChatlistSnackBar(context, Text(LocaleKeys.addedTo.tr() + " ${chatlists[0].name}"), LocaleKeys.view.tr(),
            chatlists[0].id, false);
      }
      if (chatlists.isEmpty) {
        showChatlistSnackBar(context, Text(LocaleKeys.pleaseCreateAList.tr()), LocaleKeys.create.tr(), "", true);
      }
    TrackingUtils().trackButtonClick(
        FirebaseAuth.instance.currentUser!.uid, "add product", DateTime.now().toUtc().toString(), "Product screen");
  }

  Future<void> updateItemQuantity(String chatlistId, String itemId, int newQuantity) async {
    //changes item quantity in a chatlist
    await FirebaseFirestore.instance
        .collection("/lists/${chatlistId}/items")
        .doc(itemId)
        .update({'item_quantity': newQuantity});
    print('Done updating quantity');
    notifyListeners();
  }

  //chat methods
  Future<void> sendMessage(String message, String listId, String chatlistName, String collectionName) async {
    if (message.isNotEmpty) {
      final userData =
          await FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      await FirebaseFirestore.instance.collection('/lists/${listId}/${collectionName}').add({
        'item_name': "",
        'item_image': "",
        'item_description': "",
        'store_name': "",
        'isAddedToList': false,
        'item_price': 0.0,
        'item_oldPrice': "",
        'message': message,
        'createdAt': Timestamp.fromDate(DateTime.now().toUtc()),
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'username': userData['username'],
        'userImageURL': userData['imageURL'],
      });
      FirebaseFirestore.instance.collection('/lists').doc(listId).update({
        "last_message": message,
        "last_message_date": Timestamp.fromDate(DateTime.now().toUtc()),
        "last_message_userId": FirebaseAuth.instance.currentUser?.uid,
        "last_message_userName": userData['username'],
      });
      updateChatList(listId, message, userData);
    }
    TrackingUtils().trackChatlistMessageSent(
        FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), message, listId, chatlistName);
    TrackingUtils().trackButtonClick(
        FirebaseAuth.instance.currentUser!.uid, "Send message", DateTime.now().toUtc().toString(), "Chatlist screen");
  }

  Future<bool> shareItem({required ListItem item, required String docId}) async {
    final userData =
        await FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    await FirebaseFirestore.instance.collection('/lists/$docId/messages').add({
      'item_id': item.id,
      'item_name': item.name,
      'item_image': item.imageURL,
      "item_brand": item.brand,
      'item_description': item.size,
      'store_name': item.storeName,
      'isAddedToList': false,
      'item_price': item.price,
      'item_oldPrice': item.oldPrice,
      'message': "",
      'createdAt': Timestamp.fromDate(DateTime.now().toUtc()),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'username': userData['username'],
      'userImageURL': userData['imageURL'],
    });
    FirebaseFirestore.instance.collection('/lists').doc(docId).update({
      "last_message": "Shared ${item.name}",
      "last_message_date": Timestamp.fromDate(DateTime.now().toUtc()),
      "last_message_userId": FirebaseAuth.instance.currentUser?.uid,
      "last_message_userName": userData['username'],
    }).onError((error, stackTrace) => () {
          return false;
        });

    return true;
  }

  Future<bool> shareItemAsMessage(
      {itemId, itemName, itemImage, itemSize, itemPrice, itemOldPrice, itemDescription, storeName, listId}) async {
    final userData =
        await FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    await FirebaseFirestore.instance.collection('/lists/$listId/messages').add({
      'item_id': itemId,
      'item_name': itemName,
      'item_image': itemImage,
      'item_description': itemDescription,
      'item_size': itemSize,
      'store_name': storeName,
      'isAddedToList': false,
      'item_price': itemPrice,
      'item_oldPrice': itemOldPrice,
      'message': "",
      'createdAt': Timestamp.fromDate(DateTime.now().toUtc()),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'username': userData['username'],
      'userImageURL': userData['imageURL'],
    });
    FirebaseFirestore.instance.collection('/lists').doc(listId).update({
      "last_message": "Shared $itemName",
      "last_message_date": Timestamp.fromDate(DateTime.now().toUtc()),
      "last_message_userId": FirebaseAuth.instance.currentUser?.uid,
      "last_message_userName": userData['username'],
    });
    updateChatList(listId, 'Shared $itemName', userData);
    return true;
  }

  Future<bool> addItemToList(ListItem item, String docId) async {
    bool done = true;
    final userData =
        await FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    await FirebaseFirestore.instance.collection('/lists/$docId/items').add({
      'item_id': item.id,
      "item_name": item.name,
      "item_brand": item.brand,
      "item_size": item.size,
      "item_price": item.price,
      "item_image": item.imageURL,
      'store_name': item.storeName,
      'item_quantity': item.quantity,
      'item_oldPrice': item.oldPrice,
      'item_category': item.category,
      "item_isChecked": false,
      "text": item.text,
      "owner": userData['username'],
      "time": Timestamp.fromDate(DateTime.now().toUtc()),
    }).catchError((e) {
      done = false;
    });
    if (item.text.isEmpty)
      await FirebaseFirestore.instance.collection('/lists/$docId/messages').add({
        'item_id': item.id,
        "item_name": item.name,
        "item_image": item.imageURL,
        'item_description': "",
        "item_brand": item.brand,
        'item_size': item.size,
        'store_name': item.storeName,
        'item_quantity': item.quantity,
        'isAddedToList': false,
        "item_price": item.price,
        'item_oldPrice': item.oldPrice,
        'message': "",
        'createdAt': Timestamp.fromDate(DateTime.now().toUtc()),
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'username': userData['username'],
        'userImageURL': userData['imageURL'],
      }).catchError((e) {
        print(e);
      });
    FirebaseFirestore.instance.collection('/lists').doc(docId).update({
      "last_message": "Added ${item.name}",
      "last_message_date": Timestamp.fromDate(DateTime.now().toUtc()),
      "last_message_userId": FirebaseAuth.instance.currentUser?.uid,
      "last_message_userName": userData['username'],
    });
    updateChatList(docId, '', userData);
    return done;
  }

  Future<void> addMessageToList({
    required DocumentReference messageDocPath,
    required String message,
    required String userName,
    required String userId,
    required ListItem item,
  }) async {
    await FirebaseFirestore.instance.collection('${messageDocPath.parent.parent?.path}/items').add({
      'item_id': item.id,
      "item_name": item.name,
      "item_brand": item.brand,
      "item_size": item.size,
      "item_price": item.price,
      "item_image": item.imageURL,
      'store_name': item.storeName,
      'item_quantity': item.quantity,
      'item_oldPrice': item.oldPrice,
      "item_isChecked": false,
      "text": item.text,
      "owner": userName,
      "time": Timestamp.fromDate(DateTime.now().toUtc()),
    });
    await updateListInfo(
        itemName: "",
        itemPrice: "",
        messageDocPath: messageDocPath,
        userName: userName,
        userId: userId,
        message: message);
    markItemAsAdded(messageDocPath);
  }

  Future<void> addItemMessageToList({
    required String itemName,
    required String itemSize,
    required String itemPrice,
    required String storeName,
    required String itemImage,
    required DocumentReference messageDocPath,
    required String userName,
    required String userId,
  }) async {
    await FirebaseFirestore.instance.collection('${messageDocPath.parent.parent?.path}/items').add({
      "item_name": itemName,
      "item_size": itemSize,
      "item_price": itemPrice,
      "item_image": itemImage,
      "store_name": storeName,
      "item_isChecked": false,
      "text": "",
      "chat_reference": messageDocPath.path,
      "owner": userName,
      "time": Timestamp.fromDate(DateTime.now().toUtc()),
    });
    await updateListInfo(
        itemName: itemName,
        itemPrice: itemPrice,
        messageDocPath: messageDocPath,
        userName: userName,
        userId: userId,
        message: "");
    markItemAsAdded(messageDocPath);
  }

  Future<void> updateListInfo(
      {required String itemName,
      required String itemPrice,
      required DocumentReference messageDocPath,
      required String userName,
      required String message,
      required String userId}) async {
    var lastMessage = message.isEmpty ? itemName : message;
    await FirebaseFirestore.instance.doc('${messageDocPath.parent.parent?.path}').update({
      "size": FieldValue.increment(1),
      "total_price": FieldValue.increment(double.tryParse(itemPrice) ?? 0),
      "last_message": "Added $lastMessage",
      "last_message_date": Timestamp.fromDate(DateTime.now().toUtc()),
      "last_message_userId": userId,
      "last_message_userName": userName,
    });
    var listId = messageDocPath.parent.parent?.id;
    var chatlist = chatlists.firstWhere((chatlist) => chatlist.id == listId);
    chatlist.itemLength += 1;
    chatlist.totalPrice += double.tryParse(itemPrice) ?? 0;
    chatlist.lastMessage = "Added $lastMessage";
    chatlist.lastMessageDate = Timestamp.fromDate(DateTime.now().toUtc());
    chatlist.lastMessageUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
    chatlist.lastMessageUserName = userName;
    notifyListeners();
  }

  // updates the field isAddedToList to indicate that the chat message has been added to a list successfully hence the a checkmark will show beside the message
  void markItemAsAdded(DocumentReference messageDocPath) {
    messageDocPath.update({
      'isAddedToList': true,
    });
  }

  void updateChatList(String listId, String message, DocumentSnapshot<Map<String, dynamic>> userData) {
    var chatlist = chatlists.firstWhere((chatlist) => chatlist.id == listId);
    chatlist.lastMessage = message;
    chatlist.lastMessageDate = Timestamp.fromDate(DateTime.now().toUtc());
    chatlist.lastMessageUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
    chatlist.lastMessageUserName = userData['username'];
    notifyListeners();
  }

  void showChatlistSnackBar(
      BuildContext context, Widget content, String actionLabel, String selectedListId, bool isCreating) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      backgroundColor: mainPurple,
      content: content,
      action: SnackBarAction(
          label: actionLabel,
          onPressed: () async {
            if (isCreating) {
              await pushNewScreen(context, screen: ChatlistsScreen(), withNavBar: true);
              NavigatorController.jumpToTab(1);
              return;
            }
            await pushNewScreen(context,
                screen: ChatListViewScreen(
                  listId: selectedListId,
                  isExpandingChatlist: true,
                ),
                withNavBar: true);
            NavigatorController.jumpToTab(1);
          }),
    ));
  }
}
