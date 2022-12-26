import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swaav/view/components/generic_appbar.dart';
import 'package:swaav/view/components/my_scaffold.dart';

import '../../utils/icons_manager.dart';
import '../widgets/message_bubble.dart';

class ThreadScreen extends StatelessWidget {
  final DocumentReference messageDocRef;
  ThreadScreen({Key? key, required this.messageDocRef}) : super(key: key);

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(body: Column(
      children: [
        SizedBox(height: 62.h,),
        const GenericAppBar(appBarTitle: "Thread"),
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: messageDocRef.collection('/thread')
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
                        padding: EdgeInsets.all(8.0),
                        child: MessageBubble(
                          itemName: messages[index]['item_name'],
                          itemImage: messages[index]['item_image'],
                          isMe: messages[index]['userId'] ==
                              FirebaseAuth.instance.currentUser!.uid,
                          isInThread: true,
                          message: messages[index]['message'],
                          userName: messages[index]['username'],
                          userImage: messages[index]['userImageURL'],
                          key: ValueKey(messages[index].id),
                        ),
                      ));
                })),
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
                    messageDocRef.collection('/thread')
                        .add({
                      'item_name': "",
                      'item_image': "",
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
