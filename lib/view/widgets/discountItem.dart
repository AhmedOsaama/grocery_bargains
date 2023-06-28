import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  String getProductImage(Product product) {
    return product.imageURL;
  }

  String getProductBrand(Product product) {
    return product.brand;
  }

  String getProductSize(Product product) {
    return product.size.isNotEmpty ? product.size : product.size2!;
  }

  String getProductName(Product product) {
    return product.name;
  }

  String getPrice(Product product){
    try {
      return product.price ?? "N/A";
    } catch (e) {
      print("Error in getting current price in Discount Item");
      print(e);
    }
    return "0.00";
  }
  String getOldPrice(Product product) {
    return product.oldPrice!;
  }

  String? getDiscountValue(Product product) {
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
    late Product product;
    try {
      if (selectedStore == "Albert") {
        product = productsProvider.albertProducts.firstWhere((product) => product.id == comparisonProduct.albertId);
      }
      if (selectedStore == "Jumbo") {
        product = productsProvider.jumboProducts.firstWhere((product) => product.id == comparisonProduct.jumboId);
      }
      if (selectedStore == "Hoogvliet") {
        product =
            productsProvider.hoogvlietProducts.firstWhere((product) => product.id == comparisonProduct.hoogvlietId);
      }
    }catch(e){
      print(comparisonProduct.hoogvlietId);
      print("Error in discountItem: $e");
    }
    return GestureDetector(
      onTap: () {
        goToStoreProductPage(product, context);
      },
      child: Container(
        // height: 250.h,
        // width: 174.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: white,
          boxShadow: [
            BoxShadow(
                color: shadowColor,
                blurRadius: 10,
                offset: Offset(0, -1),
                blurStyle: BlurStyle.solid),
            BoxShadow(
                color: shadowColor,
                blurRadius: 10,
                offset: Offset(0, 5),
                blurStyle: BlurStyle.solid),
          ],
        ),
        margin: EdgeInsets.symmetric(
            vertical: inGridView ? 0 : 10, horizontal: inGridView ? 0 : 5),
        padding: EdgeInsets.symmetric(horizontal: inGridView ? 10 : 15.w),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: (){
                var listItem = ListItem(storeName: selectedStore, brand: product.brand, id: product.id, name: product.name, price: getPrice(product), text: "", isChecked: false, quantity: 1, imageURL: product.imageURL, size: getProductSize(product));
                Provider.of<ChatlistsProvider>(context,listen: false).addProductToList(context, listItem);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: purple30),
                ),
                child: Icon(
                  Icons.add,
                  color: mainPurple,
                  size: 30,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      getProductImage(product),
                      errorBuilder: (context, _, s) {
                        return SvgPicture.asset(imageError);
                      },
                      height: 90.h,
                      width: 100.w,
                    ),
                  ),
                ),
                SizeContainer(itemSize: getProductSize(product)),
                10.ph,
                if(getProductBrand(product).isNotEmpty)
                SizedBox(
                  width: 105.w,
                  child: Text(
                    getProductBrand(product),
                    overflow: TextOverflow.ellipsis,
                    style: TextStylesInter.textViewSemiBold13,
                  ),
                ),
                5.ph,
                Text(
                  getProductName(product),
                  style: TextStylesInter.textViewRegular12.copyWith(color: blackSecondary),
                ),
                5.ph,
                Text(
                  selectedStore == "Albert" ? "Albert Heijn" : selectedStore,
                  style: TextStylesInter.textViewSemiBold12.copyWith(color: Colors.lightBlue),
                ),
                5.ph,
                Text(
                  "€${getPrice(product)}",
                  style: TextStylesInter.textViewBold18,
                ),
                3.ph,
                if (getDiscountValue(product) != null)
                  Row(
                    children: [
                      Text(
                        "€" + getOldPrice(product),
                        style: TextStylesInter.textViewMedium10.copyWith(color: greyText, decoration: TextDecoration.lineThrough),
                      ),
                      3.pw,
                      Text(
                        "${LocaleKeys.save.tr()} €${getDiscountValue(product)}",
                        style: TextStylesInter.textViewMedium10.copyWith(
                            color: Color.fromRGBO(24, 195, 54, 1)),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void goToStoreProductPage(Product product, BuildContext context) {
     AppNavigator.push(
          context: context,
          screen: ProductDetailScreen(
            productId: product.id,
            productBrand: product.brand,
            storeName: selectedStore,
            productName: product.name,
            imageURL: product.imageURL,
            description: product.description,
            oldPrice: product.oldPrice,
            price1: double.tryParse(product.price ?? "") ?? 0.0,
            price2: double.tryParse(product.price2 ?? "") ?? 0.0,
            size1: product.size,
            size2: product.size2 ?? "",
          ));
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
