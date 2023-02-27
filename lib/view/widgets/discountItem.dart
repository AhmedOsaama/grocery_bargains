import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/assets_manager.dart';
import '../../utils/style_utils.dart';

class DiscountItem extends StatelessWidget {
  final String name;
  final String priceBefore;
  final String priceAfter;
  final String measurement;
  final String imageURL;
  const DiscountItem(
      {Key? key,
      required this.name,
      required this.priceBefore,
      required this.priceAfter,
      required this.measurement,
      required this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(235, 235, 235, 1))
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 40.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(imageURL,width: 125.w,height: 80.h,),
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
          if (priceBefore.isEmpty)
            Text("€$priceAfter",
                style: TextStyles.textViewMedium12
                    .copyWith(color: Color.fromRGBO(108, 197, 29, 1))),
          if (priceBefore.isNotEmpty)
            Text.rich(TextSpan(
                text: "€$priceBefore",
                style: TextStyles.textViewMedium12.copyWith(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
                children: [
                  TextSpan(
                    text: "  €$priceAfter",
                    style: TextStyles.textViewMedium12.copyWith(
                        color: Color.fromRGBO(108, 197, 29, 1),
                        decoration: TextDecoration.none),
                  )
                ])),
        ],
      ),
    );
  }
}
