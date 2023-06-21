import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/view/widgets/quantity_counter.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/routes/app_navigator.dart';
import '../../models/product.dart';
import '../../providers/chatlists_provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/close_button.dart';
import '../screens/product_detail_screen.dart';

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
  int itemQuantity;

  ProductDialog(
      {Key? key,
      required this.itemQuantity,
      required this.storeName,
      required this.itemId,
      required this.itemImage,
      required this.itemBrand,
        required this.listId,
        required this.itemPrice,required this.itemDocId,
      required this.itemSize,
      required this.itemName})
      : super(key: key);

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  @override
  Widget build(BuildContext context) {
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
                },
                decreaseQuantity: () {
                  setState(() {
                    widget.itemQuantity--;
                  });
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
                        Provider.of<ChatlistsProvider>(
                            context,
                            listen: false)
                            .deleteItemFromChatlist(
                            widget.listId,
                            widget.itemDocId,
                            widget.itemPrice
                        );
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
                          late Product product;
                          switch (widget.storeName) {
                            case 'Hoogvliet':
                              product = productProvider.hoogvlietProducts
                                  .firstWhere((product) => product.id == widget.itemId);
                              break;
                            case 'Jumbo':
                              product =
                                  productProvider.jumboProducts.firstWhere((product) => product.id == widget.itemId);
                              break;
                            case 'Albert':
                              product =
                                  productProvider.albertProducts.firstWhere((product) => product.id == widget.itemId);
                              break;
                          }
                          AppNavigator.push(
                              context: context,
                              screen: ProductDetailScreen(
                                productId: product.id,
                                productBrand: product.brand,
                                oldPrice: product.oldPrice,
                                storeName: product.storeName,
                                productName: product.name,
                                imageURL: product.imageURL,
                                description: product.description,
                                size1: product.size,
                                size2: product.size2 ?? "",
                                price1: double.tryParse(product.price ?? "") ?? 0.0,
                                price2: double.tryParse(product.price2 ?? "") ?? 0.0,
                              ));
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
                    IconButton(onPressed: shareProductViaDeepLink, icon: Icon(Icons.share_outlined, color: purple30),splashRadius: 25),
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
  shareProductViaDeepLink() async {
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'invite_to_product',
        title: widget.itemName,
        imageUrl:
        'https://play-lh.googleusercontent.com/u6LMBvrIXH6r1LFQftqjSzebxflasn-nhcoZUlP6DjWHV6fmrwgNFyjJeFwFmckrySHF=w240-h480-rw',
        contentDescription:
        'Hey, check out this product ${widget.itemName} from BargainB',
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('product_data', {
            "product_id": widget.itemId,
            "store_name": widget.storeName
          }));
    BranchLinkProperties lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing product',
        stage: 'new share',
        tags: ['one', 'two', 'three']);
    BranchResponse response =
    await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);

    if (response.success) {
      print('Link generated: ${response.result}');
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
    }
    Share.share(response.result);
  }
}
