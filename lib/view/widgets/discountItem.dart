import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/utils.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/profile_screen.dart';

import '../../utils/assets_manager.dart';
import '../../utils/style_utils.dart';

class DiscountItem extends StatelessWidget {
  final String name;
  final String? albertPriceBefore;
  final String albertPriceAfter;
  final String? sparPriceBefore;
  final String sparPriceAfter;
  final String? jumboPriceBefore;
  final String jumboPriceAfter;
  final String measurement;
  final String imageURL;
  const DiscountItem(
      {Key? key,
      required this.name,
      required this.measurement,
      required this.imageURL, this.albertPriceBefore, required this.albertPriceAfter,  this.sparPriceBefore, required this.sparPriceAfter,  this.jumboPriceBefore, required this.jumboPriceAfter})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
              color: Color.fromRGBO(59, 59, 59, 0.13),
              blurRadius: 15,
              offset: Offset(0, 4)
          )
          ]
      ),
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(imageURL, height: 80.h,),
              ),
              SizedBox(
                width: 130.w,
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.textViewSemiBold14,
                ),
              ),
              Text(
                measurement,
                style: TextStyles.textViewMedium12
                    .copyWith(color: Color.fromRGBO(204, 204, 204, 1)),
              ),
              TextButton(onPressed: (){}, child: Row(
                children: [
                  Text('View More '),
                  Icon(Icons.arrow_forward_ios)
                ],
              ))
            ],
          ),
          10.pw,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(chatShare),
                PlusButton(onTap: () {}),
              ],
            ),
          ),
          20.pw,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [             //TODO: create a list with the below items and use it to get the index of the pressed item to highlight it
                ComparisonPrice(currentPrice: albertPriceAfter, oldPrice: albertPriceBefore,storeImagePath: albert,),
                ComparisonPrice(currentPrice: sparPriceAfter, oldPrice: sparPriceBefore,storeImagePath: spar,),
                ComparisonPrice(currentPrice: jumboPriceAfter, oldPrice: jumboPriceBefore, storeImagePath: jumbo,),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ComparisonPrice extends StatelessWidget {
  final String currentPrice;
  final String? oldPrice;
  final String storeImagePath;
  ComparisonPrice({Key? key, required this.currentPrice, this.oldPrice, required this.storeImagePath}) : super(key: key);

  var doubleOldPrice = 0.0;
  var doubleCurrentPrice = 0.0;
  @override
  Widget build(BuildContext context) {
    if(oldPrice != null) {
      doubleOldPrice = double.tryParse(oldPrice!) ?? 0.0;
      doubleCurrentPrice = double.tryParse(currentPrice) ?? 0.0;
    }
    return Row(
      children: [
        Image.asset(storeImagePath,width: 22,height: 22,),
        20.pw,
        if(oldPrice != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('€$currentPrice', style: TextStylesInter.textViewMedium15.copyWith(color: black2),),
            Text.rich(TextSpan(
                text: '€$oldPrice',
                style: TextStylesInter.textViewMedium10.copyWith(color: Color.fromRGBO(134, 136, 137, 1),decoration: TextDecoration.lineThrough),
                children: [TextSpan(text: ' €${(doubleOldPrice - doubleCurrentPrice).toStringAsFixed(2)} less',
                  style: TextStylesInter.textViewMedium10.copyWith(color: verdigris, decoration: TextDecoration.none),
                )]
            ))
          ],
        ),
        if(oldPrice == null)
          Text('€$currentPrice', style: TextStylesInter.textViewMedium12.copyWith(color: Color.fromRGBO(134, 136, 137, 1)),)
      ],
    );
  }
}

