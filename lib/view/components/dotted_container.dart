import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../utils/style_utils.dart';

class DottedContainer extends StatelessWidget {
  final String text;
  const DottedContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      strokeCap: StrokeCap.round,
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      dashPattern: [3, 3],
      strokeWidth: 1,
      color: Color(0xFF7192F2),
      child: Text(
        text,
        style: TextStylesInter.textViewMedium23.copyWith(color: Color(0xFF3463ED)),
      ),
    );
  }
}
