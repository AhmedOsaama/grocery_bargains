import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

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
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('/lists/${allLists.elementAt(i).id}/items')
            .get(),
        builder: (context, snapshot) {
          var storeItems = snapshot.data?.docs ?? [];
          return InkWell(
            onTap: () => pushNewScreen(context,
                screen: ChatListViewScreen(
                  // updateList: updateList,
                  listId: allLists.elementAt(i).id,
                ),
                withNavBar: false),
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
                      snapshot.hasData
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${storeItems.length} ${LocaleKeys.items.tr()}",
                                  style: TextStylesInter.textViewMedium10
                                      .copyWith(color: purple50),
                                ),
                                5.pw,
                                Text(
                                  "€${getTotalListPrice(storeItems)}",
                                  style: TextStylesInter.textViewMedium10
                                      .copyWith(color: black2),
                                ),
                              ],
                            )
                          : Container(),
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: verdigris,
                              ));
                            }
                            return snapshot.data ??
                                SvgPicture.asset(peopleIcon);
                          }),
                    ],
                  ),
                )
              ],
            ),
          );
        });
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
    bool moreThan3 = false;
    if (userIds.length > 3) {
      moreThan3 = true;
      userIds = userIds.getRange(0, 3).toList();
    }
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
    if (moreThan3) {
      imageWidgets.add(Text(
        "...",
        style: TextStyles.textViewBold12.copyWith(color: black),
      ));
    }
    return GestureDetector(
      onTap: () {
        print(imageWidgets.length);
      },
      child: Container(
        height: 50.h,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: imageWidgets.map((image) => image).toList()),
      ),
    );
  }

  String getTotalListPrice(List storeItems) {
    var total = 0.0;
    for (var item in storeItems) {
      if (item.data().containsKey('item_price') &&
          item['item_price'].runtimeType == String) {
        if (item['item_price'] != null &&
            item['item_price'] != "null" &&
            item['item_price'] != "") {
          total += double.parse(item['item_price']);
        } else {
          total += 0;
        }
      } else if (item.data().containsKey('item_price') &&
          item['item_price'].runtimeType == double) {
        total += item['item_price'] ?? 0;
      } else {
        total += 0;
      }
    }

    return total.toStringAsFixed(2);
  }
}
