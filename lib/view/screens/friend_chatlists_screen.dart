import 'package:bargainb/view/screens/chatlists_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class FriendChatlistsScreen extends StatelessWidget {
  final String friendName;
  final String friendEmail;
  final String friendImageURL;
  final List<QueryDocumentSnapshot> friendChatlists;
  const FriendChatlistsScreen(
      {Key? key,
      required this.friendName,
      required this.friendEmail,
      required this.friendImageURL,
      required this.friendChatlists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.2,
        backgroundColor: Theme.of(context).canvasColor,
        foregroundColor: black2,
        title: Text(
          LocaleKeys.profile.tr(),
          style: TextStyles.textViewSemiBold16.copyWith(color: black1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            20.ph,
            CircleAvatar(
              backgroundImage: NetworkImage(friendImageURL),
              radius: 100,
            ),
            10.ph,
            Text(
              friendName,
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
            ),
            4.ph,
            Text(
              friendEmail,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
            ),
            20.ph,
            Expanded(
              child: ListView.separated(
                separatorBuilder: (ctx,_) => Divider(),
                itemCount: friendChatlists.length,
                itemBuilder: (ctx, i) {
                  var listId = friendChatlists[i].id;
                  var listName = friendChatlists[i]['list_name'];
                  var size = friendChatlists[i]['size'];
                  var totalPrice = friendChatlists[i]['total_price'];
                  var lastMessageUserId = friendChatlists[i]['last_message_userId'];
                  var lastMessageUserName = friendChatlists[i]['last_message_userName'];
                  var lastMessage = friendChatlists[i]['last_message'];
                  return ChatTile(
                      updateList: () {},
                      listId: listId,
                      listName: listName,
                      size: size.toString(),
                      totalPrice: totalPrice.toString(),
                      lastMessageUserId: lastMessageUserId,
                      lastMessageUserName: lastMessageUserName,
                      lastMessage: lastMessage);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
