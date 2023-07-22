import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/widgets/product_dialog.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';

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

  bool isClicked = false;

  @override
  void initState() {
    try {
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
    }catch(e){
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return text.isNotEmpty
        ? Row(
            children: [
              Checkbox(
                value: isChecked,
                checkColor: purple70,
                side: BorderSide(color: purple70, width: 2),
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
                },
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                  isClicked = !isClicked;
                  });
                },
                child: Text(
                  text,
                  style: TextStylesInter.textViewRegular16,
                ),
              ),
              if(isClicked)
                IconButton(onPressed: () async {
                  var pref = await SharedPreferences.getInstance();
                  showSearch(context: context, delegate: MySearchDelegate(pref: pref),query: text);
                }, icon: Icon(Icons.arrow_right,color: greyText,)),
              Spacer(),
              if(isClicked)
                IconButton(onPressed: (){
                FirebaseFirestore.instance.collection('/lists/${widget.item.reference.parent.parent!.id}/items').doc(widget.item.id).delete();
              }, icon: Icon(Icons.close,color: greyText,size: 18,))
            ],
          )
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
                                          itemName: itemName,
                                          storeName: storeName,
                                          listId: widget.item.reference.parent.parent!.id,
                                          itemPrice: itemPrice,
                                          itemDocId: widget.item.id,
                                        ));
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
                  if (itemOldPrice != null && itemOldPrice.isNotEmpty) ...[
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
