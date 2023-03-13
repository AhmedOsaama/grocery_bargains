import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/utils/app_colors.dart';
import 'dart:io';

import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/profile_screen.dart';
import 'package:swaav/view/screens/thread_screen.dart';
import 'package:swaav/view/widgets/product_item.dart';

import '../components/button.dart';

class MessageBubble extends StatefulWidget {
  // final String message;
  final String itemName;
  final String itemPrice;
  final String itemOldPrice;
  final String itemSize;
  final String itemImage;
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
      this.isInThread = false, required this.isAddedToList, required this.itemPrice, required this.itemOldPrice, required this.itemSize, required this.storeName, required this.userId})
      : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool isDisplayingOptions = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isDisplayingOptions = !isDisplayingOptions;
        });
      },
      child: Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(!widget.isMe) widget.userImage.isNotEmpty
              ? CircleAvatar(
            backgroundImage: NetworkImage(widget.userImage),
            radius: 20,
          )
              : SvgPicture.asset(personIcon),
          if (widget.message.isEmpty)
            Container(
              key: widget.key,
              // width: ,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: ProductItemWidget(
                  onTap: () => addItemMessageToList(itemName: widget.itemName, itemSize: widget.itemSize, itemPrice: widget.itemPrice, itemImage: widget.itemImage),
                  price: widget.itemPrice,
                  name: widget.itemName,
                  size: widget.itemSize,
                  imagePath: widget.itemImage,
                  oldPrice: widget.itemOldPrice,
                isAddedToList: widget.isAddedToList,
                storeName: widget.storeName,
              ),
            ),
          if (widget.message.isNotEmpty)
            Row(
              children: widget.isMe ?
              [
                GestureDetector(
                  onTap: widget.isAddedToList ? (){} : () async {
                    await addMessageToList();
                  },
                    child: widget.isAddedToList ? SvgPicture.asset(checkMark) : SvgPicture.asset(add)
                ) ,
                5.pw,
                Container(
                  width: 220.w,
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(18),
                      topLeft: const Radius.circular(18),
                      bottomLeft:
                          widget.isMe ? const Radius.circular(18) : const Radius.circular(0),
                      bottomRight:
                          widget.isMe ? const Radius.circular(0) : const Radius.circular(18),
                    ),
                    color:
                        widget.isMe ? iris : const Color.fromRGBO(233, 233, 235, 1),
                  ),
                  child: Text(
                    widget.message,
                    style: TextStyles.textViewRegular16
                        .copyWith(color: widget.isMe ? Colors.white : Colors.black),
                    textAlign: widget.isMe ? TextAlign.right : TextAlign.left,
                  ),
                ),
              ] : [
                GestureDetector(
                    onTap: widget.isAddedToList ? (){} : () async {
                      await addMessageToList();
                    },
                    child: widget.isAddedToList ? SvgPicture.asset(checkMark) : SvgPicture.asset(add)
                ) ,
                5.pw,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(18),
                      topLeft: const Radius.circular(18),
                      bottomLeft:
                      widget.isMe ? const Radius.circular(18) : const Radius.circular(0),
                      bottomRight:
                      widget.isMe ? const Radius.circular(0) : const Radius.circular(18),
                    ),
                    color:
                    widget.isMe ? iris : const Color.fromRGBO(233, 233, 235, 1),
                  ),
                  child: Text(
                    widget.message,
                    style: TextStyles.textViewRegular16
                        .copyWith(color: widget.isMe ? Colors.white : Colors.black),
                    textAlign: widget.isMe ? TextAlign.right : TextAlign.left,
                  ),
                ),
              ].reversed.toList(),
            ),
          if(widget.isMe)
          widget.userImage.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(widget.userImage),
                  radius: 20,
                )
              : SvgPicture.asset(personIcon),
          // if (isDisplayingOptions) ...[
          //   Spacer(),
          //   SizedBox(
          //     width: 30.w,
          //   ),
          //   Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       GenericButton(
          //           onPressed: () {},
          //           // height: 30.h,
          //           borderRadius: BorderRadius.circular(10),
          //           child: const Text("Delete Message")),
          //       SizedBox(
          //         height: 10.h,
          //       ),
          //       if (!widget.isInThread)
          //         GenericButton(
          //             onPressed: () => AppNavigator.push(
          //                 context: context,
          //                 screen: ThreadScreen(
          //                   messageDocRef: widget.messageDocPath!,
          //                 )),
          //             borderRadius: BorderRadius.circular(10),
          //             child: const Text("Reply in thread")),
          //     ],
          //   )
          // ]
        ],
      ),
    );
  }

  Future<void> addMessageToList() async {
     await FirebaseFirestore.instance.collection('${widget.messageDocPath.parent.parent?.path}/items').add(
        {
          "text": widget.message,
          "chat_reference": widget.messageDocPath.path,
          "item_isChecked" : false,
          "owner": widget.userName,
          "time": Timestamp.now(),
        });
     await updateListInfo();
    markItemAsAdded();
  }

  Future<void> addItemMessageToList({required String itemName, required String itemSize, required String itemPrice, required String itemImage}) async {
    await FirebaseFirestore.instance.collection('${widget.messageDocPath.parent.parent?.path}/items').add(
        {
          "item_name": itemName,
          "item_size" : itemSize,
          "item_price" : itemPrice,
          "item_image" : itemImage,
          "item_isChecked" : false,
          "text": "",
          "chat_reference": widget.messageDocPath.path,
          "owner": widget.userName,
          "time": Timestamp.now(),
        });
    await updateListInfo();
    markItemAsAdded();
  }

  Future<void> updateListInfo() async {
     await FirebaseFirestore.instance.doc('${widget.messageDocPath.parent.parent?.path}').update(
       {
         "size": FieldValue.increment(1),
         "total_price": FieldValue.increment(double.tryParse(widget.itemPrice) ?? 0),
         "last_message": widget.message.isEmpty ? widget.itemName : widget.message,
         "last_message_date": Timestamp.now(),
         "last_message_userId": widget.userId,
         "last_message_userName": widget.userName,
       });
  }

    // updates the field isAddedToList to indicate that the chat message has been added to a list successfully hence the a checkmark will show beside the message
  void markItemAsAdded() {
    widget.messageDocPath.update(
        {
          'isAddedToList': true,
        });
  }


}
