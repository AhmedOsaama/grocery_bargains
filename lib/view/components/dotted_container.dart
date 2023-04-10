import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class DottedContainer extends StatelessWidget {
  final String text;
  const DottedContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      padding: EdgeInsets.all(10),
      strokeCap: StrokeCap.round,
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      dashPattern: [3, 3],
      strokeWidth: 1,
      color: purple50,
      child: Text(
        text,
        style: TextStylesInter.textViewMedium25
            .copyWith(color: purple50),
      ),
    );
  }
}
