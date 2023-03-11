import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/media_query_values.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/components/dotted_container.dart';
import 'package:swaav/view/components/generic_menu.dart';
import 'package:swaav/view/components/nav_bar.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/choose_store_screen.dart';
import 'package:swaav/view/screens/home_screen.dart';
import 'package:swaav/view/screens/chatlist_view_screen.dart';
import 'package:swaav/view/screens/profile_screen.dart';
import 'package:swaav/view/widgets/backbutton.dart';
import 'package:swaav/view/widgets/store_list_widget.dart';
import 'package:swaav/view/widgets/swaav_list.dart';

import '../../config/routes/app_navigator.dart';
import '../components/generic_field.dart';
import '../widgets/chat_view_widget.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({Key? key}) : super(key: key);

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  late Future<QuerySnapshot> getAllListsFuture;
  late Future<QuerySnapshot> getListItemsFuture;
  var isFabPressed = false;
  var isChatView = true;

  @override
  void initState() {
    super.initState();
    getAllListsFuture = FirebaseFirestore.instance
        .collection('/lists')
        .where("userIds", arrayContains: FirebaseAuth.instance.currentUser?.uid)
        .get();
  }

  void updateList() async {
    print("RUN UPDATE LIST");
    setState(() {
      getAllListsFuture = FirebaseFirestore.instance
          .collection('/lists')
          .where("userIds",
              arrayContains: FirebaseAuth.instance.currentUser?.uid)
          .get();
    });
  }

  bool isAdding = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: getFab(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 91.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.myChatlists.tr(),
                  style:
                      TextStyles.textViewSemiBold30.copyWith(color: prussian),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        isChatView = !isChatView;
                      });
                    },
                    icon: isChatView
                        ? SvgPicture.asset(listViewIcon)
                        : Icon(Icons.chat_outlined))
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            GenericField(
              isFilled: true,
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                return showSearch(
                    context: context, delegate: MySearchDelegate(pref));
              },
              prefixIcon: Icon(Icons.search),
              borderRaduis: 999,
              hintText: LocaleKeys.searchForChats.tr(),
              hintStyle:
                  TextStyles.textViewSemiBold14.copyWith(color: gunmetal),
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: FutureBuilder(
                  future: getAllListsFuture,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var allLists = snapshot.data?.docs ?? [];
                    // var allLists = [];
                    if (!snapshot.hasData || allLists.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          50.ph,
                          DottedContainer(text: LocaleKeys.startAChatlist.tr()),
                          SizedBox(
                            height: 45.h,
                          ),
                          GestureDetector(
                              onTap: () async {
                                await startChatList();
                              },
                              child: SvgPicture.asset(cartIcon)),
                        ],
                      );
                    }
                    if (!isChatView) {
                      return SingleChildScrollView(
                        child: StaggeredGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 24.h,
                            crossAxisSpacing: 10,
                            children: allLists.map(
                              (list) {
                                return GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) => ChatListViewScreen(
                                                updateList: updateList,
                                                storeName: list['storeName'],
                                                storeImage:
                                                    list['storeImageUrl'],
                                                listId: list.id,
                                                isListView: true,
                                                listName: list['list_name']),
                                        )),
                                    child: StoreListWidget(
                                        listId: list.id,
                                        storeImagePath: list['storeImageUrl'],
                                        listName: list['list_name']));
                              },
                            ).toList()),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (ctx,i) => Divider(),
                        itemCount: allLists.length,
                        itemBuilder: (ctx, i) {
                          return InkWell(
                            onTap: () => AppNavigator.push(context: context, screen: ChatListViewScreen(
                              updateList: updateList,
                              listId: allLists[i].id, listName: allLists[i]['list_name'],)),
                            child: Row(
                              children: [
                                Image.asset(
                                  storePlaceholder,
                                  width: 45,
                                  height: 45,
                                ),
                                18.pw,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allLists[i]['list_name'],
                                      style: TextStylesInter.textViewSemiBold16
                                          .copyWith(color: black2),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${allLists[i]['size']} items",
                                          style: TextStylesInter.textViewMedium10
                                              .copyWith(color: purple50),
                                        ),
                                        5.pw,
                                        Text(
                                          "€${allLists[i]['total_price']}",
                                          style: TextStylesInter.textViewMedium10
                                              .copyWith(color: black2),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          //TODO: replace "they" with the real user name who sent the last message
                                          '${allLists[i]['last_message_userId'] == FirebaseAuth.instance.currentUser?.uid ? LocaleKeys.you.tr() : allLists[i]['last_message_userName']}: ',
                                          // '${allLists[i]['last_message_userId'] == FirebaseAuth.instance.currentUser?.uid ? LocaleKeys.you.tr() : "They"}: ',
                                          style: TextStylesInter
                                              .textViewRegular14
                                              .copyWith(color: black2),
                                        ),
                                        Container(
                                          width: 150.w,
                                          child: Text(
                                            allLists[i]['last_message'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStylesInter
                                                .textViewRegular14
                                                .copyWith(color: black2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (allLists[i]['last_message_date'].toDate()
                                              as DateTime)
                                          .toString()
                                          .split(' ')[0],
                                      style: TextStylesInter.textViewRegular14
                                          .copyWith(
                                              color:
                                                  Color.fromRGBO(72, 72, 74, 1)),
                                      overflow: TextOverflow.ellipsis,
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
                                              const Text(
                                                  "Something went wrong");
                                        }),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
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
      imageWidgets.add(CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
        radius: 12,
      ));
    }

    return GestureDetector(
      onTap: () {
        print(imageWidgets.length);
      },
      child: Container(
        height: 50.h,
        child: Row(
          children: imageWidgets
              .map((image) => image)
              .toList()
        ),
      ),
    );
  }

  Future<String> createChatList() async {
    var docRef = await FirebaseFirestore.instance.collection('/lists').add({
      "last_message": "",
      "last_message_date": Timestamp.now(),
      "last_message_userId": "",
      "list_name": "Name...",
      "size": 0,
      "storeImageUrl": storePlaceholder,
      "storeName": "None",
      "total_price": 0.0,
      "userIds": [FirebaseAuth.instance.currentUser?.uid],
    });
    return docRef.id;
  }



  Widget getFab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // if (isFabPressed)
        //   GenericButton(
        //       height: 40,
        //       onPressed: () {
        //         AppNavigator.push(
        //             context: context, screen: const ChooseStoreScreen());
        //       },
        //       borderRadius: BorderRadius.circular(8),
        //       color: Colors.white,
        //       shadow: const [
        //         BoxShadow(
        //             blurRadius: 28,
        //             offset: Offset(0, 4),
        //             color: Color.fromRGBO(59, 59, 59, 0.12))
        //       ],
        //       child: Text(
        //         LocaleKeys.store.tr(),
        //         style: TextStylesDMSans.textViewBold15
        //             .copyWith(color: const Color.fromRGBO(82, 75, 107, 1)),
        //       )),
        // SizedBox(
        //   height: 10.h,
        // ),
        // if (isFabPressed)
        //   GenericButton(
        //       height: 40,
        //       onPressed: () {
        //         AppNavigator.push(context: context, screen: NewListScreen());
        //       },
        //       borderRadius: BorderRadius.circular(8),
        //       shadow: const [
        //         BoxShadow(
        //             blurRadius: 28,
        //             offset: Offset(0, 4),
        //             color: Color.fromRGBO(59, 59, 59, 0.12))
        //       ],
        //       color: Colors.white,
        //       child: Text(
        //         LocaleKeys.blank.tr(),
        //         style: TextStylesDMSans.textViewBold15
        //             .copyWith(color: const Color.fromRGBO(82, 75, 107, 1)),
        //       )),
        // SizedBox(
        //   height: 10.h,
        // ),
        GenericButton(
          width: 60,
          height: 60,
          onPressed: () async {
            await startChatList();
          },
          color: yellow,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(20),
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 50,
          ),
        ),
      ],
    );


  }

  Future<void> startChatList() async {
     var listId = await createChatList();
    AppNavigator.push(context: context, screen: ChatListViewScreen(listId: listId,listName: "Name...", isUsingDynamicLink: false,));
  }
}
