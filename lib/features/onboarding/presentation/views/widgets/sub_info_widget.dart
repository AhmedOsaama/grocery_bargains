import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
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
              Text(title.tr(), style: TextStylesInter.textViewBold14,),
              5.ph,
              Text(subTitle.tr(), style: TextStylesInter.textViewRegular12,),
            ],
          ),
        ),
      ],
    );
  }
}
