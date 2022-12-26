import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'dart:io';

import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/screens/thread_screen.dart';

import '../components/button.dart';

class MessageBubble extends StatefulWidget {
  // final String message;
  final String itemName;
  final String itemImage;
  final String userName;
  final String userImage;
  final String message;
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
      required this.message, this.isInThread = false})
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
          Container(
            key: widget.key,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft:
                    widget.isMe ? Radius.circular(10) : Radius.circular(0),
                bottomRight:
                    widget.isMe ? Radius.circular(0) : Radius.circular(10),
              ),
              color: widget.isMe
                  ? Colors.yellow.withOpacity(0.6)
                  : Colors.lightGreenAccent,
            ),
            width: 100.w,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            child: Column(
              crossAxisAlignment: widget.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(widget.userName, style: TextStyles.textViewBold20
                    // textAlign: isMe ? TextAlign.end : TextAlign.start,
                    ),
                if (widget.message.isNotEmpty)
                  Text(
                    widget.message,
                    style: TextStyles.textViewRegular15,
                  ),
                if (widget.message.isEmpty) ...[
                  Text(
                    widget.itemName,
                    style: TextStyles.textViewMedium16,
                  ),
                  Image.network(
                    widget.itemImage,
                    width: 100,
                    height: 100,
                  )
                ],
              ],
            ),
          ),
          widget.userImage.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(widget.userImage),
                  radius: 20,
                )
              : SvgPicture.asset(personIcon),
          if(isDisplayingOptions)
            ...[
          Spacer(),
              SizedBox(
                width: 30.w,
              ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GenericButton(
                        onPressed: () {},
                        // height: 30.h,
                        borderRadius: BorderRadius.circular(10),
                        child: Text("Delete Message")),
                    SizedBox(height: 10.h,),
                    if(!widget.isInThread)
                    GenericButton(
                        onPressed: () => AppNavigator.push(context: context, screen: ThreadScreen(messageDocRef: widget.messageDocPath!,)),
                        borderRadius: BorderRadius.circular(10),
                        child: Text("Reply in thread")),
                  ],
                )
            ]
        ],
      ),
    );
  }
}
