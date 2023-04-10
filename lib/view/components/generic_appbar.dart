import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';

import '../widgets/backbutton.dart';

class GenericAppBar extends StatelessWidget {
  final String appBarTitle;
  final List<Widget>? actions;
  const GenericAppBar({Key? key, required this.appBarTitle, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MyBackButton(),
        Spacer(),
        Text(appBarTitle,style: TextStyles.textViewMedium20.copyWith(color: Color.fromRGBO(61, 62, 59, 1)),),
        Spacer(),
        ...actions ?? [],
      ],
    );
  }
}
