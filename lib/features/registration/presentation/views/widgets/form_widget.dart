import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/style_utils.dart';
import '../../../../../utils/validator.dart';
import '../../../../../view/components/generic_field.dart';

class FormWidget extends StatelessWidget {
  final Widget textField;
  final String title;
  const FormWidget({super.key, required this.title, required this.textField});
  final greyColor = const Color(0xff7C7C7C);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 427,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStylesInter.textViewMedium16
                .copyWith(color: greyColor),
            textAlign: TextAlign.center,
          ),
          10.ph,
          textField
        ],
      ),
    );
  }
}
