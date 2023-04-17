import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/profile_dialog.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class SettingRow extends StatelessWidget {
  final Widget icon;
  final Widget? route;
  final String settingText;
  const SettingRow({
    Key? key,
    required this.icon,
    required this.settingText,
    this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => route != null
          ? AppNavigator.push(context: context, screen: route!)
          : showDialog(
              context: context,
              builder: (ctx) => ProfileDialog(
                    title: LocaleKeys.signout.tr(),
                    body: LocaleKeys.logoutFromAccount.tr(),
                    buttonText: LocaleKeys.signout.tr(),
                    isSigningOut: true,
                  )),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: purple30),
            child: icon,
          ),
          12.pw,
          Text(
            settingText,
            style: TextStyles.textViewMedium14.copyWith(color: black1),
          ),
          Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
          ),
        ],
      ),
    );
  }
}
