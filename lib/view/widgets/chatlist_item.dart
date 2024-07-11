import 'dart:developer';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/view/widgets/product_dialog.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/search/presentation/views/algolia_search_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../../utils/tracking_utils.dart';

class ChatlistItem extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> item;
  const ChatlistItem({Key? key, required this.item}) : super(key: key);

  @override
  State<ChatlistItem> createState() => _ChatlistItemState();
}

class _ChatlistItemState extends State<ChatlistItem> {
  var isChecked;
  var text;
  var itemName;
  var itemImage;
  var itemSize;
  var itemPrice;
  var itemOldPrice;
  var itemQuantity;
  var storeName;
  var itemId;
  var itemBrand;
  var itemCategory;

  bool isClicked = false;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      log("IN CHATLIST BUILD: ${widget.item['text']}");
      isChecked = widget.item['item_isChecked'];
      text = widget.item['text'] ?? '';
      itemName = widget.item['item_name'];
      itemImage = widget.item['item_image'];
      itemSize = widget.item['item_size'];
      itemPrice = widget.item['item_price'];
      itemOldPrice = widget.item.data().containsKey("item_oldPrice") ? widget.item['item_oldPrice'] ?? "" : '';
      itemQuantity = widget.item.data().containsKey("item_quantity") ? widget.item['item_quantity'] : 1;
      storeName = widget.item.data().containsKey("store_name") ? widget.item['store_name'] : '';
      itemId = widget.item.data().containsKey("item_id") ? widget.item['item_id'] : -1;
      itemBrand = widget.item.data().containsKey("item_brand") ? widget.item['item_brand'] : '';
      itemCategory = widget.item.data().containsKey("item_category") ? widget.item['item_category'] : '';
    } catch (e) {
      print(e);
    }
    return text.isNotEmpty        //case of item is plain text
        ? Row(
            children: [
              Checkbox(
                value: isChecked,
                checkColor: purple70,
                side: const BorderSide(color: purple70, width: 2),
                onChanged: (value) {
                  setState(() {
                    widget.item.data().update('item_isChecked', (value) => !isChecked);
                    isChecked = !isChecked;
                  });
                  FirebaseFirestore.instance
                      .collection("/lists/${widget.item.reference.parent.parent?.id}/items")
                      // "/lists/${widget.item.reference.parent.id}/items")
                      .doc(widget.item.id)
                      .update({
                    "item_isChecked": isChecked,
                  }).catchError((e) {
                    print(e);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OperationNotDone".tr())));
                  });
                  TrackingUtils().trackCheckBoxItemClicked(FirebaseAuth.instance.currentUser!.uid,
                      DateTime.now().toUtc().toString(), "Mark off chatlist item", "Chatlist screen", isChecked);
                  TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Check off item",
                      DateTime.now().toUtc().toString(), "Chatlist screen");
                },
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    isClicked = !isClicked;
                  });
                  try {
                    TrackingUtils().trackTextLinkClicked(FirebaseAuth.instance.currentUser!.uid,
                        DateTime.now().toUtc().toString(), "Chatlist screen", "Click chatlist item");
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  text,
                  style: TextStylesInter.textViewRegular16,
                ),
              ),
              if (isClicked)
                IconButton(
                    onPressed: () async {
                      AppNavigator.push(context: context, screen: AlgoliaSearchScreen(query: text));
                      TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open search",
                          DateTime.now().toUtc().toString(), "Chatlist screen");
                      // showSearch(context: context, delegate: MySearchDelegate(pref: pref),query: text);
                    },
                    icon: const Icon(
                      Icons.arrow_right,
                      color: greyText,
                    )),
              const Spacer(),
              if (isClicked)
                IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('/lists/${widget.item.reference.parent.parent!.id}/items')
                          .doc(widget.item.id)
                          .delete();
                      TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid,
                          "delete manual(text) item", DateTime.now().toUtc().toString(), "Chatlist screen");
                    },
                    icon: const Icon(
                      Icons.close,
                      color: greyText,
                      size: 18,
                    ))
            ],
          )
        : Column(                     //case of item is a product
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
                            side: const BorderSide(color: purple70, width: 2),
                            onChanged: (value) {
                              setState(() {
                                widget.item.data().update('item_isChecked', (value) => !isChecked);
                                isChecked = !isChecked;
                              });
                              FirebaseFirestore.instance
                                  .collection("/lists/${widget.item.reference.parent.parent?.id}/items")
                                  .doc(widget.item.id)
                                  .update({
                                "item_isChecked": isChecked,
                              }).catchError((e) {
                                print(e);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text("OperationNotDone".tr())));
                              });
                              double parsedItemOldPrice = double.tryParse(itemOldPrice) ?? 0;
                              double parsedItemPrice = double.parse(itemPrice);
                              double discount = itemOldPrice != '' ? (parsedItemOldPrice - parsedItemPrice) : 0;
                              print("RECORDING PURCHASES");
                              if (isChecked) {
                                FirebaseFirestore.instance
                                    .doc('/users/${FirebaseAuth.instance.currentUser!.uid}')
                                    .update({
                                  // FieldPath.fromString('purchase_record.${itemCategory}'): FieldValue.arrayUnion([itemName]),
                                  FieldPath.fromString('purchase_record.${itemCategory}'): FieldValue.arrayUnion([
                                    {
                                      "date": DateTime.now().toUtc(),
                                      "discount": discount,
                                      "price": parsedItemPrice,
                                      "product_name": itemName,
                                      "product_id": itemId,
                                    }
                                  ])
                                }).catchError((e) {
                                  print("Error: $e");
                                });
                              }
                              TrackingUtils().trackCheckBoxItemClicked(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  DateTime.now().toUtc().toString(),
                                  "Mark off chatlist item",
                                  "Chatlist screen",
                                  isChecked);
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
                                width: 100.w,
                                child: Text(
                                  itemName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStylesInter.textViewRegular10.copyWith(
                                      color: blackSecondary, decoration: isChecked ? TextDecoration.lineThrough : null),
                                ),
                              ),
                              10.ph,
                            ],
                          ),
                          const Spacer(),
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
                                          itemName: itemName,
                                          storeName: storeName,
                                          listId: widget.item.reference.parent.parent!.id,
                                          itemPrice: itemPrice,
                                          itemOldPrice: itemOldPrice,
                                          itemDocId: widget.item.id,
                                        ));
                                TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "edit item",
                                    DateTime.now().toUtc().toString(), "Chatlist screen");
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
                  if (itemOldPrice != null && itemOldPrice.isNotEmpty && itemOldPrice != "N/A") ...[
                    Text(
                      "€ ${itemOldPrice}",
                      // "€ 2.33",
                      style:
                          TextStyles.textViewMedium10.copyWith(color: greyText, decoration: TextDecoration.lineThrough),
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
  }
}
