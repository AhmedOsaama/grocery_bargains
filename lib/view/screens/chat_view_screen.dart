import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/components/my_scaffold.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/list_view_screen.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/icons_manager.dart';
import '../components/generic_appbar.dart';
import '../widgets/message_bubble.dart';
import 'category_items_screen.dart';

class ChatViewScreen extends StatefulWidget {
  final String listName;
  final String listId;
  ChatViewScreen({Key? key, required this.listName, required this.listId})
      : super(key: key);

  @override
  State<ChatViewScreen> createState() => _ChatViewScreenState();
}

class _ChatViewScreenState extends State<ChatViewScreen> {
  var messageController = TextEditingController();
  int? selectedMessageIndex;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Column(
      children: [
        SizedBox(
          height: 62.h,
        ),
        GenericAppBar(
          appBarTitle: widget.listName,
          actions: [

            SizedBox(
              width: 20.w,
            ),
            // GestureDetector(
            //   onTap: () => AppNavigator.pushReplacement(
            //       context: context,
            //       screen: ListViewScreen(
            //           listId: widget.listId, listName: widget.listName)),
            //   child: SvgPicture.asset(listViewIcon),
            // )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        //Todo: add person image here
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("/lists/${widget.listId}/items")
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (ctx, index) => Container(
                        padding: const EdgeInsets.all(8.0),
                        child: MessageBubble(
                          itemName: messages[index]['item_name'],
                          itemImage: messages[index]['item_image'],
                          isMe: messages[index]['userId'] ==
                              FirebaseAuth.instance.currentUser!.uid,
                          message: messages[index]['message'],
                          messageDocPath: messages[index].reference,
                          userName: messages[index]['username'],
                          userImage: messages[index]['userImageURL'],
                          key: ValueKey(messages[index].id),
                        ),
                      ));
                })),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Spacer(),
            Container(
              width: 280.w,
              child: TextField(
                controller: messageController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Type Something Here...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            GestureDetector(
                onTap: () async {
                  print(messageController.text.trim());
                  if (messageController.text.trim().isNotEmpty) {
                    final userData = await FirebaseFirestore.instance
                        .collection('/users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get();
                    FirebaseFirestore.instance
                        .collection('/lists/${widget.listId}/items')
                        .add({
                      'item_name': "",
                      'item_image': "",
                      'item_description': "",
                      'item_quantity': "",
                      'item_isChecked': '',
                      'item_price': 0.0,
                      'message': messageController.text.trim(),
                      'createdAt': Timestamp.now(),
                      'userId': FirebaseAuth.instance.currentUser!.uid,
                      'username': userData['username'],
                      'userImageURL': userData['imageURL'],
                    });
                    messageController.clear();
                  }
                },
                child: SvgPicture.asset(
                  messageIcon,
                  width: 24.w,
                  height: 26.h,
                )),
          ],
        )
      ],
    ));
  }
}
