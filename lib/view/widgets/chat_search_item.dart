import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class ChatSearchItem extends StatelessWidget {
  final ChatList list;
  const ChatSearchItem({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 130,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 28,
              offset: Offset(0, 4),
              color: Color.fromRGBO(59, 59, 59, 0.12),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => pushNewScreen(context,
              screen: ChatListViewScreen(
                // updateList: updateList,
                listId: list.id,
              ),
              withNavBar: false),
          child: Row(
            children: [
              Image.asset(
                list.storeImageUrl,
                width: 45,
                height: 45,
              ),
              18.pw,
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      list.name,
                      style: TextStylesInter.textViewSemiBold16
                          .copyWith(color: black2),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${list.itemLength} items",
                          style: TextStylesInter.textViewMedium10
                              .copyWith(color: purple50),
                        ),
                        5.pw,
                        Text(
                          "€${list.totalPrice.toStringAsFixed(2)}",
                          style: TextStylesInter.textViewMedium10
                              .copyWith(color: black2),
                        ),
                      ],
                    ),
                    list.lastMessage.isEmpty
                        ? Text("")
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${list.lastMessageUserId == FirebaseAuth.instance.currentUser?.uid ? LocaleKeys.you.tr() : list.lastMessageUserName}: ',
                                style: TextStylesInter.textViewRegular14
                                    .copyWith(color: black2),
                              ),
                              Container(
                                child: Flexible(
                                  child: Text(
                                    list.lastMessage,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      (list.lastMessageDate.toDate()).toString().split(' ')[0],
                      style: TextStylesInter.textViewRegular14
                          .copyWith(color: Color.fromRGBO(72, 72, 74, 1)),
                      overflow: TextOverflow.ellipsis,
                    ),
                    FutureBuilder(
                        future: getUserImages(list.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
        ));
  }
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
    final userSnapshot =
        await FirebaseFirestore.instance.collection('/users').doc(userId).get();
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
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: imageWidgets.map((image) => image).toList()),
    ),
  );
}
