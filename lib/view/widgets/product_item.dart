import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/view/components/plus_button.dart';
import 'package:bargainb/view/screens/profile_screen.dart';

import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';

class ProductItemWidget extends StatelessWidget {
  final String price;
  final String oldPrice;
  final String name;
  final String size;
  final String imagePath;
  final bool isAddedToList;
  final String storeName;
  final Function onTap;
  const ProductItemWidget(
      {Key? key,
      required this.price,
      required this.name,
      required this.size,
      required this.imagePath,
      required this.oldPrice,
      required this.onTap,
      required this.isAddedToList,
      required this.storeName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var storeImage = Provider.of<ProductsProvider>(context, listen: false)
        .getImage(storeName);
    return Container(
      // width: 174.w,
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Center(
                  child: Image.network(
                imagePath,
                width: 40,
                height: 40,
              )),
              SizedBox(
                height: 18.h,
              ),
              Container(
                  width: 130.w,
                  child: Text(
                    name,
                    style: TextStyles.textViewBold16.copyWith(color: prussian),
                  )),
              SizedBox(
                height: 5.h,
              ),
              Container(
                  width: 130.w,
                  child: Text(
                    size,
                    style: TextStyles.textViewSemiBold14
                        .copyWith(color: Colors.grey),
                  )),
              SizedBox(
                height: 17.h,
              ),
              oldPrice.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "€$price",
                              style: TextStyles.textViewMedium15
                                  .copyWith(color: prussian),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "€$oldPrice",
                                  style: TextStyles.textViewMedium10.copyWith(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  "€${(double.tryParse(oldPrice) ?? 0 - double.tryParse(price)!).toStringAsFixed(2)}${"Less".tr()}",
                                  style: TextStyles.textViewMedium10
                                      .copyWith(color: verdigris),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Text(
                      "€$price",
                      style:
                          TextStyles.textViewMedium15.copyWith(color: prussian),
                    ),
              SizedBox(
                height: 10.w,
              ),
            ],
          ),
          20.pw,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                storeImage,
                width: 20,
                height: 20,
              ),
              100.ph,
              isAddedToList
                  ? SvgPicture.asset(checkMark)
                  : PlusButton(onTap: () => onTap())
            ],
          )
        ],
      ),
    );
  }
}
