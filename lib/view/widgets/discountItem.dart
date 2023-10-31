import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../../utils/tracking_utils.dart';
import '../screens/product_detail_screen.dart';

class DiscountItem extends StatelessWidget {
  final Product product;
  final bool inGridView;
  DiscountItem({Key? key, required this.inGridView, required this.product}) : super(key: key);

  var selectedStore = (['Albert', "Jumbo", "Hoogvliet", "Dirk"]..shuffle()).first;

  String getProductImage(Product product) {
    try {
      return product.image;
    } catch (e) {
      print(e);
      print(product.id);
      return "N/A";
    }
  }

  String getProductBrand(Product product) {
    return product.brand;
  }

  String getProductSize(Product product) {
    try {
      if(product.unit == "N/A" || product.unit.isEmpty) return product.pricePerUnit!;
      return product.unit;
    } catch (e) {
      // print("Error: failed to get size in discount item");
      return "N/A";
    }
  }

  String getProductName(Product product) {
    return product.name;
  }

  String getPrice(Product product) {
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
      var currentPrice = double.parse(product.price);
      if (oldPrice > currentPrice) return (oldPrice - currentPrice).toStringAsFixed(2);
    } catch (e) {
      print("Error in latest bargains: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    late Product product;
    product = this.product;
    selectedStore = productsProvider.getStoreName(product.storeId);
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
            BoxShadow(color: shadowColor, blurRadius: 28, offset: Offset(0, 10)),
            // BoxShadow(color: shadowColor, blurRadius: 28, offset: Offset(0, 5), blurStyle: BlurStyle.solid),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: inGridView ? 0 : 5, horizontal: inGridView ? 0 : 5),
        padding: EdgeInsets.symmetric(horizontal: inGridView ? 10 : 15.w),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: () {
                print("Product Category: ${product.category}");
                var listItem = ListItem(
                    storeName: selectedStore,
                    brand: product.brand,
                    id: product.id,
                    name: product.name,
                    price: getPrice(product),
                    text: "",
                    isChecked: false,
                    quantity: 1,
                    imageURL: product.image,
                    category: product.category,
                    size: getProductSize(product));
                Provider.of<ChatlistsProvider>(context, listen: false).addProductToList(context, listItem);
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
                  size: 28,
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
                5.ph,
                if (getProductBrand(product).isNotEmpty)
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStylesInter.textViewRegular12.copyWith(color: blackSecondary),
                ),
                5.ph,
                Image.asset(
                  getStoreLogoPath(),
                  width: 60,
                  height: 25,
                ),
                5.ph,
                Text(
                  "€${getPrice(product)}",
                  style: TextStylesInter.textViewBold16,
                ),
                3.ph,
                if (getDiscountValue(product) != null)
                  Row(
                    children: [
                      Text(
                        "€" + getOldPrice(product),
                        style: TextStylesInter.textViewMedium10
                            .copyWith(color: greyText, decoration: TextDecoration.lineThrough),
                      ),
                      3.pw,
                      Text(
                        "${LocaleKeys.save.tr()} €${getDiscountValue(product)}",
                        style: TextStylesInter.textViewMedium10.copyWith(color: Color.fromRGBO(24, 195, 54, 1)),
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
          imageURL: product.image,
          description: product.description,
          oldPrice: product.oldPrice,
          productCategory: product.category,
          price1: double.tryParse(product.price ?? "") ?? 0.0,
          size1: getProductSize(product), gtin: product.gtin,
        ));
    try{
      TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open product page", DateTime.now().toUtc().toString(), "Home screen");
    }catch(e){
      print(e);
      TrackingUtils().trackButtonClick("Guest", "Open product page", DateTime.now().toUtc().toString(), "Home screen");
    }
  }

  String getStoreLogoPath() {
    if (selectedStore == "Albert") {
      return albertLogo;
    }
    if (selectedStore == "Jumbo") {
      return jumbo;
    }
    if (selectedStore == "Hoogvliet") {
      return hoogvlietLogo;
    }
    if (selectedStore == "Dirk") {
      return dirkLogo;
    }
    return imageError;
  }
}
