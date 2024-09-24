import 'package:flutter/material.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/app_colors.dart';
import 'button.dart';

class MyCloseButton extends StatelessWidget {
  final double? width;
  final Function? onPressed;
  const MyCloseButton({Key? key, this.width, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericButton(
        onPressed: onPressed == null ? () => AppNavigator.pop(context: context) : () => onPressed!(),
        shape: CircleBorder(),
        padding: EdgeInsets.zero,
        width: width ?? 36,
        color: primaryGreen,
        child: Icon(
          Icons.close,
          color: white,
        ));
  }
}
