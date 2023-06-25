import 'dart:convert';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/models/product.dart';
import 'package:bargainb/models/user_info.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/services/network_services.dart';
import 'package:bargainb/view/screens/contact_profile_screen.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/screens/product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bargainb/utils/app_colors.dart';

import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../../models/list_item.dart';
import '../../providers/chatlists_provider.dart';

class MessageBubble extends StatefulWidget {
  // final String message;
  final int itemId;
  final String itemName;
  final String itemPrice;
  final String itemOldPrice;
  final String itemSize;
  final String itemImage;
  final String itemBrand;
  final int itemQuantity;
  final String storeName;
  final String userName;
  final String userId;
  final String userImage;
  final String message;

  final bool isAddedToList;
  final DocumentReference messageDocPath;
  final bool isMe;
  final bool isInThread;

  Key? key;

  MessageBubble(
      {required this.itemName,
      required this.itemImage,
      required this.userName,
      required this.userImage,
      required this.isMe,
      required this.messageDocPath,
      this.key,
      required this.message,
      this.isInThread = false,
      required this.isAddedToList,
      required this.itemPrice,
      required this.itemOldPrice,
      required this.itemSize,
      required this.storeName,
      required this.userId, required this.itemId, required this.itemBrand, required this.itemQuantity})
      : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  // bool isDisplayingOptions = false;

  @override
  Widget build(BuildContext context) {
    var chatlistProvider =
        Provider.of<ChatlistsProvider>(context, listen: false);
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!widget.isMe)
          GestureDetector(
            onTap: () async {
              List<ChatList> lists = [];
              var friends =
                  await Provider.of<ChatlistsProvider>(context, listen: false)
                      .getAllFriends();

              friends.forEach((element) {
                if (element.id == widget.userId) {
                  element.chatlists.forEach((element) {
                    lists.add(ChatList(
                        id: element.id,
                        name: element.get("list_name"),
                        storeName: element.get("storeName"),
                        userIds: element.get("userIds"),
                        totalPrice: element.get("total_price"),
                        storeImageUrl: element.get("storeImageUrl"),
                        itemLength: element.get("size"),
                        lastMessage: element.get("last_message"),
                        lastMessageDate: element.get("last_message_date"),
                        lastMessageUserId: element.get("last_message_userId"),
                        lastMessageUserName:
                            element.get("last_message_userName")));
                  });
                }
              });

              AppNavigator.push(
                  context: context,
                  screen: ContactProfileScreen(
                    lists: lists,
                    user: UserContactInfo(
                        email: "",
                        id: widget.userId,
                        imageURL: widget.userImage,
                        name: widget.userName,
                        phoneNumber: ''),
                  ));
            },
            child: widget.userImage.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(widget.userImage),
                    radius: 20,
                  )
                : SvgPicture.asset(personIcon),
          ),
        if (widget.message.isEmpty)                             //case of product as a message
          GestureDetector(
            onTap: () async {
              var productProvider = Provider.of<ProductsProvider>(context, listen: false);
              late Product product;
              switch (widget.storeName) {
                case 'Hoogvliet':
                  product = productProvider.hoogvlietProducts.firstWhere((product) => product.id == widget.itemId);
                  break;
                case 'Jumbo':
                  product = productProvider.jumboProducts.firstWhere((product) => product.id == widget.itemId);
                  break;
                case 'Albert':
                  product = productProvider.albertProducts.firstWhere((product) => product.id == widget.itemId);
                  break;
              }
              AppNavigator.push(
                  context: context,
                  screen: ProductDetailScreen(
                    productId: product.id,
                    productBrand: product.brand,
                    oldPrice: product.oldPrice,
                    storeName: product.storeName,
                    productName: product.name,
                    imageURL: product.imageURL,
                    description: product.description,
                    size1: product.size,
                    size2: product.size2 ?? "",
                    price1: double.tryParse(product.price ?? "") ?? 0.0,
                    price2: double.tryParse(product.price2 ?? "") ?? 0.0,
                  ));
            },
            child: Container(
              key: widget.key,
              // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: ProductItemWidget(
                brand: widget.itemBrand,
                price: widget.itemPrice,
                name: widget.itemName,
                size: widget.itemSize,
                quantity: widget.itemQuantity,
                imagePath: widget.itemImage,
                oldPrice: widget.itemOldPrice,
                isAddedToList: widget.isAddedToList,
                storeName: widget.storeName,
              ),
            ),
          ),
        if (widget.message.isNotEmpty)
          Row(
            children: widget.isMe
                ? [
                    GestureDetector(
                        onTap: widget.isAddedToList
                            ? () {}
                            : () async {
                                await chatlistProvider.addMessageToList(
                                  messageDocPath: widget.messageDocPath,
                                  userName: widget.userName,
                                  userId: widget.userId,
                                  message: widget.message,
                                  item: ListItem(
                                            id: -1,
                                            storeName: "",
                                            imageURL: '',
                                            isChecked: false,
                                            name: widget.message,
                                            price: "0.0",
                                            quantity: 0,
                                            size: '',
                                            text: widget.message,
                                            brand: ''),
                                );
                              },
                        child: widget.isAddedToList
                            ? SvgPicture.asset(checkMark)
                            : SvgPicture.asset(add)),
                    5.pw,
                    Container(
                      width: widget.message.length > 30
                          ? MediaQuery.of(context).size.width * 0.6
                          : null,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: const Radius.circular(18),
                          topLeft: const Radius.circular(18),
                          bottomLeft: widget.isMe
                              ? const Radius.circular(18)
                              : const Radius.circular(0),
                          bottomRight: widget.isMe
                              ? const Radius.circular(0)
                              : const Radius.circular(18),
                        ),
                        color: widget.isMe
                            ? iris
                            : const Color.fromRGBO(233, 233, 235, 1),
                      ),
                      child: Text(
                        widget.message,
                        style: TextStyles.textViewRegular16.copyWith(
                            color: widget.isMe ? Colors.white : Colors.black),
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ]
                : [
                    GestureDetector(
                        onTap: widget.isAddedToList
                            ? () {}
                            : () async {
                          await chatlistProvider.addMessageToList(
                            messageDocPath: widget.messageDocPath,
                            userName: widget.userName,
                            userId: widget.userId,
                            message: widget.message,
                            item: ListItem(
                                id: -1,
                                storeName: "",
                                imageURL: '',
                                isChecked: false,
                                name: widget.message,
                                price: "0.0",
                                quantity: 0,
                                size: '',
                                text: widget.message,
                                brand: ''),
                          );
                              },
                        child: widget.isAddedToList
                            ? SvgPicture.asset(checkMark)
                            : SvgPicture.asset(add)),
                    5.pw,
                    Container(
                      width: widget.message.length > 30
                          ? MediaQuery.of(context).size.width * 0.6
                          : null,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: const Radius.circular(18),
                          topLeft: const Radius.circular(18),
                          bottomLeft: widget.isMe
                              ? const Radius.circular(18)
                              : const Radius.circular(0),
                          bottomRight: widget.isMe
                              ? const Radius.circular(0)
                              : const Radius.circular(18),
                        ),
                        color: widget.isMe
                            ? iris
                            : const Color.fromRGBO(233, 233, 235, 1),
                      ),
                      child: Text(
                        widget.message,
                        style: TextStyles.textViewRegular16.copyWith(
                            color: widget.isMe ? Colors.white : Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ].reversed.toList(),
          ),
        if (widget.isMe)
          GestureDetector(
            onTap: () {
              AppNavigator.pop(context: context);
              NavigatorController.jumpToTab(2);
            },
            child: widget.userImage.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(widget.userImage),
                    radius: 20,
                  )
                : CircleAvatar(
              child: SvgPicture.asset(bee),
              radius: 20,
            ),
          ),
      ],
    );
  }

}
