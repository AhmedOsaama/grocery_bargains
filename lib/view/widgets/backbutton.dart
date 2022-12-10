import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/icons_manager.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
        onTap: (){
          AppNavigator.pop(context: context);
        },
        child: SvgPicture.asset(backIcon));
  }
}
