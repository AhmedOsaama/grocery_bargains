import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/utils/utils.dart';
import 'package:swaav/view/components/dotted_container.dart';
import 'package:swaav/view/components/generic_field.dart';
import 'package:swaav/view/components/generic_menu.dart';
import 'package:swaav/view/components/my_scaffold.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/profile_screen.dart';
import 'package:swaav/view/screens/sub_categories_screen.dart';
import 'package:swaav/view/widgets/backbutton.dart';

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

  @override
  void didChangeDependencies() {
    getAllProductsFuture =
        Provider.of<ProductsProvider>(context, listen: false).getProducts(0);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: StreamBuilder<QuerySnapshot>(
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
                  padding: EdgeInsets.only(bottom: 300),
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
                          userImage: messages[index]['userImageURL'],
                          key: ValueKey(messages[index].id),
                          isAddedToList: messages[index]['isAddedToList'],
                        ),
                      ));
            }),
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
              onSubmitted: (_) async => await sendMessage(),
              suffixIcon: GestureDetector(
                onTap: () async {
                  await sendMessage();
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
                                oldPrice.toString().isEmpty
                                    ? null
                                    : oldPrice,
                            albertPriceAfter: price.toString(),
                            measurement: size,
                            onShare: () {
                              panelController.close();
                              shareItem(itemName: productName,itemSize: size,itemImage: imageURL,itemPrice: price,itemOldPrice: oldPrice,storeName: storeName);
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



  Future<void> sendMessage() async {
    if (messageController.text.trim().isNotEmpty) {
      final userData = await FirebaseFirestore.instance
          .collection('/users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      await FirebaseFirestore.instance
          .collection('/lists/${widget.listId}/messages')
          .add({
        'item_name': "",
        'item_image': "",
        'item_description': "",
        'store_name': "",
        'isAddedToList': false,
        'item_price': 0.0,
        'item_oldPrice': "",
        'message': messageController.text.trim(),
        'createdAt': Timestamp.now(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'username': userData['username'],
        'userImageURL': userData['imageURL'],
      });
      FirebaseFirestore.instance
          .collection('/lists')
          .doc(widget.listId)
          .update({
        "last_message": messageController.text.trim(),
        "last_message_date": Timestamp.now(),
        "last_message_userId": FirebaseAuth.instance.currentUser?.uid,
      });
      messageController.clear();
    }
  }

  Future<void> shareItem({itemName,itemImage,itemSize,itemQuantity,isAddedToList,itemPrice,itemOldPrice,storeName}) async {
      final userData = await FirebaseFirestore.instance
          .collection('/users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      await FirebaseFirestore.instance
          .collection('/lists/${widget.listId}/messages')
          .add({
        'item_name': itemName,
        'item_image': itemImage,
        'item_description': itemSize,
        'store_name': storeName,
        'isAddedToList': false,
        'item_price': itemPrice,
        'item_oldPrice': itemOldPrice,
        'message': messageController.text.trim(),
        'createdAt': Timestamp.now(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'username': userData['username'],
        'userImageURL': userData['imageURL'],
      });
      FirebaseFirestore.instance
          .collection('/lists')
          .doc(widget.listId)
          .update({
        "last_message": messageController.text.trim(),
        "last_message_date": Timestamp.now(),
        "last_message_userId": FirebaseAuth.instance.currentUser?.uid,
      });
      messageController.clear();
  }
}
