import 'package:bargainb/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../config/routes/app_navigator.dart';
import '../../models/comparison_product.dart';
import '../../models/list_item.dart';
import '../../models/product.dart';
import '../../providers/chatlists_provider.dart';
import '../../utils/style_utils.dart';
import '../screens/product_detail_screen.dart';

class DiscountItem extends StatelessWidget {
  final ComparisonProduct comparisonProduct;
  final bool inGridView;
  DiscountItem(
      {Key? key, required this.comparisonProduct, required this.inGridView})
      : super(key: key);

  var selectedStore = (['Albert', "Jumbo", "Hoogvliet"]..shuffle()).first;

  String getProductImage() {
    if (selectedStore == "Albert") {
      return comparisonProduct.albertImageURL;
    }
    if (selectedStore == "Jumbo") {
      return comparisonProduct.jumboImageURL;
    }
    if (selectedStore == "Hoogvliet") {
      return comparisonProduct.hoogvlietImageURL;
    }
    return "";
  }

  String getProductSize() {
    if (selectedStore == "Albert") {
      return comparisonProduct.albertSize;
    }
    if (selectedStore == "Jumbo") {
      return comparisonProduct.jumboSize ?? "N/A";
    }
    if (selectedStore == "Hoogvliet") {
      return comparisonProduct.hoogvlietSize;
    }
    return "";
  }

  String getProductName() {
    if (selectedStore == "Albert") {
      return comparisonProduct.albertName;
    }
    if (selectedStore == "Jumbo") {
      return comparisonProduct.jumboName;
    }
    if (selectedStore == "Hoogvliet") {
      return comparisonProduct.hoogvlietName;
    }
    return "";
  }

  String getPrice(ProductsProvider productsProvider) {
    try {
      if (selectedStore == "Albert") {
        var product = productsProvider.albertProducts.firstWhere((product) {
          return product.url == comparisonProduct.albertLink;
        });
        return product.oldPrice ?? product.price ?? product.price2!;
      }
      if (selectedStore == "Jumbo") {
        var product = productsProvider.jumboProducts.firstWhere((product) {
          return product.url == comparisonProduct.jumboLink;
        });
        return product.oldPrice ?? product.price ?? product.price2!;
        // return product.oldPrice ?? ;
      }
      if (selectedStore == "Hoogvliet") {
        var product = productsProvider.hoogvlietProducts.firstWhere((product) {
          return product.url == comparisonProduct.hoogvlietLink;
        });
        return product.oldPrice ?? product.price ?? product.price2!;
        // return product.oldPrice ?? ;
      }
    } catch (e) {
      print(comparisonProduct.albertName);
      print(comparisonProduct.jumboName);
      print(comparisonProduct.hoogvlietName);
      print("Error in getting current price in Discount Item");
      print(e);
    }
    return "0.00";
  }

  String? getDiscountValue(ProductsProvider productsProvider) {
    late Product product;
    try {
      if (selectedStore == "Albert") {
        product = productsProvider.albertProducts.firstWhere((product) {
          return product.url == comparisonProduct.albertLink;
        });
      }
      if (selectedStore == "Jumbo") {
        product = productsProvider.jumboProducts.firstWhere((product) {
          return product.url == comparisonProduct.jumboLink;
        });
      }
      if (selectedStore == "Hoogvliet") {
        product = productsProvider.hoogvlietProducts.firstWhere((product) {
          return product.url == comparisonProduct.hoogvlietLink;
        });
      }
    } catch (e) {
      print(e);
    }
    try {
      if (product.oldPrice == null) return null;
      var oldPrice = double.tryParse(product.oldPrice ?? "") ?? 0;
      var currentPrice = double.parse(product.price ?? product.price2!);
      var price2 = double.tryParse(product.price2 ?? "") ?? 0;
      // print("oldPrice: " + oldPrice.toString());
      // print("currentPrice: " + currentPrice.toString());
      // print("currentPrice: " + price2.toString());
      if (oldPrice > currentPrice)
        return (oldPrice - currentPrice).toStringAsFixed(2);
      if (oldPrice > price2) return (oldPrice - price2).toStringAsFixed(2);
    } catch (e) {
      print("Error in latest bargains: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        goToStoreProductPage(productsProvider, context);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: white,
          boxShadow: [
            new BoxShadow(
              color: shadowColor,
              blurRadius: 20.0,
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: inGridView ? 0 : 10),
        padding: EdgeInsets.symmetric(horizontal: inGridView ? 0 : 15.w),
        child: Card(
          shadowColor: shadowColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          getProductImage(),
                          errorBuilder: (context, _, s) {
                            return Icon(Icons.image_not_supported);
                          },
                          height: 90.h,
                          width: 100.w,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 105.w,
                            child: Text(
                              getProductName(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.textViewSemiBold14,
                            ),
                          ),
                          Text(
                            getProductSize(),
                            style: TextStyles.textViewMedium12.copyWith(
                                color: Color.fromRGBO(204, 204, 204, 1)),
                          ),
                          10.ph,
                          Text(
                            "€${getPrice(productsProvider)}",
                            style: TextStylesInter.textViewBold18,
                          ),
                          5.ph,
                          if (getDiscountValue(productsProvider) != null)
                            Text(
                              "Save €${getDiscountValue(productsProvider)}",
                              style: TextStylesInter.textViewMedium10.copyWith(
                                  color: Color.fromRGBO(24, 195, 54, 1)),
                            ),
                        ],
                      ),
                    ],
                  ),
                  // 10.pw,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          productsProvider.getImage(selectedStore),
                          width: 22,
                          height: 21,
                        ),
                        100.ph,
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: mainPurple,
                          ),
                        )
                        // IconButton(
                        //     onPressed: () {
                        //       if(selectedStore == "Albert") {
                        //         var product = productsProvider.albertProducts.firstWhere((product) => product.url == comparisonProduct.albertLink);
                        //         shareDiscountItem(context, product.name,
                        //             product.oldPrice, product.price, product.price2, product.imageURL, product.size);
                        //       }
                        //       if(selectedStore == "Jumbo") {
                        //         var product = productsProvider.jumboProducts.firstWhere((product) => product.url == comparisonProduct.jumboLink);
                        //         shareDiscountItem(context, product.name,
                        //             product.oldPrice, product.price, product.price2, product.imageURL, product.size);
                        //       }
                        //
                        //     },
                        //     icon: SvgPicture.asset(chatShare)),
                        // 20.ph,
                        // PlusButton(onTap: () {
                        //   if(selectedStore == "Albert") {
                        //     var product = productsProvider.albertProducts.firstWhere((product) => product.url == comparisonProduct.albertLink);
                        //     addDiscountItem(context, product.name,
                        //         product.oldPrice, product.price, product.price2, product.imageURL, product.size);
                        //   }
                        //   if(selectedStore == "Jumbo") {
                        //     var product = productsProvider.jumboProducts.firstWhere((product) => product.url == comparisonProduct.jumboLink);
                        //     addDiscountItem(context, product.name,
                        //         product.oldPrice, product.price, product.price2, product.imageURL, product.size);
                        //   }
                        // }),
                      ],
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Container(
              //       padding: EdgeInsets.all(5),
              //       decoration: selectedStore == "Albert" ? BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           border: Border.all(color: mainPurple)
              //       ) : null,
              //       child: StorePrice(
              //         currentPrice: comparisonProduct.albertPrice,
              //         // oldPrice: widget.albertPriceBefore,
              //         storeImagePath: albert,
              //       ),
              //     ),
              //     30.pw,
              //     Container(
              //       padding: EdgeInsets.all(5),
              //       decoration: selectedStore == "Jumbo" ? BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           border: Border.all(color: mainPurple)
              //       ) : null,
              //       child: StorePrice(
              //         currentPrice: comparisonProduct.jumboPrice,
              //         // oldPrice: widget.jumboPriceBefore,
              //         storeImagePath: jumbo,
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  void goToStoreProductPage(
      ProductsProvider productsProvider, BuildContext context) {
    if (selectedStore == "Albert") {
      var product = productsProvider.albertProducts.firstWhere((product) {
        return product.url == comparisonProduct.albertLink;
      });
      AppNavigator.push(
          context: context,
          screen: ProductDetailScreen(
            comparisonId: comparisonProduct.id,
            productId: product.id,
            storeName: selectedStore,
            productName: product.name,
            imageURL: product.imageURL,
            description: product.description,
            price1: double.tryParse(product.price ?? "") ?? 0.0,
            price2: double.tryParse(product.price2 ?? "") ?? 0.0,
            size1: product.size,
            size2: product.size2 ?? "",
          ));
    }
    if (selectedStore == "Jumbo") {
      var product = productsProvider.jumboProducts
          .firstWhere((product) => product.url == comparisonProduct.jumboLink);
      AppNavigator.push(
          context: context,
          screen: ProductDetailScreen(
            comparisonId: comparisonProduct.id,
            productId: product.id,
            storeName: selectedStore,
            productName: product.name,
            imageURL: product.imageURL,
            description: product.description,
            price1: double.tryParse(product.price ?? "") ?? 0.0,
            price2: null,
            size1: product.size,
            size2: product.size2 ?? "",
          ));
    }
    if (selectedStore == "Hoogvliet") {
      var product = productsProvider.hoogvlietProducts.firstWhere(
          (product) => product.url == comparisonProduct.hoogvlietLink);
      AppNavigator.push(
          context: context,
          screen: ProductDetailScreen(
            comparisonId: comparisonProduct.id,
            productId: product.id,
            storeName: selectedStore,
            productName: product.name,
            imageURL: product.imageURL,
            description: product.description,
            price1: double.tryParse(product.price ?? "") ?? 0.0,
            price2: null,
            size1: product.size,
            size2: product.size2 ?? "",
          ));
    }
  }

  Future<void> shareDiscountItem(BuildContext context, productName, oldPrice,
      price1, price2, imageURL, size1) {
    return Provider.of<ChatlistsProvider>(context, listen: false)
        .showChooseListDialog(
      context: context,
      isSharing: true,
      listItem: ListItem(
          text: '',
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
          text: '',
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
