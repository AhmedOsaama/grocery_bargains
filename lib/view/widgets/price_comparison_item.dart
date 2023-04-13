import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 32,
            offset: Offset(0, 5),
            color: Color.fromRGBO(59, 59, 59, 0.12),
          ),
        ],
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Image.asset(
            storeImagePath,
            width: 50,
            height: 50,
          ),
          SizedBox(
            width: 20.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(
                  text: "€",
                  style:
                      TextStyles.textViewRegular20.copyWith(color: verdigris),
                  children: [
                    TextSpan(
                        text: price,
                        style: TextStyles.textViewBold23
                            .copyWith(color: verdigris))
                  ])),
              Text(
                size,
                style: TextStyles.textViewLight12
                    .copyWith(color: const Color.fromRGBO(62, 62, 62, 1)),
              ),
              SizedBox(
                height: 5.h,
              ),
              // Container(
              //   padding: EdgeInsets.all(3),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(15),
              //     border: Border.all(color: verdigris),
              //   ),
              //   child: Text("2 for € 4",style: TextStyles.textViewMedium10.copyWith(color: verdigris),),
              // )
            ],
          ),
          Spacer(),
          // PlusButton(onTap: (){}),
          // SizedBox(width: 20.w,),
          // Icon(Icons.arrow_forward_ios,)
        ],
      ),
    );
  }
}
