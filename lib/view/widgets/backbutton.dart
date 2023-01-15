import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/icons_manager.dart';

class MyBackButton extends StatelessWidget {
  final Function()? onTap;
  const MyBackButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap ?? (){
          AppNavigator.pop(context: context);
        },
        child: SvgPicture.asset(backIcon));
  }
}
