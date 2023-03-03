import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/view/screens/lists_screen.dart';
import 'package:swaav/view/screens/profile_screen.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';

class SettingRow extends StatelessWidget {
  final Widget icon;
  final Widget? route;
  final String settingText;
  const SettingRow({Key? key, required this.icon, required this.settingText, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => route != null ? AppNavigator.push(context: context, screen: route!) : (){},
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: purple30
            ),
            child: icon,
          ),
          12.pw,
          Text(settingText,style: TextStyles.textViewMedium14.copyWith(color: black1),),
          Spacer(),
          const Icon(Icons.arrow_forward_ios,size: 18,),
        ],
      ),
    );
  }
}
