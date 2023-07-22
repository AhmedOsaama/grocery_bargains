import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/models/product_category.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/down_triangle_painter.dart';
import 'package:bargainb/utils/tooltips_keys.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/components/close_button.dart';
import 'package:bargainb/view/components/draggable_list.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/screens/category_screen.dart';
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
import 'package:bargainb/view/screens/profile_screen.dart';

import '../../models/list_item.dart';
import '../../providers/products_provider.dart';
import '../../utils/tracking_utils.dart';
import 'discountItem.dart';
import 'message_bubble.dart';

class ChatView extends StatefulWidget {
  final String listId;
  final Function showInviteMembersDialog;
  final bool? isExpandingChatlist;

  ChatView({Key? key, required this.listId, required this.showInviteMembersDialog, this.isExpandingChatlist}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool isAddingItem = false;
  late Future<int> getAllProductsFuture;
  var messageController = TextEditingController();
  var panelController = PanelController();
  List allProducts = [];
  var isLoading = false;
  var isCollapsed = true;
  var isExpandingChatlist = false;
  bool isFirstTime = false;

  List albertItems = [];
  List jumboItems = [];
  List hoogvlietItems = [];
  List quicklyAddedItems = [];

  TextEditingController quickItemController = TextEditingController();

  @override
  void initState() {
    getFirstTime();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.subscribeToTopic(widget.listId);
    isExpandingChatlist = widget.isExpandingChatlist ?? false;


    super.initState();
  }

  Future<Null> getFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstTime = prefs.getBool("firstTime") ?? true;
    });
  }

  Future<Null> turnOffFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("firstTime", false);
      isFirstTime = false;
    });
  }

  String getTotalListPrice(List items) {
    var total = 0.0;
    for (var item in items) {
      try {
        total +=
            item['item_price'].runtimeType == String ? double.parse(item['item_price']) : item['item_price'] ?? 99999;
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
        total += item['item_oldPrice'].runtimeType == String
            ? (double.parse(item['item_oldPrice']) - double.parse(item['item_price']))
            : (item['item_oldPrice'] - item['item_price']);
      } catch (e) {
        total += 0.0;
      }
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onStart: (_, p) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      },
      onFinish: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
          SystemUiOverlay.top,
          SystemUiOverlay.bottom,
        ]);
      },
      builder: Builder(builder: (ctx) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (isFirstTime) {
            ShowCaseWidget.of(ctx).startShowCase([TooltipKeys.showCase6]);
          }
        });
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Image.asset(
              chatlistBackground,
              fit: BoxFit.cover,
            ),
            Showcase.withWidget(
              height: 1.h,
              width: 380.w,
              key: isFirstTime ? TooltipKeys.showCase6 : new GlobalKey<State<StatefulWidget>>(),
              onTargetClick: () async => await turnOffFirstTime(),
              onBarrierClick: () async => await turnOffFirstTime(),
              onTargetDoubleTap: () async => await turnOffFirstTime(),
              tooltipPosition: TooltipPosition.top,
              targetBorderRadius: BorderRadius.circular(8),
              container: Container(
                // margin: EdgeInsets.only(top: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(left: 30),
                      width: 270.w,
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
                          onTap: () async {
                            // await turnOffFirstTime();
                            setState(() {
                              isFirstTime = false;
                            });
                            widget.showInviteMembersDialog(context);
                            ShowCaseWidget.of(ctx).next();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        150.pw,
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
                  ],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        isFirstTime
                            ? ListView(
                                children: [
                                  MessageBubble(
                                      itemName: "",
                                      itemImage: "",
                                      userName: "Ahmed",
                                      userImage: "https://wac-cdn.atlassian.com/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg?cdnVersion=1084",
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
                                      itemQuantity: 0),   MessageBubble(
                                      itemName: "",
                                      itemImage: "",
                                      userName: "Ahmed",
                                      userImage: "https://wac-cdn.atlassian.com/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg?cdnVersion=1084",
                                      isMe: false,
                                      message: "Hey, do we need butter?",
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
                                      message: "yes we do",
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
                                      userImage: "https://wac-cdn.atlassian.com/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg?cdnVersion=1084",
                                      isMe: false,
                                      message: "Can you add it to the list? i am not sure which one.",
                                      isAddedToList: false,
                                      itemPrice: "",
                                      itemOldPrice: "",
                                      itemSize: "",
                                      storeName: "",
                                      userId: "",
                                      itemId: -1,
                                      itemBrand: "",
                                      itemQuantity: 0),  MessageBubble(
                                      itemName: "",
                                      itemImage: "",
                                      userName: "Ahmed",
                                      userImage: "https://wac-cdn.atlassian.com/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg?cdnVersion=1084",
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
                                      itemName: "Spreadable Blend of Butter & Rapeseed Oil",
                                      itemImage: "https://images.arla.com/recordid/520C13F1-C489-4BBC-9590546669B7C3FE/picture.png?width=1200&height=630",
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

                                ],
                              )
                            : StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("/lists/${widget.listId}/messages")
                                    .orderBy('createdAt', descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  final messages = snapshot.data?.docs ?? [];
                                  if (messages.isEmpty || !snapshot.hasData) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(messagesPlaceholder,width: 170),
                                        15.ph,
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 40),
                                          child: Text(
                                            LocaleKeys.addYourFriendsAndFamily.tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStylesInter.textViewBold22.copyWith(color: blackSecondary, ),
                                          ),
                                        ),
                                        20.ph,
                                        GenericButton(
                                          onPressed: () => widget.showInviteMembersDialog(context),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(LocaleKeys.add.tr(), style: TextStyles.textViewSemiBold16.copyWith(color: Colors.white),),
                                                10.pw,
                                                SvgPicture.asset(
                                                  newperson,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                          color: brightOrange,
                                          borderRadius: BorderRadius.circular(6),
                                        )
                                      ],
                                    );
                                  }
                                  return ListView.builder(
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
                                              itemQuantity:
                                                  (messages[index].data()! as Map).containsKey('item_quantity')
                                                      ? messages[index]['item_quantity']
                                                      : 0,
                                              itemSize: (messages[index].data()! as Map).containsKey('item_size')
                                                  ? messages[index]['item_size']
                                                  : "",
                                              itemName: messages[index]['item_name'],
                                              // itemSize: messages[index]
                                              //     ['item_size'],
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
                                          ));
                                }),
                        Consumer<ChatlistsProvider>(
                          builder: (ctx,chatlistProvider,_) => StreamBuilder(
                              //chatlist header
                              stream: FirebaseFirestore.instance
                                  .collection("/lists/${widget.listId}/items")
                                  .orderBy('time')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                final items = snapshot.data?.docs ?? [];
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Container();
                                }
                                int height = 400;
                                switch (items.length) {
                                  case 1:
                                    height = 120;
                                    break;
                                  case 2:
                                    height = 200;
                                    break;
                                  case 3:
                                    height = 270;
                                    break;
                                  case 4:
                                    height = 350;
                                    break;
                                  default:
                                    height = 400;
                                }
                                return Container(
                                  height: isExpandingChatlist ? double.infinity : 55.h,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: Utils.boxShadow,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text.rich(TextSpan(
                                              text: "${LocaleKeys.chatlist.tr()} ",
                                              style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                                              children: [
                                                TextSpan(
                                                    text: isFirstTime ? "9 items" : " ${items.length} ${LocaleKeys.items.tr()}",
                                                    style: TextStylesInter.textViewBold12.copyWith(color: blackSecondary))
                                              ])),
                                          15.pw,
                                          Text.rich(TextSpan(
                                              text: "${LocaleKeys.total.tr()} ",
                                              style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                                              children: [
                                                TextSpan(
                                                    text: isFirstTime ? "€17.32" : " €${getTotalListPrice(items)}",
                                                    style: TextStylesInter.textViewBold12.copyWith(color: mainPurple))
                                              ])),
                                          15.pw,
                                          Text.rich(TextSpan(
                                              text: "${LocaleKeys.savings.tr()} ",
                                              style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                                              children: [
                                                TextSpan(
                                                    text: isFirstTime ? "€4.32" : " €${getTotalListSavings(items)}",
                                                    style: TextStylesInter.textViewBold12.copyWith(color: greenSecondary))
                                              ])),
                                          Spacer(),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isExpandingChatlist = !isExpandingChatlist;
                                                });
                                                TrackingUtils().trackChatlistAction(FirebaseAuth.instance.currentUser!.uid, "Expand/collapse chatlist items", DateTime.now().toUtc().toString());
                                              },
                                              icon: isExpandingChatlist
                                                  ? Icon(
                                                      Icons.keyboard_arrow_up,
                                                      color: mainPurple,
                                                      size: 45.sp,
                                                    )
                                                  : Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: mainPurple,
                                                      size: 45.sp,
                                                    )),
                                        ],
                                      ),
                                      if (isExpandingChatlist)
                                        Builder(builder: (ctx) {
                                          if (items.isEmpty)
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ...List.generate(
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
                                                                  decoration: BoxDecoration(
                                                                      color: purple50,
                                                                      borderRadius: BorderRadius.circular(6)),
                                                                ),
                                                                5.ph,
                                                                Container(
                                                                  width: 220.w,
                                                                  height: 8.h,
                                                                  decoration: BoxDecoration(
                                                                      color: purple10,
                                                                      borderRadius: BorderRadius.circular(6)),
                                                                ),
                                                                5.ph,
                                                                Container(
                                                                  width: 220.w,
                                                                  height: 8.h,
                                                                  decoration: BoxDecoration(
                                                                      color: purple10,
                                                                      borderRadius: BorderRadius.circular(6)),
                                                                ),
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            Text("€ 1.25"),
                                                          ],
                                                        )),
                                                10.ph,
                                                Text(
                                                  "Add your first item to your chatlist",
                                                  style:
                                                      TextStylesInter.textViewSemiBold20.copyWith(color: blackSecondary),
                                                ),
                                                15.ph,
                                                Text(
                                                  "Add items to your chatlist to see which supermarkets are cheapest",
                                                  style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                                                ),
                                                15.ph,
                                                GenericButton(
                                                    onPressed: () async {
                                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                                      return showSearch(
                                                          context: context, delegate: MySearchDelegate(pref: pref));
                                                    },
                                                    child: Text(LocaleKeys.addItem.tr()),
                                                    color: mainPurple,
                                                    borderRadius: BorderRadius.circular(6)),
                                              ],
                                            );
                                          albertItems.clear();
                                          jumboItems.clear();
                                          hoogvlietItems.clear();
                                          quicklyAddedItems.clear();
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
                                            if (item['store_name'].isEmpty) {
                                              quicklyAddedItems.add(item);
                                            }
                                          }
                                          return Flexible(
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                              children: [
                                                Column(
                                                  children: quicklyAddedItems.map((item) {
                                                    return ChatlistItem(item: item);
                                                  }).toList(),
                                                ),
                                                5.ph,
                                                GenericField(
                                                  controller: quickItemController,
                                                  onSubmitted: (value) {
                                                    Provider.of<ChatlistsProvider>(context, listen: false).addItemToList(
                                                        ListItem(
                                                            id: -1,
                                                            storeName: "",
                                                            imageURL: '',
                                                            isChecked: false,
                                                            name: value.trim(),
                                                            price: "0.0",
                                                            quantity: 0,
                                                            size: '',
                                                            text: value.trim(),
                                                            brand: ''),
                                                        widget.listId);
                                                    quickItemController.clear();
                                                  },
                                                  hintText: LocaleKeys.addSomethingQuickly.tr(),
                                                  contentPadding: EdgeInsets.only(left: 10),
                                                  hintStyle:
                                                      TextStylesInter.textViewRegular12.copyWith(color: blackSecondary),
                                                  fillColor: lightPurple,
                                                  suffixIcon: TextButton(
                                                    onPressed: () async {
                                                      await Provider.of<ChatlistsProvider>(context, listen: false)
                                                          .addItemToList(
                                                              ListItem(
                                                                  id: -1,
                                                                  storeName: "",
                                                                  imageURL: '',
                                                                  isChecked: false,
                                                                  name: quickItemController.text.trim(),
                                                                  price: "0.0",
                                                                  quantity: 0,
                                                                  size: '',
                                                                  text: quickItemController.text.trim(),
                                                                  brand: ''),
                                                              widget.listId);
                                                      quickItemController.clear();
                                                      TrackingUtils().trackChatlistAction(FirebaseAuth.instance.currentUser!.uid, "Add quick item", DateTime.now().toUtc().toString());
                                                    },
                                                    child: Text(
                                                      LocaleKeys.add.tr(),
                                                      style: TextStylesDMSans.textViewBold12.copyWith(color: mainPurple),
                                                    ),
                                                  ),
                                                ),
                                                15.ph,
                                                if (albertItems.isNotEmpty) ...[
                                                  Text(
                                                    "Albert Heijn",
                                                    style: TextStylesInter.textViewRegular16
                                                        .copyWith(color: Colors.lightBlue),
                                                  ),
                                                  5.ph,
                                                  Column(
                                                    children: albertItems.map((item) {
                                                      return ChatlistItem(item: item);
                                                    }).toList(),
                                                  ),
                                                ],
                                                if (jumboItems.isNotEmpty) ...[
                                                  Text(
                                                    "Jumbo",
                                                    style: TextStylesInter.textViewRegular16
                                                        .copyWith(color: Colors.lightBlue),
                                                  ),
                                                  5.ph,
                                                  Column(
                                                    children: jumboItems.map((item) {
                                                      return ChatlistItem(item: item);
                                                    }).toList(),
                                                  ),
                                                ],
                                                if (hoogvlietItems.isNotEmpty) ...[
                                                  Text(
                                                    "Hoogvliet",
                                                    style: TextStylesInter.textViewRegular16
                                                        .copyWith(color: Colors.lightBlue),
                                                  ),
                                                  5.ph,
                                                  Column(
                                                    children: hoogvlietItems.map((item) {
                                                      return ChatlistItem(item: item);
                                                    }).toList(),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          );
                                        }),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child:
                          // TextField(
                          //   decoration: InputDecoration(fillColor: Colors.white,
                          //     filled: true
                          //   ),
                          // ),
                          GenericField(
                            controller: messageController,
                            hintText: LocaleKeys.textHere.tr(),
                            hintStyle: TextStylesInter.textViewRegular14.copyWith(color: blackSecondary),
                            suffixIcon: Icon(
                              Icons.emoji_emotions_outlined,
                            ),
                            contentPadding: EdgeInsets.only(left: 10),
                            borderRaduis: 99999,
                            onSubmitted: (_) async {
                              await Provider.of<ChatlistsProvider>(context, listen: false)
                                  .sendMessage(messageController.text.trim(), widget.listId);
                              messageController.clear();
                            },
                          ),
                        ),
                        5.pw,
                        GestureDetector(
                          onTap: () async {
                            await Provider.of<ChatlistsProvider>(context, listen: false)
                                .sendMessage(messageController.text.trim(), widget.listId);
                            messageController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          child: SvgPicture.asset(
                            send,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 20.ph,
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

}
