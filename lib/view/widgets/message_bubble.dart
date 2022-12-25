import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';

import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';


class MessageBubble extends StatelessWidget {
  // final String message;
  final String itemName;
  final String itemImage;
  final String userName;
  final String userImage;
  final String message;
  final bool isMe;
  Key? key;

  MessageBubble({required this.itemName,required this.itemImage, required this.userName,required this.userImage, required this.isMe, this.key, required this.message})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            key: key,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
              ),
              color: isMe ? Colors.yellow.withOpacity(0.6) : Colors.lightGreenAccent,
            ),
            width: 100.w,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Text(
                //   userName,
                //   style: TextStyles.textViewRegular16
                //   // textAlign: isMe ? TextAlign.end : TextAlign.start,
                // ),
                if(message.isNotEmpty)
                  Text(message,style: TextStyles.textViewRegular15,),
                if(message.isEmpty)
                  ...[
                    Text(
                  itemName,
                  style: TextStyles.textViewMedium16,
                ),
               Image.network(itemImage,width: 100,height: 100,)],
              ],
            ),
          ),
          SvgPicture.asset(personIcon),

        ],
      ),
    ]
    );
  }
}
