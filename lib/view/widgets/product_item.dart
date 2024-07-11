import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';

import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';

class ProductItemWidget extends StatelessWidget {
  final String price;
  final String brand;
  final int quantity;
  final String oldPrice;
  final String name;
  final String size;
  final String imagePath;
  final bool isAddedToList;
  final String storeName;
  const ProductItemWidget(
      {Key? key,
      required this.price,
      required this.name,
      required this.size,
      required this.imagePath,
      required this.oldPrice,
      required this.isAddedToList,
      required this.storeName, required this.brand, required this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var storeImage = Provider.of<ProductsProvider>(context, listen: false)
        .getImage(storeName);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      // margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: mainPurple),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 4),
                color: Color.fromRGBO(59, 59, 59, 0.12),
                blurRadius: 28)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(checkMark),
          12.pw,
          Image.network(
            imagePath,
            errorBuilder: (ctx,_,i) => SvgPicture.asset(imageError,width: 40,
              height: 40,),
            width: 40,
            height: 40,
          ),
          12.pw,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                brand,
                style: TextStylesInter.textViewSemiBold10.copyWith(color: blackSecondary),
              ),
              5.ph,
              Container(
                width: 100.w,
                child: Text(
                  name,
                  style: TextStylesInter.textViewRegular10.copyWith(color: blackSecondary),
                ),
              ),
              5.ph,
              Row(
                children: [
                  Text(storeName == "Albert" ? "Albert Heijn" : storeName,style: TextStylesInter.textViewMedium10.copyWith(color: Colors.lightBlue),),
                  5.pw,
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 2),
                      decoration: BoxDecoration(
                        color: mainPurple,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        size,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.textViewRegular10
                            .copyWith(color: Colors.white),
                      )),
                ],
              ),
            ],
          ),
          Text("X " + quantity.toString(), style: TextStylesInter.textViewLight12.copyWith(color: blackSecondary),),
          5.pw,
          Text(
                  "€${(double.parse(price) * quantity).toStringAsFixed(2)}",
                  style:
                      TextStylesInter.textViewMedium10.copyWith(color: blackSecondary),
                ),
        ],
      ),
    );
  }
}
