import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/screens/friend_chatlists_screen.dart';
import 'package:bargainb/view/widgets/chat_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/components/dotted_container.dart';
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/store_list_widget.dart';

import '../../config/routes/app_navigator.dart';
import '../components/generic_field.dart';

enum ChatlistsView { CHATVIEW, LISTVIEW, PERSONVIEW }

class ChatlistsScreen extends StatefulWidget {
  const ChatlistsScreen({Key? key}) : super(key: key);

  @override
  State<ChatlistsScreen> createState() => _ChatlistsScreenState();
}

class _ChatlistsScreenState extends State<ChatlistsScreen> {
  // late Future<QuerySnapshot> getAllListsFuture;
  late Future<QuerySnapshot> getListItemsFuture;
  var isFabPressed = false;
  var chatlistsView = ChatlistsView.CHATVIEW;

  bool isAdding = false;
  @override
  Widget build(BuildContext context) {
    var chatlistsProvider = context.watch<ChatlistsProvider>();
    // Provider.of<ChatlistsProvider>(context);
    return Scaffold(
      floatingActionButton: getFab(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  LocaleKeys.myChatlists.tr(),
                  style:
                      TextStyles.textViewSemiBold30.copyWith(color: prussian),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (chatlistsView == ChatlistsView.CHATVIEW) {
                          chatlistsView = ChatlistsView.LISTVIEW;
                        } else if (chatlistsView == ChatlistsView.LISTVIEW) {
                          chatlistsView = ChatlistsView.CHATVIEW;
                        } else {
                          chatlistsView = ChatlistsView.CHATVIEW;
                        }
                      });
                    },
                    icon: chatlistsView == ChatlistsView.CHATVIEW
                        ? SvgPicture.asset(listViewIcon)
                        : Icon(Icons.chat_outlined)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (chatlistsView != ChatlistsView.PERSONVIEW) {
                        chatlistsView = ChatlistsView.PERSONVIEW;
                      }
                    });
                  },
                  icon: chatlistsView != ChatlistsView.PERSONVIEW
                      ? Icon(Icons.account_circle_outlined)
                      : Container(),
                )
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
              child:
                  Consumer<ChatlistsProvider>(builder: (context, provider, _) {
                var allLists = provider.chatlists;
                // var allLists = [];
                if (allLists.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      50.ph,
                      DottedContainer(text: LocaleKeys.startAChatlist.tr()),
                      SizedBox(
                        height: 45.h,
                      ),
                    ],
                  );
                }
                if (chatlistsView == ChatlistsView.LISTVIEW) {
                  return SingleChildScrollView(
                    child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 24.h,
                        crossAxisSpacing: 10,
                        children: allLists.map(
                          (chatlist) {
                            return GestureDetector(
                                onTap: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (ctx) => ChatListViewScreen(
                                        // updateList: updateList,
                                        listId: chatlist.id,
                                        isListView: true,
                                      ),
                                    )),
                                child: StoreListWidget(
                                    listId: chatlist.id,
                                    storeImagePath: chatlist.storeImageUrl,
                                    listName: chatlist.name));
                          },
                        ).toList()),
                  );
                }
                if (chatlistsView == ChatlistsView.CHATVIEW)
                  return ListView.separated(
                      separatorBuilder: (ctx, i) => Divider(),
                      itemCount: allLists.length,
                      itemBuilder: (ctx, i) {
                        return ChatCard(allLists, i);
                      });
                //PERSONVIEW case
                return FutureBuilder(
                  future: chatlistsProvider.getAllFriends(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    List<FriendChatLists> friendsList =
                        (snapshot.data ?? []) as List<FriendChatLists>;
                    return ListView.separated(
                        itemCount: friendsList.length,
                        separatorBuilder: (ctx, i) => Divider(),
                        itemBuilder: (ctx, i) {
                          return InkWell(
                            onTap: () {
                              //TODO: go to the person's profile page and display mutual lists.
                              AppNavigator.push(
                                  context: context,
                                  screen: FriendChatlistsScreen(
                                      friendName: friendsList[i].name,
                                      friendEmail: friendsList[i].email,
                                      friendImageURL: friendsList[i].imageURL,
                                      friendChatlists:
                                          friendsList[i].chatlists));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(friendsList[i].imageURL),
                                    radius: 20,
                                  ),
                                  15.pw,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        friendsList[i].name,
                                        style: TextStylesInter
                                            .textViewSemiBold16
                                            .copyWith(color: black2),
                                      ),
                                      5.ph,
                                      Text(
                                        "On " +
                                            friendsList[i]
                                                .chatlists
                                                .length
                                                .toString() +
                                            " lists",
                                        style: TextStylesInter.textViewMedium10
                                            .copyWith(color: purple50),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
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
    var listId = await Provider.of<ChatlistsProvider>(context, listen: false)
        .createChatList();
    AppNavigator.push(
        context: context,
        screen: ChatListViewScreen(
          listId: listId,
          isUsingDynamicLink: false,
        ));
  }
}

class FriendChatLists {
  String name;
  String imageURL;
  String email;
  List<QueryDocumentSnapshot> chatlists;

  FriendChatLists(
      {required this.imageURL,
      required this.name,
      required this.chatlists,
      required this.email});
}
