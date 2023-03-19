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
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/models/list_item.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/utils/utils.dart';
import 'package:bargainb/view/components/dotted_container.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/components/generic_menu.dart';
import 'package:bargainb/view/components/my_scaffold.dart';
import 'package:bargainb/view/components/plus_button.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/screens/sub_categories_screen.dart';
import 'package:bargainb/view/widgets/backbutton.dart';

import '../../providers/products_provider.dart';
import '../screens/home_screen.dart';
import '../screens/product_detail_screen.dart';
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
    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
      return;
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      print(message);
    });
    fbm.subscribeToTopic('messages');
    super.initState();
  }


  @override
  void didChangeDependencies() {
    getAllProductsFuture =
        Provider.of<ProductsProvider>(context, listen: false).getProducts(0);
    super.didChangeDependencies();
  }

  String getTotalListPrice(List items) {
    var total = 0.0;
    for (var item in items) {
      try {
        total += item['item_price'].runtimeType == String ? double.parse(item['item_price']) : item['item_price'] ?? 99999;
      }catch(e){
        total += 0.0;
      }
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      body: Padding(
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
                      padding: EdgeInsets.only(bottom: 250,top: 50),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (ctx, index) => Container(
                            padding: const EdgeInsets.all(8.0),
                            child: MessageBubble(
                              itemName: messages[index]['item_name'],
                              itemSize: messages[index]['item_description'],
                              itemPrice: messages[index]['item_price'].toString(),
                              itemOldPrice: messages[index]['item_oldPrice'],
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
            Container(
              height: isExpandingChatlist ? 400.h : 60.h,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: Utils.boxShadow,
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("/lists/${widget.listId}/items")
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot){
                    final items = snapshot.data?.docs ?? [];
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container();
                    }
                    if(items.isEmpty){
                      return Container();
                    }
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(LocaleKeys.chatlist.tr(),style: TextStylesInter.textViewBold12.copyWith(color: black2),),
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
                            Text(" ${getTotalListPrice(items)}"),
                            SizedBox(
                              width: 10.w,
                            ),
                            IconButton(onPressed: (){
                              setState(() {
                                isExpandingChatlist = !isExpandingChatlist;
                              });
                            },icon: SvgPicture.asset(arrowDown)),
                          ],
                        ),
                        if(isExpandingChatlist)
                          Expanded(
                            child: ListView.separated(
                                itemCount: items.length,
                                separatorBuilder: (ctx, _) => const Divider(),
                                itemBuilder: (ctx, i) {
                                  var doc = items[i];
                                  var isChecked = items[i]['item_isChecked'];
                                  if (items[i]['text'] != '') {
                                    return Opacity(
                                      opacity: isChecked ? 0.6 : 1,
                                      child: Row(
                                        children: [
                                          // 30.pw,
                                          Checkbox(
                                            value: isChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                isChecked = !isChecked;
                                              });
                                              FirebaseFirestore.instance
                                                  .collection(
                                                  "/lists/${doc.reference.parent.parent?.id}/items")
                                                  .doc(doc.id)
                                                  .update({
                                                "item_isChecked": isChecked,
                                              }).catchError((e) {
                                                print(e);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "This operation couldn't be done please try again")));
                                              });
                                              // updateList();
                                            },
                                          ),
                                          Text(
                                            items[i]['text'],
                                            style: TextStylesInter
                                                .textViewRegular16
                                                .copyWith(color: black2),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  var itemName = items[i]['item_name'];
                                  var itemImage = items[i]['item_image'];
                                  var itemDescription = items[i]['item_size'];
                                  var itemPrice = items[i]['item_price'];
                                  return Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Opacity(
                                          opacity: isChecked ? 0.6 : 1,
                                          child: Row(
                                            children: [
                                              // 30.pw,
                                              Checkbox(
                                                value: isChecked,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isChecked = !isChecked;
                                                  });
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                      "/lists/${doc.reference.parent.parent?.id}/items")
                                                      .doc(doc.id)
                                                      .update({
                                                    "item_isChecked":
                                                    isChecked,
                                                  }).catchError((e) {
                                                    print(e);
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                "This operation couldn't be done please try again")));
                                                  });
                                                  // updateList();
                                                },
                                              ),
                                              Image.network(
                                                itemImage,
                                                width: 55,
                                                height: 55,
                                              ),
                                              SizedBox(
                                                width: 12.w,
                                              ),
                                              Container(
                                                width: 140.w,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      itemName,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: TextStyles
                                                          .textViewSemiBold14
                                                          .copyWith(
                                                          color: prussian,
                                                          decoration: isChecked
                                                              ? TextDecoration
                                                              .lineThrough
                                                              : null),
                                                    ),
                                                    Container(
                                                      width: 150.w,
                                                      child: Text(
                                                        "$itemDescription",
                                                        style: TextStyles
                                                            .textViewLight12
                                                            .copyWith(
                                                            color:
                                                            prussian,
                                                            decoration: isChecked
                                                                ? TextDecoration
                                                                .lineThrough
                                                                : null),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                "€ $itemPrice",
                                                style: TextStyles
                                                    .textViewMedium13
                                                    .copyWith(
                                                  color: prussian,
                                                  decoration: isChecked
                                                      ? TextDecoration
                                                      .lineThrough
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                      ],
                    );

                  }),
            ),
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
                      context: context, delegate: MySearchDelegate(pref));
                },
                prefixIcon: Icon(Icons.search),
                borderRaduis: 999,
                hintText: LocaleKeys.whatAreYouLookingFor.tr(),
                hintStyle:
                    TextStyles.textViewSemiBold14.copyWith(color: gunmetal),
              ),
            ),
            30.ph,
            Text(
              LocaleKeys.latestBargains.tr(),
              style:
                  TextStylesInter.textViewRegular13.copyWith(color: mainPurple),
            ),
            6.ph,
            Container(
              height: 250.h,
              child: FutureBuilder<int>(
                  future: getAllProductsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data != 200) {
                      return const Center(
                        child: Text(
                            "Something went wrong. Please try again later"),
                      );
                    }
                    allProducts =
                        Provider.of<ProductsProvider>(context, listen: false)
                            .allProducts;
                    // print("\n RESPONSE: ${allProducts.length}");
                    return ListView.builder(
                      itemCount: allProducts.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        var productName = allProducts[i]['Name'];
                        var imageURL = allProducts[i]['Image_url'];
                        var storeName = allProducts[i]['Store'];
                        var description = allProducts[i]['Description'];
                        var price = allProducts[i]['Current_price'];
                        var oldPrice = allProducts[i]['Old_price'];
                        var size = allProducts[i]['Size'];
                        return GestureDetector(
                          onTap: () => AppNavigator.push(
                              context: context,
                              screen: ProductDetailScreen(
                                storeName: storeName,
                                oldPrice: oldPrice,
                                productName: productName,
                                imageURL: imageURL,
                                description: description,
                                price: price.runtimeType == int
                                    ? price.toDouble()
                                    : price,
                                size: size,
                              )),
                          child: DiscountItem(
                            name: productName,
                            imageURL: imageURL,
                            albertPriceBefore:
                                oldPrice.toString().isEmpty ? null : oldPrice,
                            albertPriceAfter: price.toString(),
                            measurement: size,
                            onAdd: () {
                              panelController.close();
                              Provider.of<ChatlistsProvider>(context,
                                      listen: false)
                                  .addItemToList(
                                      ListItem(
                                          oldPrice: oldPrice,
                                          name: productName,
                                          price: price,
                                          isChecked: false,
                                          quantity: 1,
                                          imageURL: imageURL,
                                          size: size),
                                      widget.listId);
                            },
                            onShare: () {
                              panelController.close();
                              Provider.of<ChatlistsProvider>(context,
                                      listen: false)
                                  .shareItemAsMessage(
                                      itemName: productName,
                                      itemSize: size,
                                      itemImage: imageURL,
                                      itemPrice: price,
                                      itemOldPrice: oldPrice,
                                      storeName: storeName,
                                      listId: widget.listId);
                            },
                            sparPriceAfter: '0.0',
                            jumboPriceAfter: '0.0',
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
    );
  }
}
