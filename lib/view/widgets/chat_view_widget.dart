import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/models/product_category.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/view/components/draggable_list.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/screens/categories_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

import '../../providers/products_provider.dart';
import 'discountItem.dart';
import 'message_bubble.dart';

class ChatView extends StatefulWidget {
  final String listId;
  ChatView({Key? key, required this.listId}) : super(key: key);

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

  @override
  void initState() {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    // FirebaseMessaging.onMessage.listen((message) {
    //   print("onMessage: " + message.data.entries.toList().toString());
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print("onMessageOpenedApp: " + message.toString());
    // });
    // FirebaseMessaging.onBackgroundMessage((message) async {
    //   print("onBackgroundMessage: " + message.toString());
    // });
    fbm.subscribeToTopic(widget.listId);
    super.initState();
  }

  String getTotalListPrice(List items) {
    var total = 0.0;
    for (var item in items) {
      try {
        total += item['item_price'].runtimeType == String
            ? double.parse(item['item_price'])
            : item['item_price'] ?? 99999;
      } catch (e) {
        total += 0.0;
      }
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(chatlistBackground))),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
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
                    return Container(
                      margin: EdgeInsets.only(top: 100.h),
                      alignment: Alignment.topCenter,
                      child: DottedContainer(
                        text: LocaleKeys.startChatting.tr(),
                      ),
                    );
                  }
                  return ListView.builder(
                      padding: EdgeInsets.only(bottom: 300, top: 50),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (ctx, index) => Container(
                            padding: const EdgeInsets.all(8.0),
                            child: MessageBubble(
                              itemName: messages[index]['item_name'],
                              itemSize: messages[index]['item_description'],
                              itemPrice:
                                  messages[index]['item_price'].toString(),
                              itemOldPrice:
                                  messages[index]['item_oldPrice'] ?? "0.0",
                              itemImage: messages[index]['item_image'],
                              storeName: messages[index]['store_name'],
                              isMe: messages[index]['userId'] ==
                                  FirebaseAuth.instance.currentUser!.uid,
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
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("/lists/${widget.listId}/items")
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  final items = snapshot.data?.docs ?? [];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (items.isEmpty) {
                    return Container();
                  }
                  return Container(
                    height: isExpandingChatlist ? 400.h : 60.h,
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
                            Text(
                              LocaleKeys.chatlist.tr(),
                              style: TextStylesInter.textViewBold12
                                  .copyWith(color: black2),
                            ),
                            Spacer(),
                            Text(
                              "${items.length} items",
                              style: TextStyles.textViewMedium10.copyWith(
                                  color: Color.fromRGBO(204, 204, 203, 1)),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              LocaleKeys.total.tr(),
                              style: TextStyles.textViewMedium15
                                  .copyWith(color: black2),
                            ),
                            10.pw,
                            Text(
                              "€ " + getTotalListPrice(items),
                              style: TextStyles.textViewBold15
                                  .copyWith(color: prussian),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    isExpandingChatlist = !isExpandingChatlist;
                                  });
                                },
                                icon: isExpandingChatlist
                                    ? Icon(
                                        Icons.keyboard_arrow_up,
                                        color: mainPurple,
                                        size: 30.sp,
                                      )
                                    : Icon(
                                        Icons.keyboard_arrow_down,
                                        color: mainPurple,
                                        size: 30.sp,
                                      )),
                          ],
                        ),
                        if (isExpandingChatlist)
                          Flexible(
                            child: DraggableList(
                              items: items,
                              listId: widget.listId,
                              inChatView: true,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
      header: Container(
        margin: EdgeInsets.only(left: 170.w, top: 5),
        width: 50.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: Color.fromRGBO(121, 116, 126, 0.4),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      collapsed: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                5.ph,
                IconButton(
                  onPressed: () {
                    setState(() {
                      panelController.isPanelClosed
                          ? panelController.open()
                          : panelController.close();
                    });
                  },
                  icon: SvgPicture.asset(cartAdd),
                  iconSize: 40,
                ),
              ],
            ),
            Expanded(
                child: GenericField(
              controller: messageController,
              hintText: LocaleKeys.textHere.tr(),
              hintStyle:
                  TextStylesInter.textViewRegular14.copyWith(color: black2),
              onSubmitted: (_) async {
                await Provider.of<ChatlistsProvider>(context, listen: false)
                    .sendMessage(messageController.text.trim(), widget.listId);
                messageController.clear();
              },
              suffixIcon: GestureDetector(
                onTap: () async {
                  await Provider.of<ChatlistsProvider>(context, listen: false)
                      .sendMessage(
                          messageController.text.trim(), widget.listId);
                  messageController.clear();
                  FocusScope.of(context).unfocus();
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 9),
                  child: SvgPicture.asset(
                    send,
                  ),
                ),
              ),
              borderRaduis: 50,
              boxShadow: Utils.boxShadow[0],
            ))
          ],
        ),
      ),
      onPanelOpened: () {
        setState(() {
          isCollapsed = false;
        });
      },
      onPanelClosed: () {
        setState(() {
          isCollapsed = true;
        });
      },
      panel: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.ph,
              Opacity(
                opacity: isCollapsed ? 0 : 1,
                child: GenericField(
                  isFilled: true,
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    return showSearch(
                        context: context,
                        delegate: MySearchDelegate(pref, false));
                  },
                  prefixIcon: Icon(Icons.search),
                  borderRaduis: 999,
                  hintText: LocaleKeys.whatAreYouLookingFor.tr(),
                  hintStyle:
                      TextStyles.textViewSemiBold14.copyWith(color: gunmetal),
                ),
              ),
              10.ph,
              Consumer<ProductsProvider>(builder: (c, provider, _) {
                List<ProductCategory> categories = [];
                categories = provider.categories;
                return SizedBox(
                  height: ScreenUtil().screenHeight / 7,
                  child: categories.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: categories.map((element) {
                            return GestureDetector(
                              onTap: () => AppNavigator.pushReplacement(
                                  context: context,
                                  screen: CategoriesScreen(
                                    category: element.category,
                                  )),
                              child: SizedBox(
                                width: 71.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      element.image,
                                      width: 70.w,
                                      height: 70.h,
                                    ),
                                    Text(
                                      element.category,
                                      style: TextStyles.textViewMedium11
                                          .copyWith(color: gunmetal),
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList()),
                );
              }),
              5.ph,
              Text(
                LocaleKeys.latestBargains.tr(),
                style: TextStylesInter.textViewRegular13
                    .copyWith(color: mainPurple),
              ),
              6.ph,
              Container(
                height: 220.h,
                child: Consumer<ProductsProvider>(
                  builder: (ctx, provider, _) {
                    var comparisonProducts = provider.comparisonProducts;
                    if (comparisonProducts.isEmpty)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return ListView.builder(
                      itemCount: comparisonProducts.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        return DiscountItem(
                          comparisonProduct: comparisonProducts[i],
                        );
                      },
                    );
                  },
                ),
              ),
              6.ph,
            ],
          ),
        ),
      ),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
    );
  }
}
