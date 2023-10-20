import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';

import '../../utils/style_utils.dart';

class InsightOverview extends StatelessWidget {
  final String type;
  final String value;
  final String info;
  final Color infoColor;
  const InsightOverview({Key? key, required this.type, required this.value, required this.info, required this.infoColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(type, style: TextStylesInter.textViewMedium14.copyWith(color: Color(0xFFC2D0FA)),),
        5.ph,
        Text(value, style: TextStylesInter.textViewSemiBold20,),
        5.ph,
        SizedBox(
          width: 130,
            child: Text(info,
              textAlign: TextAlign.center, style: TextStylesInter.textViewSemiBold12.copyWith(color: infoColor),))
      ],
    );
  }
}
