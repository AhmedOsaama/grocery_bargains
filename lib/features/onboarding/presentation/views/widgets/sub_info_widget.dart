import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';

class SubInfoWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;
  const SubInfoWidget({super.key, required this.title, required this.subTitle, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(imagePath),
        15.pw,
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStylesInter.textViewBold14,),
              5.ph,
              Text(subTitle, style: TextStylesInter.textViewRegular12,),
            ],
          ),
        ),
      ],
    );
  }
}
