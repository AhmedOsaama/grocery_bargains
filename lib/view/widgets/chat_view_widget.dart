import 'dart:convert';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/chatlists/presentation/views/widgets/chatlist_overview_widget.dart';
import 'package:bargainb/features/chatlists/presentation/views/widgets/first_time_empty_list_widget.dart';
import 'package:bargainb/features/chatlists/presentation/views/widgets/quick_item_text_field.dart';
import 'package:bargainb/models/product_category.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/down_triangle_painter.dart';
import 'package:bargainb/utils/tooltips_keys.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/components/close_button.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/screens/category_screen.dart';
import 'package:bargainb/view/screens/home_screen.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/widgets/chatlist_item.dart';
import 'package:bargainb/view/widgets/product_dialog.dart';
import 'package:bargainb/view/widgets/quantity_counter.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/utils/utils.dart';
import 'package:bargainb/view/components/dotted_container.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';

import '../../features/chatlists/presentation/views/widgets/add_friends_widget.dart';
import '../../features/chatlists/presentation/views/widgets/empty_list_widget.dart';
import '../../features/chatlists/presentation/views/widgets/itemListWidget.dart';
import '../../models/list_item.dart';
import '../../providers/products_provider.dart';
import '../../providers/tutorial_provider.dart';
import '../../utils/tracking_utils.dart';
import 'discountItem.dart';
import 'message_bubble.dart';

class ChatView extends StatefulWidget {
  final String listId;
  final String chatlistName;
  final Function showInviteMembersDialog;
  final bool? isExpandingChatlist;

  ChatView(
      {Key? key,
      required this.listId,
      required this.showInviteMembersDialog,
      this.isExpandingChatlist,
      required this.chatlistName})
      : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool isAddingItem = false;
  late Future<int> getAllProductsFuture;
  late Stream<QuerySnapshot<Object>> chatStream;
  late Stream<QuerySnapshot<Object>> chatlistItemsStream;
  var messageController = TextEditingController();
  var pageController = PageController();
  List allProducts = [];
  var isLoading = false;
  var isCollapsed = true;
  List albertItems = [];
  List jumboItems = [];
  List hoogvlietItems = [];
  List dirkItems = [];
  List quicklyAddedItems = [];
  TextEditingController quickItemController = TextEditingController();
  bool isFirstTimeChatlist = false;
  var pageNumber = 0;

  Future getFirstTimeChatlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   isFirstTimeChatlist = true;
    // });
    if (prefs.containsKey('firstTimeChatlist')) {
      setState(() {
        isFirstTimeChatlist = prefs.getBool("firstTimeChatlist") ?? true;
      });
    } else {
      prefs.setBool('firstTimeChatlist', true);
      setState(() {
        isFirstTimeChatlist = true;
      });
    }
  }

  Future turnOffFirstTimeChatlist() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('firstTimeChatlist', false);
    // setState(() {
    //   isFirstTimeChatlist = false;
    // });
    print('turned off first time');
  }

  @override
  void dispose() {
    if (isFirstTimeChatlist) turnOffFirstTimeChatlist();
    super.dispose();
  }

  @override
  void initState() {
    getFirstTimeChatlist();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.subscribeToTopic(widget.listId);
    chatStream = FirebaseFirestore.instance
        .collection("/lists/${widget.listId}/messages")
        .orderBy('createdAt', descending: true)
        .snapshots();
    chatlistItemsStream =
        FirebaseFirestore.instance.collection("/lists/${widget.listId}/items").orderBy('time').snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tutorialProvider = Provider.of<TutorialProvider>(context);
    return ShowCaseWidget(
      builder: Builder(builder: (ctx) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (tutorialProvider.isTutorialRunning) {
            ShowCaseWidget.of(ctx).startShowCase([TooltipKeys.showCase6]);
          }
        });
        return Stack(
          children: [
            if (tutorialProvider.isTutorialRunning) ...buildChatTutorial(ctx, tutorialProvider),
            if (!tutorialProvider.isTutorialRunning)
              StreamBuilder<QuerySnapshot>(
                  stream: chatlistItemsStream,
                  builder: (context, snapshot) {
                    final items = snapshot.data?.docs ?? [];
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: pageController,
                            onPageChanged: (page) {
                              setState(() {
                                pageNumber = page;
                              });
                            },
                            children: [
                              buildChatView(items),
                              buildListView(items, context),
                            ],
                          ),
                        ),
                        // 20.ph,
                      ],
                    );
                  }),
          ],
        );
      }),
    );
  }

  List<Widget> buildChatTutorial(BuildContext ctx, TutorialProvider tutorialProvider) {
    return [
            Container(
              decoration: BoxDecoration(color: Color.fromRGBO(25, 27, 38, 0.6)),
            ),
            Column(
              children: [
                Container(
                  // height: 55.h,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: Utils.boxShadow,
                  ),
                  child: Row(
                    children: [
                      Text.rich(TextSpan(
                          text: "${LocaleKeys.chatlist.tr()} ",
                          style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                          children: [
                            TextSpan(
                                text: "9 items",
                                style: TextStylesInter.textViewBold12.copyWith(color: blackSecondary))
                          ])),
                      15.pw,
                      Text.rich(TextSpan(
                          text: "${LocaleKeys.total.tr()} ",
                          style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                          children: [
                            TextSpan(
                                text: "€17.32", style: TextStylesInter.textViewBold12.copyWith(color: mainPurple))
                          ])),
                      15.pw,
                      Text.rich(TextSpan(
                          text: "${LocaleKeys.savings.tr()} ",
                          style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                          children: [
                            TextSpan(
                                text: "€4.32", style: TextStylesInter.textViewBold12.copyWith(color: greenSecondary))
                          ])),
                      Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: mainPurple,
                            size: 45.sp,
                          )),
                    ],
                  ), //TODO: duplicate
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      MessageBubble(
                          itemName: "",
                          itemImage: "",
                          userName: "Ahmed",
                          userImage:
                              "https://wac-cdn.atlassian.com/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg?cdnVersion=1084",
                          isMe: false,
                          message: "Hey I made the grocery list, check it out.",
                          isAddedToList: false,
                          itemPrice: "",
                          itemOldPrice: "",
                          itemSize: "",
                          storeName: "",
                          userId: "",
                          itemId: -1,
                          itemBrand: "",
                          itemQuantity: 0),
                      MessageBubble(
                          itemName: "",
                          itemImage: "",
                          userName: "Ahmed",
                          userImage: "https://www.himalmag.com/wp-content/uploads/2019/07/sample-profile-picture.png",
                          isMe: true,
                          message: "okay",
                          isAddedToList: false,
                          itemPrice: "",
                          itemOldPrice: "",
                          itemSize: "",
                          storeName: "",
                          userId: "",
                          itemId: -1,
                          itemBrand: "",
                          itemQuantity: 0),
                      MessageBubble(
                          itemName: "",
                          itemImage: "",
                          userName: "Ahmed",
                          userImage:
                              "https://wac-cdn.atlassian.com/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg?cdnVersion=1084",
                          isMe: false,
                          message: "Can you add butter to the list ?",
                          isAddedToList: false,
                          itemPrice: "",
                          itemOldPrice: "",
                          itemSize: "",
                          storeName: "",
                          userId: "",
                          itemId: -1,
                          itemBrand: "",
                          itemQuantity: 0),
                      MessageBubble(
                          itemName: "Spreadable Blend of Butter & Rapeseed Oil",
                          itemImage:
                              "https://images.arla.com/recordid/520C13F1-C489-4BBC-9590546669B7C3FE/picture.png?width=1200&height=630",
                          userName: "Ahmed",
                          userImage: "https://www.himalmag.com/wp-content/uploads/2019/07/sample-profile-picture.png",
                          isMe: true,
                          message: "",
                          isAddedToList: true,
                          itemPrice: "2.20",
                          itemOldPrice: "3.20",
                          itemSize: "500g",
                          storeName: "Albert",
                          userId: "",
                          itemId: 2,
                          itemBrand: "Lurpak",
                          itemQuantity: 1),
                      MessageBubble(
                          itemName: "",
                          itemImage: "",
                          userName: "Ahmed",
                          userImage:
                              "https://wac-cdn.atlassian.com/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg?cdnVersion=1084",
                          isMe: false,
                          message: "Anything else not on the list ?",
                          isAddedToList: false,
                          itemPrice: "",
                          itemOldPrice: "",
                          itemSize: "",
                          storeName: "",
                          userId: "",
                          itemId: -1,
                          itemBrand: "",
                          itemQuantity: 0),
                      MessageBubble(
                          itemName: "",
                          itemImage: "",
                          userName: "Ahmed",
                          userImage: "https://www.himalmag.com/wp-content/uploads/2019/07/sample-profile-picture.png",
                          isMe: true,
                          message: "Stop by at the dry cleaners to pick up clothes",
                          isAddedToList: true,
                          itemPrice: "",
                          itemOldPrice: "",
                          itemSize: "",
                          storeName: "",
                          userId: "",
                          itemId: -1,
                          itemBrand: "",
                          itemQuantity: 0),
                      ShowCaseWidget(
                        builder: Builder(builder: (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(left: 30),
                                width: 300.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: purple70,
                                ),
                                child: Column(children: [
                                  Text(
                                    LocaleKeys.shareGroceriesToChat.tr(),
                                    maxLines: 5,
                                    style: TextStyles.textViewRegular13.copyWith(color: white),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ShowCaseWidget.of(context).dismiss();
                                      widget.showInviteMembersDialog(context);
                                      ShowCaseWidget.of(ctx).next();
                                    },
                                    child: Row(
                                      children: [
                                        SkipTutorialButton(tutorialProvider: tutorialProvider, context: ctx),
                                        Spacer(),
                                        Text(
                                          LocaleKeys.next.tr(),
                                          style: TextStyles.textViewSemiBold14.copyWith(color: white),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: white,
                                          size: 15.sp,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ];
  }

  Consumer<ChatlistsProvider> buildListView(List<QueryDocumentSnapshot<Object?>> items, BuildContext context) {
    return Consumer<ChatlistsProvider>(
        builder: (ctx, chatlistProvider, _) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: Utils.boxShadow,
              ),
              child: Column(
                children: [
                  ChatlistOverviewWidget(
                    items: items,
                    isFirstTimeChatlist: isFirstTimeChatlist,
                    pageController: pageController,
                    pageNumber: pageNumber,
                  ),
                  Builder(builder: (ctx) {
                    if (isFirstTimeChatlist && items.isEmpty) return buildFirstTimeEmptyListWidget();
                    if (!isFirstTimeChatlist && items.isEmpty) //not first time case and items are empty
                      return buildEmptyListWidget();
                    return buildItemList(context, items);      //default case: items are not empty
                  }),
                ],
              ),
            ));
  }

  EmptyListWidget buildEmptyListWidget() {
    return EmptyListWidget(quickItemController: quickItemController, widget: widget);
  }

  FirstTimeEmptyListWidget buildFirstTimeEmptyListWidget() {
  return FirstTimeEmptyListWidget(quickItemController: quickItemController, listId: widget.listId);
  }

  ItemListWidget buildItemList(BuildContext context, List<QueryDocumentSnapshot> items) {
    clearAllStoreLists();
    populateStoreLists(items);
    return ItemListWidget(quicklyAddedItems: quicklyAddedItems, quickItemController: quickItemController, widget: widget, albertItems: albertItems, jumboItems: jumboItems, hoogvlietItems: hoogvlietItems, dirkItems: dirkItems);
  }

  void populateStoreLists(List<QueryDocumentSnapshot<Object?>> items) {
    for (var item in items) {
      if (item['store_name'] == "Albert") {
        albertItems.add(item);
      }
      if (item['store_name'] == "Jumbo") {
        jumboItems.add(item);
      }
      if (item['store_name'] == "Hoogvliet") {
        hoogvlietItems.add(item);
      }
      if (item['store_name'] == "Dirk") {
        dirkItems.add(item);
      }
      if (item['store_name'].isEmpty) {
        quicklyAddedItems.add(item);
      }
    }
  }

  void clearAllStoreLists() {
    albertItems.clear();
    jumboItems.clear();
    hoogvlietItems.clear();
    dirkItems.clear();
    quicklyAddedItems.clear();
  }

  StreamBuilder<QuerySnapshot<Object?>> buildChatView(List<QueryDocumentSnapshot<Object?>> items) {
    return StreamBuilder<QuerySnapshot>(
        stream: chatStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data?.docs ?? [];
          return Column(
            children: [
              ChatlistOverviewWidget(
                items: items,
                isFirstTimeChatlist: isFirstTimeChatlist,
                pageController: pageController,
                pageNumber: pageNumber,
              ),
              (messages.isEmpty || !snapshot.hasData)
                  ? Expanded(
                      child: AddFriendsWidget(
                      showInviteDialog: widget.showInviteMembersDialog,
                    ))
                  : Expanded(
                      child: ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (ctx, index) => Container(
                                padding: const EdgeInsets.all(8.0),
                                child: MessageBubble(
                                  itemId: (messages[index].data()! as Map).containsKey('item_id')
                                      ? messages[index]['item_id']
                                      : -1,
                                  itemBrand: (messages[index].data()! as Map).containsKey('item_brand')
                                      ? messages[index]['item_brand']
                                      : "",
                                  itemQuantity: (messages[index].data()! as Map).containsKey('item_quantity')
                                      ? messages[index]['item_quantity']
                                      : 0,
                                  itemSize: (messages[index].data()! as Map).containsKey('item_size')
                                      ? messages[index]['item_size']
                                      : "",
                                  itemName: messages[index]['item_name'],
                                  itemPrice: messages[index]['item_price'].toString(),
                                  itemOldPrice: messages[index]['item_oldPrice'] ?? "0.0",
                                  itemImage: messages[index]['item_image'],
                                  storeName: messages[index]['store_name'] ?? "",
                                  isMe: messages[index]['userId'] == FirebaseAuth.instance.currentUser!.uid,
                                  message: messages[index]['message'],
                                  messageDocPath: messages[index].reference,
                                  userName: messages[index]['username'],
                                  userId: messages[index]['userId'],
                                  userImage: messages[index]['userImageURL'],
                                  key: ValueKey(messages[index].id),
                                  isAddedToList: messages[index]['isAddedToList'],
                                ),
                              )),
                    ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    SvgPicture.asset(chatbot),
                    5.pw,
                    Expanded(
                      child: GenericField(
                        controller: messageController,
                        hintText: LocaleKeys.textHere.tr(),
                        hintStyle: TextStylesInter.textViewRegular14.copyWith(color: hintText),
                        contentPadding: EdgeInsets.only(left: 10),
                        borderRaduis: 99999,
                        onSubmitted: (_) async {
                          await submitMessage(context);
                        },
                      ),
                    ),
                    5.pw,
                    GestureDetector(
                      onTap: () async {
                        await submitMessage(context);
                        FocusScope.of(context).unfocus();
                      },
                      child: SvgPicture.asset(
                        send,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future<void> submitMessage(BuildContext context) async {
    var text = messageController.text.trim();
    if (['@BargainB', '@Bargainb', '@bargainb', '@bb', '@BB'].any((element) => text.startsWith(element))) {
      messageController.clear();
      // var question = text.replaceFirst('@BargainB', '');
      await Provider.of<ChatlistsProvider>(context, listen: false)
          .sendMessage(text, widget.listId, widget.chatlistName, "messages");
      var chatbotResponse = await get(Uri.parse(
          'https://us-central1-discountly.cloudfunctions.net/getChatbot?question=${text}&listId=${widget.listId}&collectionName=messages'));
      // setState(() {
      //   // chatStream = FirebaseFirestore.instance
      //   //     .collection("/lists/${widget.listId}/bot_messages")
      //   //     .orderBy('createdAt', descending: true)
      //   //     .snapshots();
      //   isBotChat = true;
      // });
    } else {
      messageController.clear();
      FirebaseMessaging.instance.unsubscribeFromTopic(widget.listId);
      await Provider.of<ChatlistsProvider>(context, listen: false)
          .sendMessage(text, widget.listId, widget.chatlistName, "messages");
      Future.delayed(Duration(seconds: 5), () {
        FirebaseMessaging.instance.subscribeToTopic(widget.listId);
      });
    }
    // if (isBotChat) {

    // var decodedResponse = jsonDecode(chatbotResponse.body);
    // print(decodedResponse);
    // var response = await post(Uri.parse('https://www.chatbase.co/api/v1/chat'),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Authorization': 'Bearer 5b0c8ad5-1ade-40e0-b757-d8c6d36cac86'
    //     },
    //     body: jsonEncode({
    //       'messages': [
    //         // { 'content': 'How can I help you?', 'role': 'assistant' },
    //         { 'content': '${text}', 'role': 'user' }
    //       ],
    //       'chatbotId': 'gpTwLMcc0OLmFzISyB5nQ',
    //       'stream': false,
    //       'model': 'gpt-3.5-turbo',
    //       'temperature': 0
    // }));
    // var decodedResponse = jsonDecode(response.body);
    // if(response.statusCode == 200) print('CHATBOT RESPONSE: ${response.body}');
    // else print(response);
    // Provider.of<ChatlistsProvider>(context, listen: false)
    //     .sendMessage(decodedResponse['text'], widget.listId, widget.chatlistName, "bot_messages");
    // }
  }


  List<Widget> getItemsPlaceholder() {
    return List.generate(
        3,
        (index) => Row(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: purple30,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SvgPicture.asset(
                    cheese,
                    width: 27,
                    height: 27,
                  ),
                ),
                10.pw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75.w,
                      height: 10.h,
                      decoration: BoxDecoration(color: purple50, borderRadius: BorderRadius.circular(6)),
                    ),
                    5.ph,
                    Container(
                      width: 220.w,
                      height: 8.h,
                      decoration: BoxDecoration(color: purple10, borderRadius: BorderRadius.circular(6)),
                    ),
                    5.ph,
                    Container(
                      width: 220.w,
                      height: 8.h,
                      decoration: BoxDecoration(color: purple10, borderRadius: BorderRadius.circular(6)),
                    ),
                  ],
                ),
                Spacer(),
                Text("€ 1.25"),
              ],
            ));
  }
}


