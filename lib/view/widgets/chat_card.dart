import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets_manager.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../screens/chatlist_view_screen.dart';

class ChatCard extends StatelessWidget {
  final List<ChatList> allLists;
  final int i;
  const ChatCard(this.allLists, this.i);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppNavigator.push(
          context: context,
          screen: ChatListViewScreen(
            // updateList: updateList,
            listId: allLists[i].id,
          )),
      child: Row(
        children: [
          Image.asset(
            storePlaceholder,
            width: 45,
            height: 45,
          ),
          18.pw,
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allLists[i].name,
                  style: TextStylesInter.textViewSemiBold16
                      .copyWith(color: black2),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${allLists[i].itemLength} items",
                      style: TextStylesInter.textViewMedium10
                          .copyWith(color: purple50),
                    ),
                    5.pw,
                    Text(
                      "€${allLists[i].totalPrice.toStringAsFixed(2)}",
                      style: TextStylesInter.textViewMedium10
                          .copyWith(color: black2),
                    ),
                  ],
                ),
                allLists[i].lastMessage.isEmpty
                    ? Text("")
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${allLists[i].lastMessageUserId == FirebaseAuth.instance.currentUser?.uid ? LocaleKeys.you.tr() : allLists[i].lastMessageUserName}: ',
                            style: TextStylesInter.textViewRegular14
                                .copyWith(color: black2),
                          ),
                          Container(
                            //width: 100.w,
                            child: Flexible(
                              child: Text(
                                allLists[i].lastMessage,
                                overflow: TextOverflow.ellipsis,
                                style: TextStylesInter.textViewRegular14
                                    .copyWith(color: black2),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      (allLists[i].lastMessageDate.toDate())
                          .toString()
                          .split(' ')[0],
                      style: TextStylesInter.textViewRegular14
                          .copyWith(color: Color.fromRGBO(72, 72, 74, 1)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                FutureBuilder(
                    future: getUserImages(allLists[i].id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: verdigris,
                        ));
                      }
                      return snapshot.data ?? SvgPicture.asset(peopleIcon);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<Widget> getUserImages(String docId) async {
    List<Widget> imageWidgets = [];
    imageWidgets.clear();
    List userIds = [];
    try {
      final list = await FirebaseFirestore.instance
          .collection('/lists')
          .doc(docId)
          .get()
          .timeout(Duration(seconds: 10));
      userIds = list['userIds'];
    } catch (e) {
      print(e);
      return SvgPicture.asset(peopleIcon);
    }

    if (userIds.isEmpty) return SvgPicture.asset(peopleIcon);
    String imageUrl = "";
    for (var userId in userIds) {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('/users')
          .doc(userId)
          .get();
      imageUrl = userSnapshot.data()!['imageURL'];
      if (imageUrl.isEmpty) {
        imageWidgets.add(SvgPicture.asset(peopleIcon));
      } else {
        imageWidgets.add(CircleAvatar(
          backgroundImage: NetworkImage(
            imageUrl,
          ),
          radius: 12,
        ));
      }
    }

    return GestureDetector(
      onTap: () {
        print(imageWidgets.length);
      },
      child: Container(
        height: 50.h,
        child: Row(children: imageWidgets.map((image) => image).toList()),
      ),
    );
  }
}
