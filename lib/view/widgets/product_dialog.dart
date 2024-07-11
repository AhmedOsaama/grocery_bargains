import 'dart:convert';

import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/view/widgets/quantity_counter.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/routes/app_navigator.dart';
import '../../features/home/data/models/product.dart';
import '../../providers/chatlists_provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/tracking_utils.dart';
import '../components/close_button.dart';
import '../../features/home/presentation/views/product_detail_screen.dart';

class ProductDialog extends StatefulWidget {
  String itemImage;
  int itemId;
  String itemBrand;
  String itemSize;
  String itemName;
  String listId;
  String itemDocId;
  String itemPrice;
  String storeName;
  String itemOldPrice;
  int itemQuantity;

  ProductDialog(
      {Key? key,
      required this.itemQuantity,
      required this.storeName,
      required this.itemId,
      required this.itemImage,
      required this.itemBrand,
      required this.listId,
      required this.itemPrice,
      required this.itemDocId,
      required this.itemSize,
      required this.itemOldPrice,
      required this.itemName})
      : super(key: key);

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {

  @override
  void initState() {
    try {
      TrackingUtils().trackPopPageView(
          FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Chatlist Item edit popup");
    }catch(e){
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var chatlistProvider = Provider.of<ChatlistsProvider>(context, listen: false);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: MyCloseButton(),
            ),
            10.ph,
            Image.network(
              widget.itemImage,
              width: 200.w,
              height: 122.h,
            ),
            10.ph,
            Text(
              widget.itemBrand,
              style: TextStylesInter.textViewSemiBold32.copyWith(color: blackSecondary),
            ),
            6.ph,
            Text(
              widget.itemName,
              style: TextStylesInter.textViewRegular14.copyWith(color: blackSecondary),
              textAlign: TextAlign.center,
            ),
            5.ph,
            SizeContainer(itemSize: widget.itemSize),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: QuantityCounter(
                quantity: widget.itemQuantity,
                increaseQuantity: () {
                  setState(() {
                    ++widget.itemQuantity;
                  });
                  chatlistProvider.updateItemQuantity(widget.listId, widget.itemDocId, widget.itemQuantity);
                  TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "increase chatlist item quantity", DateTime.now().toUtc().toString(), "Chatlist screen");
                },
                decreaseQuantity: () {
                  setState(() {
                    widget.itemQuantity--;
                  });
                  chatlistProvider.updateItemQuantity(widget.listId, widget.itemDocId, widget.itemQuantity);
                  TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "increase chatlist item quantity", DateTime.now().toUtc().toString(), "Chatlist screen");
                },
              ),
            ),
            10.ph,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Provider.of<ChatlistsProvider>(context, listen: false)
                            .deleteItemFromChatlist(widget.listId, widget.itemDocId, widget.itemPrice, widget.itemOldPrice, widget.itemQuantity.toString(), widget.itemId.toString());
                        TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Delete chatlist item", DateTime.now().toUtc().toString(), "Chatlist screen");
                        AppNavigator.pop(context: context);
                      },
                      icon: Icon(Icons.delete, color: purple30),
                      splashRadius: 25,
                    ),
                    Text(
                      'Delete',
                      style: TextStylesInter.textViewMedium12.copyWith(color: purple30),
                    )
                  ],
                ),
                30.pw,
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          var productProvider = Provider.of<ProductsProvider>(context, listen: false);
                          productProvider.goToProductPage(widget.storeName, context, widget.itemId);
                          TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open product page", DateTime.now().toUtc().toString(), "Chatlist screen");
                        },
                        splashRadius: 25,
                        icon: Icon(
                          Icons.visibility_rounded,
                          color: purple30,
                        )),
                    Text(
                      'View',
                      style: TextStylesInter.textViewMedium12.copyWith(color: purple30),
                    )
                  ],
                ),
                30.pw,
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          Provider.of<ProductsProvider>(context, listen: false)
                              .shareProductViaDeepLink(widget.itemName, widget.itemId, widget.storeName, context);
                          TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Share chatlist item", DateTime.now().toUtc().toString(), "Chatlist screen");
                        },
                        icon: Icon(Icons.share_outlined, color: purple30),
                        splashRadius: 25),
                    Text(
                      'Share',
                      style: TextStylesInter.textViewMedium12.copyWith(color: purple30),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
