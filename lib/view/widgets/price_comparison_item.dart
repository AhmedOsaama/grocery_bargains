import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class PriceComparisonItem extends StatelessWidget {
  final String price;
  final String size;
  final String storeImagePath;
  const PriceComparisonItem(
      {Key? key,
      required this.price,
      required this.size,
      required this.storeImagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: isSameStore ? BorderRadius.circular(3) : null,
        border: Border(bottom: BorderSide(color: purple30)),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          storeImagePath == imageError ?
          SvgPicture.asset(
            storeImagePath,
            width: 50,
            height: 50,
          ) : Image.asset(
            storeImagePath,
            width: 50,
            height: 50,
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "€$price",
                style:
                TextStylesInter.textViewBold18.copyWith(color: blackSecondary),
              ),
              Text(
                size,
                style: TextStyles.textViewMedium10
                    .copyWith(color: greyText),
              ),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: purple30)
              ),
              child: Icon(Icons.arrow_forward_ios,color: primaryGreen,)),
        ],
      ),
    );
  }
}
