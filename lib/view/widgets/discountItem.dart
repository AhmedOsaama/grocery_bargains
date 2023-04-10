import 'package:bargainb/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/utils.dart';
import 'package:bargainb/view/components/plus_button.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../config/routes/app_navigator.dart';
import '../../models/comparison_product.dart';
import '../../models/list_item.dart';
import '../../providers/chatlists_provider.dart';
import '../../utils/assets_manager.dart';
import '../../utils/style_utils.dart';
import '../screens/product_detail_screen.dart';

class DiscountItem extends StatefulWidget {
 final ComparisonProduct comparisonProduct;

  DiscountItem(
      {
        Key? key,
        required this.comparisonProduct
      })
      : super(key: key);

  @override
  State<DiscountItem> createState() => _DiscountItemState();
}

class _DiscountItemState extends State<DiscountItem> {
  var selectedStore = 'Albert';

  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<ProductsProvider>(context,listen: false);
    return GestureDetector(
      onTap: () {
        if(selectedStore == "Albert") {
          var product = productsProvider.albertProducts.firstWhere((product) {
            return product.url == widget.comparisonProduct.albertLink;
          });
          AppNavigator.push(
              context: context,
              screen: ProductDetailScreen(
                comparisonId: widget.comparisonProduct.id,
                productId: product.id,
                storeName: selectedStore,
                productName: product.name,
                imageURL: product.imageURL,
                description: product.description,
                price1:
                double.tryParse(product.price) ?? 0.0,
                price2: double.tryParse(product.price2 ?? "") ?? 0.0,
                size1: product.size,
                size2: product.size2 ?? "",
              ));
        }
        if(selectedStore == "Jumbo") {
          var product = productsProvider.jumboProducts.firstWhere((product) => product.url == widget.comparisonProduct.jumboLink);
          AppNavigator.push(
              context: context,
              screen: ProductDetailScreen(
                comparisonId: widget.comparisonProduct.id,
                productId: product.id,
                storeName: selectedStore,
                productName: product.name,
                imageURL: product.imageURL,
                description: product.description,
                price1:
                double.tryParse(product.price) ?? 0.0,
                price2: null,
                size1: product.size,
                size2: product.size2 ?? "",
              ));
        }
      },
      child: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(59, 59, 59, 0.13),
              blurRadius: 15,
              offset: Offset(0, 4))
        ]),
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    selectedStore == "Albert" ? widget.comparisonProduct.albertImageURL : widget.comparisonProduct.jumboImageURL,
                    height: 50.h,
                  ),
                ),
                20.pw,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130.w,
                      child: Text(
                        selectedStore == "Albert" ? widget.comparisonProduct.albertName : widget.comparisonProduct.jumboName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.textViewSemiBold14,
                      ),
                    ),
                    Text(
                      selectedStore == "Albert" ? widget.comparisonProduct.albertSize : widget.comparisonProduct.jumboSize ?? "N/A",
                      style: TextStyles.textViewMedium12
                          .copyWith(color: Color.fromRGBO(204, 204, 204, 1)),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text('View More ',style: TextStylesInter.textViewSemiBold14.copyWith(color: mainPurple),),
                            Icon(Icons.arrow_forward_ios,color: mainPurple,)
                          ],
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            if(selectedStore == "Albert") {
                              var product = productsProvider.albertProducts.firstWhere((product) => product.id == widget.comparisonProduct.albertId);
                              addDiscountItem(context, product.name,
                                  product.oldPrice, product.price, product.price2, product.imageURL, product.size);
                            }
                            if(selectedStore == "Jumbo") {
                              var product = productsProvider.jumboProducts.firstWhere((product) => product.url == widget.comparisonProduct.jumboLink);
                              addDiscountItem(context, product.name,
                                  product.oldPrice, product.price, product.price2, product.imageURL, product.size);
                            }

                          },
                          icon: SvgPicture.asset(chatShare)),
                      20.ph,
                      PlusButton(onTap: () {
                        if(selectedStore == "Albert") {
                          var product = productsProvider.albertProducts.firstWhere((product) => product.id == widget.comparisonProduct.albertId);
                          shareDiscountItem(context, product.name,
                              product.oldPrice, product.price, product.price2, product.imageURL, product.size);
                        }
                        if(selectedStore == "Jumbo") {
                          var product = productsProvider.jumboProducts.firstWhere((product) => product.url == widget.comparisonProduct.jumboLink);
                          shareDiscountItem(context, product.name,
                              product.oldPrice, product.price, product.price2, product.imageURL, product.size);
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),
            20.pw,
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedStore = "Albert";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: selectedStore == "Albert" ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: mainPurple)
                    ) : null,
                    child: StorePrice(
                      currentPrice: widget.comparisonProduct.albertPrice,
                      // oldPrice: widget.albertPriceBefore,
                      storeImagePath: albert,
                    ),
                  ),
                ),
                30.pw,
                GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedStore = "Jumbo";
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: selectedStore == "Jumbo" ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: mainPurple)
                    ) : null,
                    child: StorePrice(
                      currentPrice: widget.comparisonProduct.jumboPrice,
                      // oldPrice: widget.jumboPriceBefore,
                      storeImagePath: jumbo,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  Future<void> shareDiscountItem(BuildContext context, productName, oldPrice,
      price1, price2, imageURL, size1) {
    return Provider.of<ChatlistsProvider>(context, listen: false)
        .showChooseListDialog(
      context: context,
      isSharing: true,
      listItem: ListItem(
          name: productName,
          oldPrice: oldPrice,
          price: price1 ?? price2,
          isChecked: false,
          quantity: 0,
          imageURL: imageURL,
          size: size1),
    );
  }

  Future<void> addDiscountItem(BuildContext context, productName, oldPrice,
      price1, price2, imageURL, size1) {
    return Provider.of<ChatlistsProvider>(context, listen: false)
        .showChooseListDialog(
      context: context,
      isSharing: false,
      listItem: ListItem(
          name: productName,
          oldPrice: oldPrice,
          price: price1 ?? price2,
          isChecked: false,
          quantity: 1,
          imageURL: imageURL,
          size: size1),
    );
  }
}

class StorePrice extends StatelessWidget {
  final String currentPrice;
  final String? oldPrice;
  final String storeImagePath;
  StorePrice(
      {Key? key,
      required this.currentPrice,
      this.oldPrice,
      required this.storeImagePath})
      : super(key: key);

  var doubleOldPrice = 0.0;
  var doubleCurrentPrice = 0.0;
  @override
  Widget build(BuildContext context) {
    if (oldPrice != null) {
      doubleOldPrice = double.tryParse(oldPrice!) ?? 0.0;
      doubleCurrentPrice = double.tryParse(currentPrice) ?? 0.0;
    }
    return Column(
      children: [
        Image.asset(
          storeImagePath,
          width: 30,
          height: 22,
        ),
        10.ph,
        // if (oldPrice != null)
        //   Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         '€$currentPrice',
        //         style: TextStylesInter.textViewMedium15.copyWith(color: black2),
        //       ),
        //       Text.rich(TextSpan(
        //           text: '€$oldPrice',
        //           style: TextStylesInter.textViewMedium10.copyWith(
        //               color: Color.fromRGBO(134, 136, 137, 1),
        //               decoration: TextDecoration.lineThrough),
        //           children: [
        //             TextSpan(
        //               text:
        //                   ' €${(doubleOldPrice - doubleCurrentPrice).toStringAsFixed(2)} less',
        //               style: TextStylesInter.textViewMedium10.copyWith(
        //                   color: verdigris, decoration: TextDecoration.none),
        //             )
        //           ]))
        //     ],
        //   ),
        // if (oldPrice == null)
          Text(
            '€$currentPrice',
            style: TextStylesInter.textViewMedium12
                .copyWith(color: Color.fromRGBO(134, 136, 137, 1)),
          )
      ],
    );
  }


}
