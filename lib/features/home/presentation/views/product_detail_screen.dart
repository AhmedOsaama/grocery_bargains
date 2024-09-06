import 'package:bargainb/features/search/presentation/views/widgets/search_appBar.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/assets_manager.dart';
import '../../../../utils/style_utils.dart';
import '../../data/models/product.dart';
import 'widgets/store_product_card.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.orange[500],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text("Saving\n ${(product.oldPrice! - product.price).abs()}", style: TextStyles.textViewRegular10.copyWith(color: Colors.white),),
                ),
              ),
              10.ph,
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Center(
                    child: Image.network(
                      product.image,
                      height: 200,
                      width: 250,
                      errorBuilder: (ctx, _, stack){
                        return Image.asset(bbIconNew, color: Colors.green,);
                      },
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: StoreProductCard(storeId: product.storeId,)
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.price.toString(),
                        style: TextStylesPaytoneOne.textViewRegular24.copyWith(color: Color(0xffEA4B48), fontSize: 13),
                      ),
                      if(product.oldPrice != null && product.oldPrice != 0.0)
                        Text(product.oldPrice.toString(), style: TextStylesInter.textViewMedium10.copyWith(color: Colors.grey, decoration: TextDecoration.lineThrough),)
                    ],
                  ),
                ],
              ),
              20.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStylesPaytoneOne.textViewRegular24,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryGreen),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("${product.unit}", style: TextStylesInter.textViewMedium15.copyWith(color: primaryGreen),),
                  )
                ],
              ),
              Divider(),
              if(product.description != "N/A" && product.description.isNotEmpty) ...[
                Text("DESCRIPTION", style: TextStylesInter.textViewRegular12,),
                15.ph,
                Text(product.description, style: TextStylesInter.textViewRegular14,),
                Divider(),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      fixedSize: Size(250, 40),
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white
                  ),
                    child: Text("Add to list", style: TextStylesInter.textViewMedium12,),),
                  10.pw,
                  OutlinedButton(onPressed: (){}, child: Row(
                    children: [
                      Text("Share", style: TextStylesInter.textViewMedium12.copyWith(color: Color(0xff0F0F0F)),),
                      5.pw,
                      Icon(Icons.share_outlined, color: Color(0xff0F0F0F),)
                    ],
                  )),
                ],
              ),
              20.ph,
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: purple30, width: 2), borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Icon(
                      Icons.report_gmailerrorred,
                      color: mainPurple,
                    ),
                    15.pw,
                    Flexible(
                      child: Text(
                        "The price shown are available online and may not reflect in store. Confirm prices before visiting store",
                        style: TextStyles.textViewLight12.copyWith(color: const Color.fromRGBO(62, 62, 62, 1)),
                      ),
                    ),
                  ],
                ),
              ),
              25.ph,
              Text("Where to buy ?", style: TextStylesInter.textViewMedium14.copyWith(color: Color(0xff123013)),),

            ],
          ),
        ),
      ),
    );
  }
}