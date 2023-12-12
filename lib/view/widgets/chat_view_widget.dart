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
import '../../utils/triangle_painter.dart';
import 'discountItem.dart';
import 'message_bubble.dart';

class ChatView extends StatefulWidget {
  final String listId;
  final String chatlistName;
  final Function showInviteMembersDialog;
  final bool? isExpandingChatlist;
  final BuildContext showcaseContext;

  ChatView(
      {Key? key,
      required this.listId,
      required this.showInviteMembersDialog,
      this.isExpandingChatlist,
      required this.chatlistName, required this.showcaseContext})
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
        return StreamBuilder<QuerySnapshot>(
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
                        buildChatView(items, widget.showcaseContext),
                        buildListView(items, context),
                      ],
                    ),
                  ),
                  // 20.ph,
                ],
              );
            });
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

  StreamBuilder<QuerySnapshot<Object?>> buildChatView(List<QueryDocumentSnapshot<Object?>> items, BuildContext showcaseContext) {
    var tutorialProvider = Provider.of<TutorialProvider>(context);
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
              Showcase.withWidget(
                height: 120,
                width: 200.w,
                disableDefaultTargetGestures: true,
                targetBorderRadius: BorderRadius.circular(10),
                key: tutorialProvider.isTutorialRunning ? TooltipKeys.showCase6 : new GlobalKey<State<StatefulWidget>>(),
                tooltipPosition: TooltipPosition.top,
                container: Container(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: 300.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: purple70,
                        ),
                        child: Column(
                            children: [
                              Text(
                                "Let's activate your AI sidekick!"
                                    " Invite friends and family to chat with your BargainB sidekick."
                                    " Type @BB or @bargainb to ask questions, get personalized advice, and find the best deals."
                                    " Type @BB Show me the Top Deal from {preferred store}".tr(),
                                // maxLines: 4,
                                style: TextStyles.textViewRegular13.copyWith(color: white),
                              ),
                              SkipTutorialButton(tutorialProvider: tutorialProvider, context: showcaseContext)
                            ]),
                      ),
                      Container(
                        height: 11,
                        width: 13,
                        child: CustomPaint(
                          painter: DownTrianglePainter(
                            strokeColor: purple70,
                            strokeWidth: 1,
                            paintingStyle: PaintingStyle.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                child: Padding(
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
                            submitMessage(context);
                            if(tutorialProvider.isTutorialRunning){
                              ShowCaseWidget.of(context).dismiss();
                              await Future.delayed(Duration(seconds: 3));
                              tutorialProvider.stopTutorial(context);
                            }
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
              ),
            ],
          );
        });
  }

  Future<void> submitMessage(BuildContext context) async {
    var text = messageController.text.trim();
    if (['@BargainB', '@Bargainb', '@bargainb', '@bb', '@BB'].any((element) => text.startsWith(element))) {
      messageController.clear();
      await Provider.of<ChatlistsProvider>(context, listen: false)
          .sendMessage(text, widget.listId, widget.chatlistName, "messages");
      // var chatbotResponse = await get(Uri.parse(
      //     'https://us-central1-discountly.cloudfunctions.net/getChatbot?question=${text}&listId=${widget.listId}&collectionName=messages'));
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


