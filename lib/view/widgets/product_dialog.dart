import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/view/widgets/quantity_counter.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../config/routes/app_navigator.dart';
import '../../models/product.dart';
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
  String storeName;
  int itemQuantity;
  ProductDialog(
      {Key? key,
      required this.itemQuantity,
      required this.storeName,
      required this.itemId,
      required this.itemImage,
      required this.itemBrand,
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
                      onPressed: () {},
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
                          print(widget.itemId);
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
                    IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined, color: purple30),splashRadius: 25),
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
