import 'dart:convert';
import 'dart:developer';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/chatlists/presentation/views/widgets/chatlist_overview_widget.dart';
import 'package:bargainb/features/chatlists/presentation/views/widgets/first_time_empty_list_widget.dart';
import 'package:bargainb/features/chatlists/presentation/views/widgets/quick_item_text_field.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/second_onboarding.dart';
import 'package:bargainb/features/home/data/models/product_category.dart';
import 'package:bargainb/providers/user_provider.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/down_triangle_painter.dart';
import 'package:bargainb/utils/tooltips_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/utils/utils.dart';
import 'package:bargainb/view/components/dotted_container.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';

import 'add_friends_widget.dart';
import 'empty_list_widget.dart';
import 'itemListWidget.dart';
import '../../../../../models/list_item.dart';
import '../../../../../providers/products_provider.dart';
import '../../../../../providers/tutorial_provider.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../../utils/triangle_painter.dart';
import '../../../../../view/widgets/discountItem.dart';
import '../../../../../view/widgets/message_bubble.dart';

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
      required this.chatlistName,
      required this.showcaseContext})
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
  var pageNumber = 0;

  bool isBotLoading = false;


  Future turnOffFirstTimeChatlist() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('firstTimeChatlist', false);
    print('turned off first time');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getOnboardingStore();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.subscribeToTopic(widget.listId);
    chatStream = FirebaseFirestore.instance
        .collection("/lists/${widget.listId}/messages")
        .orderBy('createdAt', descending: true)
        .snapshots();
    chatlistItemsStream =
        FirebaseFirestore.instance.collection("/lists/${widget.listId}/items")
            .orderBy('time')
    .snapshots();

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
                    pageController: pageController,
                    pageNumber: pageNumber,
                  ),
                  Builder(builder: (ctx) {
                    return buildItemList(context, items); //default case: items are not empty
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
    return ItemListWidget(
        quicklyAddedItems: quicklyAddedItems,
        quickItemController: quickItemController,
        widget: widget,
        albertItems: albertItems,
        jumboItems: jumboItems,
        hoogvlietItems: hoogvlietItems,
        dirkItems: dirkItems);
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

  StreamBuilder<QuerySnapshot<Object?>> buildChatView(
      List<QueryDocumentSnapshot<Object?>> items, BuildContext showcaseContext) {
    var tutorialProvider = Provider.of<TutorialProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
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
              if (isBotLoading)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      bee1,
                      width: 30,
                      height: 30,
                    ),
                    Container(
                      // width: message.length > 30 ? MediaQuery.of(context).size.width * 0.6 : null,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(18),
                            topLeft: const Radius.circular(18),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(18),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x263463ED),
                              blurRadius: 28,
                              offset: Offset(0, 10),
                              spreadRadius: 0,
                            )
                          ]),
                      child: Image.asset(
                        loadingIndicator,
                        width: 30,
                      ),
                    ),
                  ],
                ),
              Showcase.withWidget(
                height: 120,
                width: 200.w,
                disableDefaultTargetGestures: true,
                targetBorderRadius: BorderRadius.circular(10),
                key:
                    tutorialProvider.isTutorialRunning ? TooltipKeys.showCase6 : new GlobalKey<State<StatefulWidget>>(),
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
                        child: Column(children: [
                          Text(
                            "Let's activate your AI sidekick! Invite friends and family to chat with your BargainB sidekick. Type @BB or @bargainb to ask questions, get personalized advice, and find the best deals. Type @BB Show me the Top Deal from"
                                    .tr() +
                                "${userProvider.onboardingStore}",
                            // maxLines: 4,
                            style: TextStyles.textViewRegular13.copyWith(color: white),
                          ),
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
                      Expanded(
                        child: GenericField(
                          controller: messageController,
                          hintText: LocaleKeys.textHere.tr(),
                          hintStyle: TextStylesInter.textViewRegular14.copyWith(color: hintText),
                          contentPadding: EdgeInsets.only(left: 10),
                          borderRaduis: 99999,
                          onSubmitted: (_) async {
                            ShowCaseWidget.of(showcaseContext).dismiss();
                            await submitMessage(context);
                            finishTutorial(tutorialProvider, showcaseContext);
                          },
                        ),
                      ),
                      5.pw,
                      GestureDetector(
                        onTap: () async {
                          ShowCaseWidget.of(showcaseContext).dismiss();
                          await submitMessage(context);
                          finishTutorial(tutorialProvider, showcaseContext);
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

  Future<void> finishTutorial(TutorialProvider tutorialProvider, BuildContext showcaseContext) async {
    if (tutorialProvider.isTutorialRunning) {
      ShowCaseWidget.of(showcaseContext).dismiss();
      await Future.delayed(Duration(seconds: 1));
      tutorialProvider.stopTutorial(showcaseContext);
    }
  }

  Future<void> submitMessage(BuildContext context) async {
    var text = messageController.text.trim();
    var prompt = "@bb";
    if (['@BargainB', '@Bargainb', '@bargainb', '@bb', '@BB'].any((element) {
      prompt = element;
      return text.contains(element);
    })) {
      messageController.clear();
      await Provider.of<ChatlistsProvider>(context, listen: false)
          .sendMessage(text, widget.listId, widget.chatlistName, "messages");
      text = text.replaceFirst(prompt, "");
      setState(() {
        isBotLoading = true;
      });
      var response = await post(Uri.parse("https://yswessi.pythonanywhere.com/chat"), headers: {
        "Content-Type": "application/json"
      }, body: json.encode({
        "input": text
      },));
      var botResponse = jsonDecode(response.body)['output'];
      await FirebaseFirestore.instance.collection('/lists/${widget.listId}/messages').add({
        'item_name': "",
        'item_image': "",
        'item_description': "",
        'store_name': "",
        'isAddedToList': false,
        'item_price': 0.0,
        'item_oldPrice': "",
        'message': botResponse,
        'createdAt': Timestamp.fromDate(DateTime.now().toUtc()),
        'userId': "bargainb",
        'username': "BargainB",
        'userImageURL': '',
      });
      setState(() {
        isBotLoading = false;
      });
    } else {
      messageController.clear();
      FirebaseMessaging.instance.unsubscribeFromTopic(widget.listId);
      await Provider.of<ChatlistsProvider>(context, listen: false)
          .sendMessage(text, widget.listId, widget.chatlistName, "messages");
      Future.delayed(Duration(seconds: 5), () {
        FirebaseMessaging.instance.subscribeToTopic(widget.listId);
      });
    }
  }
}
