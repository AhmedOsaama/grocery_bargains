import 'package:flutter/material.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/app_colors.dart';
import 'button.dart';

class MyCloseButton extends StatelessWidget {
  const MyCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericButton(onPressed: () => AppNavigator.pop(context: context),
        shape: CircleBorder(),
        padding: EdgeInsets.zero,
        width: 36,
        color: purple70, child: Icon(Icons.close,color: white,));
  }
}
