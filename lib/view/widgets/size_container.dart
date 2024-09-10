import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class SizeContainer extends StatelessWidget {
  final String itemSize;
  const SizeContainer({Key? key, required this.itemSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 2),
        decoration: BoxDecoration(
            color: primaryGreen,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
          itemSize,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.textViewRegular10
              .copyWith(color: Colors.white),
        ));
  }
}
