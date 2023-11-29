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
import 'package:bargainb/view/widgets/chat_search_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bargainb/utils/app_colors.dart';

import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
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
  final DocumentReference? messageDocPath;
  final bool isMe;
  final bool isInThread;

  Key? key;

  MessageBubble(
      {required this.itemName,
      required this.itemImage,
      required this.userName,
      required this.userImage,
      required this.isMe,
      this.messageDocPath,
      this.key,
      required this.message,
      this.isInThread = false,
      required this.isAddedToList,
      required this.itemPrice,
      required this.itemOldPrice,
      required this.itemSize,
      required this.storeName,
      required this.userId,
      required this.itemId,
      required this.itemBrand,
      required this.itemQuantity})
      : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {

  late Future getUserImageFuture;

  @override
  void initState() {
    getUserImageFuture = getUserImage(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var chatlistProvider = Provider.of<ChatlistsProvider>(context, listen: false);
    return FutureBuilder(
      future: getUserImageFuture,
      builder: (context, snapshot) {
        Widget userImageWidget = snapshot.data ?? Container();
        return Row(
          mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!widget.isMe)
              GestureDetector(
                onTap: () {},
                child: userImageWidget
              ),
            if (widget.message.isEmpty) //case of product as a message
              GestureDetector(
                onTap: () async {
                  var productProvider = Provider.of<ProductsProvider>(context, listen: false);
                 productProvider.goToProductPage(widget.storeName, context, widget.itemId);
                },
                child: Container(
                  key: widget.key,
                  // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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
                        Container(
                          width: widget.message.length > 30 ? MediaQuery.of(context).size.width * 0.6 : null,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: const Radius.circular(18),
                              topLeft: const Radius.circular(18),
                              bottomLeft: const Radius.circular(18) ,
                              bottomRight: const Radius.circular(0),
                            ),
                            color: mainPurple,
                          ),
                          child: Text(
                            widget.message,
                            style: TextStyles.textViewRegular15.copyWith(color: Colors.white ),
                            softWrap: true,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ]
                    : [
                        Container(
                          width: widget.message.length > 30 ? MediaQuery.of(context).size.width * 0.6 : null,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: const Radius.circular(18),
                              topLeft: const Radius.circular(18),
                              bottomLeft: const Radius.circular(0),
                              bottomRight: const Radius.circular(18),
                            ),
                            color: widget.userId == "bargainb" ? Colors.white : purple50,
                          ),
                          child: Text(
                            widget.message,
                            style: TextStyles.textViewRegular16.copyWith(color:  widget.userId == "bargainb" ? Colors.black : Colors.white ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ].reversed.toList(),
              ),
          ],
        );
      }
    );
  }

  Future<Widget> getUserImage(String userId) async {
    String userImage = '';
    if(userId.isNotEmpty) {
      var docRef = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      userImage = docRef.get('imageURL');
    }else{
      userImage = widget.userImage;
    }
      if (userImage.isEmpty || userImage == null) {
        return CircleAvatar(
          child: SvgPicture.asset(bee),
          radius: 20,
        );
      }
      return CircleAvatar(
        backgroundImage: NetworkImage(userImage),
        radius: 20,
      );
  }
}
