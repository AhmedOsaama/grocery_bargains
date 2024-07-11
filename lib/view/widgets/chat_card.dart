import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../generated/locale_keys.g.dart';
import '../../providers/chatlists_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets_manager.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../../utils/tracking_utils.dart';
import '../../features/chatlists/presentation/views/chatlist_view_screen.dart';

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
          return Material(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onLongPress: () {
                showDialog(context: context, builder: (ctx) => DeleteChatlistDialog(allLists: allLists, i: i));
              },
              onTap: () {
                pushNewScreen(context,
                    screen: ChatListViewScreen(
                      listId: allLists.elementAt(i).id,
                    ),
                    withNavBar: true);
                TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "open chatlist",
                    DateTime.now().toUtc().toString(), "Chatlists screen");
              },
              child: Container(
                padding: EdgeInsets.only(left: 17.w, top: 10.h, bottom: 10.h),
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
                          buildChatlistMetadataRow(storeItems)
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
            ),
          );
        });
  }

  Row buildChatlistMetadataRow(List<QueryDocumentSnapshot<Object?>> storeItems) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(TextSpan(
            text: "${LocaleKeys.chatlist.tr()} ",
            style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
            children: [
              TextSpan(
                  text: " ${storeItems.length} ${LocaleKeys.items.tr()}",
                  style: TextStylesInter.textViewSemiBold10.copyWith(color: blackSecondary))
            ])),
        10.pw,
        Text.rich(TextSpan(
            text: "${LocaleKeys.total.tr()} ",
            style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
            children: [
              TextSpan(
                  text: " €${getTotalListPrice(storeItems)}",
                  style: TextStylesInter.textViewSemiBold10.copyWith(color: mainPurple))
            ])),
        10.pw,
        Text.rich(TextSpan(
            text: "${LocaleKeys.savings.tr()} ",
            style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
            children: [
              TextSpan(
                  text: "€${getTotalListSavings(storeItems)}",
                  style: TextStylesInter.textViewSemiBold10.copyWith(color: greenSecondary))
            ])),
      ],
    );
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
        imageWidgets.add(CircleAvatar(
          child: SvgPicture.asset(bee),
          radius: 9,
        ));
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
      try {
        total += (item['item_price'].runtimeType == String
                ? double.parse(item['item_price'])
                : item['item_price'] ?? 99999) *
            item['item_quantity'];
      } catch (e) {
        total += 0.0;
      }
    }
    return total.toStringAsFixed(2);
  }

  String getTotalListSavings(List items) {
    var total = 0.0;
    for (var item in items) {
      try {
        total += (item['item_oldPrice'].runtimeType == String
                ? (double.parse(item['item_oldPrice']) - double.parse(item['item_price']))
                : (item['item_oldPrice'] - item['item_price'])) *
            item['item_quantity'];
      } catch (e) {
        total += 0.0;
      }
    }
    return total.toStringAsFixed(2);
  }
}

class DeleteChatlistDialog extends StatelessWidget {
  const DeleteChatlistDialog({
    super.key,
    required this.allLists,
    required this.i,
  });

  final List<ChatList> allLists;
  final int i;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: Icon(
        Icons.delete_forever_rounded,
        color: Colors.red,
        size: 28,
      ),
      title: Text("DeleteChatlist".tr()),
      content: Text(
        "Are you sure you want to delete ${allLists[i].name} ?",
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<ChatlistsProvider>(context, listen: false).deleteList(context, allLists[i].id);
          },
          child: Text(
            LocaleKeys.delete.tr(),
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            AppNavigator.pop(context: context);
          },
          child: Text(LocaleKeys.cancel.tr()),
        ),
      ],
    );
  }
}
