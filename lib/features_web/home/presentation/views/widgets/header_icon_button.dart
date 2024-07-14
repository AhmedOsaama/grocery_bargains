import 'package:bargainb/features_web/home/presentation/views/home_web_screen.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderIconButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final WebsitePage selectedPage;
  final WebsitePage pageValue;
  const HeaderIconButton({super.key, required this.iconPath, required this.text, required this.selectedPage, required this.pageValue});

  @override
  Widget build(BuildContext context) {
    var inactiveColor = const Color(0xff99B1F6);
    var activeColor = mainPurple;
    var color = selectedPage == pageValue ? activeColor : inactiveColor;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          SvgPicture.asset(iconPath, color: color,),
          Text(text, style: TextStylesInter.textViewMedium16.copyWith(color: color),),
        ],
      ),
    );
  }
}
