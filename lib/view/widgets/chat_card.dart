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
        future: FirebaseFirestore.instance.collection('/lists/${allLists.elementAt(i).id}/items').get(),
        builder: (context, snapshot) {
          var storeItems = snapshot.data?.docs ?? [];
          return InkWell(
            onTap: () => pushNewScreen(context,
                screen: ChatListViewScreen(
                  listId: allLists.elementAt(i).id,
                ),
                withNavBar: false),
            child: Container(
              padding: EdgeInsets.only(left: 17.w, top: 10.h, bottom: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: white,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allLists[i].name,
                          style: TextStylesInter.textViewSemiBold16.copyWith(color: black2),
                        ),
                        15.ph,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text.rich(
                              TextSpan(text: "${LocaleKeys.chatlist.tr()} ",style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                                  children: [TextSpan(text: " ${storeItems.length} ${LocaleKeys.items.tr()}",style: TextStylesInter.textViewSemiBold10.copyWith(color: blackSecondary))])
                            ),
                            10.pw,
                            Text.rich(
                                TextSpan(text: "${LocaleKeys.total.tr()} ",style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                                    children: [TextSpan(text: " €${getTotalListPrice(storeItems)}",style: TextStylesInter.textViewSemiBold10.copyWith(color: mainPurple))])
                            ),
                            10.pw,
                            Text.rich(
                                TextSpan(text: "${LocaleKeys.savings.tr()} ",style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                                    children: [TextSpan(text: "€${getTotalListSavings(storeItems)}",style: TextStylesInter.textViewSemiBold10.copyWith(color: greenSecondary))])
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          (allLists[i].lastMessageDate.toDate()).toString().split(' ')[0],
                          style: TextStylesInter.textViewRegular14.copyWith(color: Color.fromRGBO(72, 72, 74, 1)),
                          overflow: TextOverflow.ellipsis,
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
            ),
          );
        });
  }

  Future<Widget> getUserImages(String docId) async {
    List<Widget> imageWidgets = [];
    imageWidgets.clear();
    List userIds = [];
    try {
      final list =
          await FirebaseFirestore.instance.collection('/lists').doc(docId).get().timeout(Duration(seconds: 10));
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
      final userSnapshot = await FirebaseFirestore.instance.collection('/users').doc(userId).get();
      imageUrl = userSnapshot.data()!['imageURL'];
      if (imageUrl.isEmpty) {
        imageWidgets.add(CircleAvatar(child: SvgPicture.asset(bee),radius: 9,));
      } else {
        imageWidgets.add(CircleAvatar(
          backgroundImage: NetworkImage(
            imageUrl,
          ),
          radius: 9,
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
      if (item.data().containsKey('item_price') && item['item_price'].runtimeType == String) {
        if (item['item_price'] != null && item['item_price'] != "null" && item['item_price'] != "") {
          total += double.parse(item['item_price']);
        } else {
          total += 0;
        }
      } else if (item.data().containsKey('item_price') && item['item_price'].runtimeType == double) {
        total += item['item_price'] ?? 0;
      } else {
        total += 0;
      }
    }

    return total.toStringAsFixed(2);
  }

  String getTotalListSavings(List items) {
    var total = 0.0;
    for (var item in items) {
      try {
        total += item['item_oldPrice'].runtimeType == String
            ? (double.parse(item['item_oldPrice']) - double.parse(item['item_price']) )
            : (item['item_oldPrice'] - item['item_price'] );
      } catch (e) {
        total += 0.0;
      }
    }
    return total.toStringAsFixed(2);
  }
}
