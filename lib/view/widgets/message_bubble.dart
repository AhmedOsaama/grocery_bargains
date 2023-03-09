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
  final String itemImage;
  final String userName;
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
      this.isInThread = false, required this.isAddedToList})
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
              width: 160.w,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: ProductItemWidget(
                  price: 1.25.toString(),
                  name: widget.itemName,
                  description: "description",
                  imagePath: widget.itemImage,
                  fullPrice: 1.55.toString(),
                  onTap: null),
            ),
          if (widget.message.isNotEmpty)
            Row(
              children: [
                GestureDetector(
                  onTap: widget.isAddedToList ? (){} : () async {
                    //widget.messageDocPath!.parent.path is equivalent to list id
                    print(widget.messageDocPath.parent.parent?.path);
                    await FirebaseFirestore.instance.collection('${widget.messageDocPath.parent.parent?.path}/items').add(
                        {
                          "text": widget.message,
                          "chat_reference": widget.messageDocPath.path,
                          "item_isChecked" : false,
                          "owner": widget.userName,
                          "time": Timestamp.now(),
                        });
                    widget.messageDocPath.update(
                        {
                          'isAddedToList': true,
                        });

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
              ],
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
}
