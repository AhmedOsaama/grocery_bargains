import 'dart:developer';

import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/view/components/chats_search_delegate.dart';
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/contact_profile_screen.dart';
import 'package:bargainb/models/user_info.dart' as UserInfo;
import 'package:bargainb/view/screens/newchatlist_screen.dart';
import 'package:bargainb/view/screens/register_screen.dart';
import 'package:bargainb/view/widgets/chat_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/components/dotted_container.dart';

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

  bool isAdding = false;
  @override
  Widget build(BuildContext context) {
    var chatlistsProvider = context.watch<ChatlistsProvider>();
    // Provider.of<ChatlistsProvider>(context);
    return Scaffold(
      floatingActionButton: getFab(),
      /*  appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.2,
      ), */
      body: RefreshIndicator(
        onRefresh: () {
          chatlistsProvider.notifyListeners();
          return Future.value();
        },
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
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
                          if (chatlistsProvider.chatlistsView ==
                              ChatlistsView.CHATVIEW) {
                            chatlistsProvider.chatlistsView =
                                ChatlistsView.LISTVIEW;
                          } else if (chatlistsProvider.chatlistsView ==
                              ChatlistsView.LISTVIEW) {
                            chatlistsProvider.chatlistsView =
                                ChatlistsView.CHATVIEW;
                          } else {
                            chatlistsProvider.chatlistsView =
                                ChatlistsView.CHATVIEW;
                          }
                        });
                      },
                      icon: chatlistsProvider.chatlistsView ==
                              ChatlistsView.CHATVIEW
                          ? SvgPicture.asset(listViewIcon)
                          : Icon(Icons.chat_outlined)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (chatlistsProvider.chatlistsView !=
                            ChatlistsView.PERSONVIEW) {
                          chatlistsProvider.chatlistsView =
                              ChatlistsView.PERSONVIEW;
                        }
                      });
                    },
                    icon: chatlistsProvider.chatlistsView !=
                            ChatlistsView.PERSONVIEW
                        ? Icon(Icons.account_circle_outlined)
                        : Container(),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GenericField(
                isFilled: true,
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  return showSearch(
                      context: context, delegate: ChatSearchDelegate(pref));
                },
                prefixIcon: Icon(Icons.search),
                borderRaduis: 999,
                hintText: LocaleKeys.searchForChats.tr(),
                hintStyle:
                    TextStyles.textViewSemiBold14.copyWith(color: gunmetal),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child:
                  Consumer<ChatlistsProvider>(builder: (context, provider, _) {
                var allLists = provider.chatlists;
                // var allLists = [];
                if (FirebaseAuth.instance.currentUser == null) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        chatlistBackground,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          50.ph,
                          DottedContainer(text: "Sign In to Use Chatlists"),
                          SizedBox(
                            height: 100.h,
                          ),
                          GenericButton(
                            borderRadius: BorderRadius.circular(6),
                            // borderColor: borderColor,
                            color: mainYellow,
                            height: 60.h,
                            width: 158.w,
                            onPressed: () => pushNewScreen(context, screen: RegisterScreen(),withNavBar: false),
                            child: Text(
                              LocaleKeys.signIn.tr(),
                              style: TextStyles.textViewSemiBold16
                                  .copyWith(color: white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                if (allLists.isEmpty) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        chatlistBackground,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          50.ph,
                          DottedContainer(text: LocaleKeys.startAChatlist.tr()),
                          SizedBox(
                            height: 45.h,
                          ),
                        ],
                      ),
                    ],
                  );
                }
                if (chatlistsProvider.chatlistsView == ChatlistsView.LISTVIEW) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: StaggeredGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 24.h,
                          crossAxisSpacing: 10,
                          children: allLists.map(
                            (chatlist) {
                              return GestureDetector(
                                  onTap: () => pushNewScreen(context,
                                      screen: ChatListViewScreen(
                                        // updateList: updateList,
                                        listId: chatlist.id,
                                        isListView: true,
                                      ),
                                      withNavBar: false),
                                  child: StoreListWidget(
                                      listId: chatlist.id,
                                      storeImagePath: chatlist.storeImageUrl,
                                      listName: chatlist.name));
                            },
                          ).toList()),
                    ),
                  );
                }
                if (chatlistsProvider.chatlistsView == ChatlistsView.CHATVIEW) {
                  log(allLists.first.totalPrice.toString());
                  return ListView.separated(
                      separatorBuilder: (ctx, i) => Divider(),
                      itemCount: allLists.length,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemBuilder: (ctx, i) {
                        return ChatCard(allLists, i);
                      });
                }
                //PERSONVIEW case
                return FutureBuilder(
                  future: chatlistsProvider.getAllFriends(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    List<FriendChatLists> friendsList = (snapshot.data ?? []);
                    return ListView.separated(
                        itemCount: friendsList.length,
                        separatorBuilder: (ctx, i) => Divider(),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemBuilder: (ctx, i) {
                          return InkWell(
                            onTap: () async {
                              List<ChatList> lists = [];

                              friendsList[i].chatlists.forEach((element) {
                                log(element.data().toString());
                                lists.add(ChatList(
                                    id: element.id,
                                    name: element.get("list_name"),
                                    storeName: element.get("storeName"),
                                    userIds: element.get("userIds"),
                                    totalPrice: element.get("total_price"),
                                    storeImageUrl: element.get("storeImageUrl"),
                                    itemLength: element.get("size"),
                                    lastMessage: element.get("last_message"),
                                    lastMessageDate:
                                        element.get("last_message_date"),
                                    lastMessageUserId:
                                        element.get("last_message_userId"),
                                    lastMessageUserName:
                                        element.get("last_message_userName")));
                              });
                              var user = UserInfo.UserContactInfo(
                                  phoneNumber: friendsList[i].phone,
                                  imageURL: friendsList[i].imageURL,
                                  name: friendsList[i].name,
                                  email: friendsList[i].email,
                                  id: friendsList[i].id);
                              AppNavigator.push(
                                  context: context,
                                  screen: ContactProfileScreen(
                                    lists: lists,
                                    user: user,
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  friendsList[i].imageURL.isEmpty
                                      ? SvgPicture.asset(
                                          peopleIcon,
                                          width: 35.w,
                                          height: 35.h,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              friendsList[i].imageURL),
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
                                        "${LocaleKeys.on.tr()}" +
                                            friendsList[i]
                                                .chatlists
                                                .length
                                                .toString() +
                                            " ${LocaleKeys.lists.tr()}",
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
    return FirebaseAuth.instance.currentUser == null
        ? Container()
        : GenericButton(
            width: 60,
            height: 60,
            onPressed: () async {
              AppNavigator.push(context: context, screen: NewChatlistScreen());
            },
            color: yellow,
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(20),
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 50,
            ),
          );
  }
}

class FriendChatLists {
  String name;
  String imageURL;
  String email;
  String id;
  String phone;
  List<QueryDocumentSnapshot> chatlists;

  FriendChatLists(
      {required this.imageURL,
      required this.name,
      required this.id,
      required this.phone,
      required this.chatlists,
      required this.email});
}
