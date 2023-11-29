import 'package:flutter/material.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';

import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class SettingRow extends StatelessWidget {
  final Widget icon;

  final VoidCallback onTap;
  final String settingText;
  final String? value;
  const SettingRow(
      {Key? key,
      required this.icon,
      required this.settingText,
      this.value,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: purple30),
            child: icon,
          ),
          12.pw,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                settingText,
                style: TextStyles.textViewMedium14.copyWith(color: Colors.grey),
              ),
              value != null && value!.isNotEmpty
                  ? Text(
                      value!,
                      style:
                          TextStyles.textViewMedium12.copyWith(color: black1),
                    )
                  : Container(),
            ],
          ),
          Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: mainPurple,
          ),
        ],
      ),
    );
  }
}
