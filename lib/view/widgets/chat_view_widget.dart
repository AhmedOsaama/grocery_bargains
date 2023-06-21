import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/models/product_category.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/down_triangle_painter.dart';
import 'package:bargainb/utils/tooltips_keys.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/components/close_button.dart';
import 'package:bargainb/view/components/draggable_list.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/screens/categories_screen.dart';
import 'package:bargainb/view/widgets/product_dialog.dart';
import 'package:bargainb/view/widgets/quantity_counter.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

import '../../providers/products_provider.dart';
import 'discountItem.dart';
import 'message_bubble.dart';

class ChatView extends StatefulWidget {
  final String listId;
  final Function showInviteMembersDialog;

  ChatView({Key? key, required this.listId, required this.showInviteMembersDialog}) : super(key: key);

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
  @override
  void initState() {
    getFirstTime();
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
      builder: Builder(builder: (builder) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (isFirstTime) {
            ShowCaseWidget.of(builder).startShowCase([TooltipKeys.showCase4, TooltipKeys.showCase5]);
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
            Column(
              children: [
                Expanded(
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
                              return Column(
                                children: [
                                  SvgPicture.asset(messagesPlaceholder),
                                  15.ph,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40),
                                    child: Text(
                                      LocaleKeys.addYourFriendsAndFamily.tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStylesInter.textViewMedium15.copyWith(color: blackSecondary),
                                    ),
                                  ),
                                  20.ph,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GenericButton(
                                        onPressed: () => widget.showInviteMembersDialog(context),
                                        child: Text(LocaleKeys.addContacts.tr()),
                                        color: mainPurple,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      25.pw,
                                      GenericButton(
                                          onPressed: () async {
                                            SharedPreferences pref = await SharedPreferences.getInstance();
                                            return showSearch(context: context, delegate: MySearchDelegate(pref, true));
                                          },
                                          child: Text(LocaleKeys.addItem.tr()),
                                          color: mainPurple,
                                          borderRadius: BorderRadius.circular(6)),
                                    ],
                                  )
                                ],
                              );
                            }
                            return ListView.builder(
                                reverse: true,
                                itemCount: messages.length,
                                itemBuilder: (ctx, index) => Showcase.withWidget(
                                      key: isFirstTime ? TooltipKeys.showCase5 : new GlobalKey<State<StatefulWidget>>(),
                                      onTargetClick: () async => await turnOffFirstTime(),
                                      onBarrierClick: () async => await turnOffFirstTime(),
                                      onTargetDoubleTap: () async => await turnOffFirstTime(),
                                      tooltipPosition: TooltipPosition.top,
                                      targetBorderRadius: BorderRadius.circular(8),
                                      container: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(15),
                                              width: 180.w,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.r),
                                                color: purple70,
                                              ),
                                              child: Column(children: [
                                                Text(
                                                  LocaleKeys.shareGroceriesToChat.tr(),
                                                  maxLines: 4,
                                                  style: TextStyles.textViewRegular13.copyWith(color: white),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await turnOffFirstTime();
                                                    ShowCaseWidget.of(builder).next();
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
                                                15.pw,
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
                                      height: 110.h,
                                      width: 190.h,
                                      child: Container(
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
                                      ),
                                    ));
                          }),
                      StreamBuilder(
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
                            if (items.isEmpty) {
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
                                                text: " ${items.length} ${LocaleKeys.items.tr()}",
                                                style: TextStylesInter.textViewBold12.copyWith(color: blackSecondary))
                                          ])),
                                      15.pw,
                                      Text.rich(TextSpan(
                                          text: "${LocaleKeys.total.tr()} ",
                                          style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                                          children: [
                                            TextSpan(
                                                text: " €${getTotalListPrice(items)}",
                                                style: TextStylesInter.textViewBold12.copyWith(color: mainPurple))
                                          ])),
                                      15.pw,
                                      Text.rich(TextSpan(
                                          text: "${LocaleKeys.savings.tr()} ",
                                          style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
                                          children: [
                                            TextSpan(
                                                text: " €${getTotalListSavings(items)}",
                                                style: TextStylesInter.textViewBold12.copyWith(color: greenSecondary))
                                          ])),
                                      Spacer(),
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
                                    Flexible(
                                        child: ListView.separated(
                                      itemCount: items.length,
                                      separatorBuilder: (ctx, i) => 10.ph,
                                      padding: EdgeInsets.only(bottom: 15.h),
                                      itemBuilder: (ctx, i) {
                                        var isChecked = items[i]['item_isChecked'];
                                        var text = items[i]['text'] ?? '';
                                        var itemName = items[i]['item_name'];
                                        var itemImage = items[i]['item_image'];
                                        var itemSize = items[i]['item_size'];
                                        var itemPrice = items[i]['item_price'];
                                        var itemOldPrice = items[i].data().containsKey("item_oldPrice")
                                            ? items[i]['item_oldPrice'] ?? ""
                                            : '';
                                        var itemQuantity = items[i].data().containsKey("item_quantity")
                                            ? items[i]['item_quantity']
                                            : 1;
                                        var storeName =
                                            items[i].data().containsKey("store_name") ? items[i]['store_name'] : '';
                                        var itemId =
                                            items[i].data().containsKey("item_id") ? items[i]['item_id'] : -1;
                                        var itemBrand =
                                            items[i].data().containsKey("item_brand") ? items[i]['item_brand'] : '';
                                        return text.isNotEmpty
                                            ? Container()
                                            : Column(
                                              children: [
                                                Row(
                                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: Opacity(
                                                          opacity: isChecked ? 0.6 : 1,
                                                          child: Row(
                                                            children: [
                                                              Checkbox(
                                                                value: isChecked,
                                                                checkColor: purple70,
                                                                side: BorderSide(color: purple70, width: 2),
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    items[i]
                                                                        .data()
                                                                        .update('item_isChecked', (value) => !isChecked);
                                                                    // (items[i] as Map)['item_isChecked'] =
                                                                    // !isChecked;
                                                                  });
                                                                  FirebaseFirestore.instance
                                                                      .collection(
                                                                          "/lists/${items[i].reference.parent.id}/items")
                                                                      .doc(items[i].id)
                                                                      .update({
                                                                    "item_isChecked": isChecked,
                                                                  }).catchError((e) {
                                                                    print(e);
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(content: Text("OperationNotDone".tr())));
                                                                  });
                                                                },
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {},
                                                                child: Image.network(
                                                                  itemImage,
                                                                  errorBuilder: (ctx, _, p) => SvgPicture.asset(
                                                                    imageError,
                                                                    height: 50,
                                                                  ),
                                                                  width: 55,
                                                                  height: 55,
                                                                ),
                                                              ),
                                                              12.pw,
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // Text(storeName),
                                                                  Text(
                                                                    itemBrand,
                                                                    style: TextStylesInter.textViewSemiBold13.copyWith(
                                                                      color: blackSecondary,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 130.w,
                                                                    child: Text(
                                                                      itemName,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 2,
                                                                      style: TextStylesInter.textViewRegular10.copyWith(
                                                                          color: blackSecondary,
                                                                          decoration: isChecked
                                                                              ? TextDecoration.lineThrough
                                                                              : null),
                                                                    ),
                                                                  ),
                                                                  10.ph,
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              Text("X " + itemQuantity.toString()),
                                                              10.pw,
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (ctx) => ProductDialog(
                                                                          itemId: itemId,
                                                                            itemQuantity: itemQuantity,
                                                                            itemImage: itemImage,
                                                                            itemBrand: itemBrand,
                                                                            itemSize: itemSize,
                                                                            itemName: itemName, storeName: storeName,));
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    edit,
                                                                    color: Colors.black,
                                                                  )),
                                                              12.pw,
                                                              Text(
                                                                "€ ${(double.parse(itemPrice) * itemQuantity).toStringAsFixed(2)}",
                                                                style: TextStyles.textViewMedium13.copyWith(
                                                                  color: prussian,
                                                                  decoration: isChecked ? TextDecoration.lineThrough : null,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                Row(
                                                  children: [
                                                    105.pw,
                                                    SizeContainer(itemSize: itemSize),
                                                    10.pw,
                                                    if (itemOldPrice != null &&
                                                        itemOldPrice.isNotEmpty) ...[
                                                      Text(
                                                        "€ ${itemOldPrice}",
                                                        // "€ 2.33",
                                                        style: TextStyles.textViewMedium10.copyWith(
                                                            color: greyText,
                                                            decoration: TextDecoration.lineThrough),
                                                      ),
                                                      5.pw,
                                                      Text(
                                                        "€ ${(double.parse(itemOldPrice) - double.parse(itemPrice)).toStringAsFixed(2)} less",
                                                        // "€ ${2.33 - 1.00} less",
                                                        style: TextStyles.textViewMedium10.copyWith(
                                                          color: greenSecondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            );
                                      },
                                    )),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: GenericField(
                          controller: messageController,
                          hintText: LocaleKeys.textHere.tr(),
                          hintStyle: TextStylesInter.textViewRegular14.copyWith(color: blackSecondary),
                          suffixIcon: Icon(
                            Icons.emoji_emotions_outlined,
                          ),
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
          ],
        );
      }),
    );
  }

  Showcase tooltipWidget(BuildContext builder, BuildContext context) {
    return Showcase.withWidget(
      targetPadding: EdgeInsets.only(left: 100.w),
      key: isFirstTime ? TooltipKeys.showCase4 : new GlobalKey<State<StatefulWidget>>(),
      container: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              width: 180.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: purple70,
              ),
              child: Column(children: [
                Text(
                  LocaleKeys.pressACardIconToSearch.tr(),
                  maxLines: 4,
                  style: TextStyles.textViewRegular13.copyWith(color: white),
                ),
                GestureDetector(
                  onTap: () {
                    ShowCaseWidget.of(builder).next();
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
              children: [
                15.pw,
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
      height: 110.h,
      width: 190.h,
      child: Container(
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
                      panelController.isPanelClosed ? panelController.open() : panelController.close();
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
              hintStyle: TextStylesInter.textViewRegular14.copyWith(color: black2),
              onSubmitted: (_) async {
                await Provider.of<ChatlistsProvider>(context, listen: false)
                    .sendMessage(messageController.text.trim(), widget.listId);
                messageController.clear();
              },
              suffixIcon: GestureDetector(
                onTap: () async {
                  await Provider.of<ChatlistsProvider>(context, listen: false)
                      .sendMessage(messageController.text.trim(), widget.listId);
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
    );
  }
}
