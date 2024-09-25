import 'package:bargainb/features/home/presentation/views/widgets/store_product_card.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/algolia_tracking_utils.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../config/routes/app_navigator.dart';
import '../../../../../models/list_item.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/utils.dart';
import '../../../data/models/product.dart';
import '../product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final int productIndex;
  final String queryId;
  const ProductItem({super.key, required this.product, required this.productIndex, required this.queryId, });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        AlgoliaTrackingUtils.trackAlgoliaClickEvent(product.id.toString(), queryId, productIndex);
        AppNavigator.push(context: context, screen: ProductDetailScreen(product: product));
      },
      child: Container(
        width: 170,
        // height: 248,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: Utils.boxShadow,
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            30.ph,
            // Align(
            //   alignment: AlignmentDirectional.topStart,
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            //     decoration: BoxDecoration(
            //       color: Colors.orange[500],
            //       borderRadius: BorderRadius.circular(10)
            //     ),
            //     child: Text("Saving\n €0.59", style: TextStyles.textViewRegular10.copyWith(color: Colors.white),),
            //   ),
            // ),
            10.ph,
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Center(
                  child: Image.network(
                    product.image,
                    height: 100.h,
                    width: 100.w,
                    errorBuilder: (ctx, _, stack){
                      return Image.asset(bbIconNew, color: Colors.green,);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                    child: StoreProductCard(storeName: product.storeName,)
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                    border: Border.all(color: primaryGreen),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(product.unit, style: TextStylesInter.textViewMedium10.copyWith(color: primaryGreen),),
                ),
              ],
            ),
            10.ph,
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStylesInter.textViewRegular12.copyWith(color: blackSecondary),
            ),
            10.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.price.toString(),
                      style: TextStylesPaytoneOne.textViewRegular24.copyWith(color: Color(0xffEA4B48), fontSize: 13),
                    ),
                    if(product.oldPrice != null && product.oldPrice != "N/A")
                    Text(product.oldPrice.toString(), style: TextStylesInter.textViewMedium10.copyWith(color: Colors.grey, decoration: TextDecoration.lineThrough),)
                  ],
                ),
                InkWell(
                  onTap: () {
                    Provider.of<ChatlistsProvider>(context,listen: false).addProductToList(context, ListItem(
                        id: product.id,
                        storeName: product.storeName,
                        name: product.name,
                        brand: product.brand,
                        oldPrice: product.price,
                        price: product.price,
                        isChecked: false,
                        quantity: 1,
                        imageURL: product.image,
                        size: product.unit,
                        category: product.category,
                        text: ''));
                    AlgoliaTrackingUtils.trackAlgoliaProductAddedEvent(product.id.toString(), queryId);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(color: primaryGreen),
                    ),
                    child: Icon(
                      Icons.add_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
