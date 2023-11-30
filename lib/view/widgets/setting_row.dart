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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: purple10),
              child: icon,
            ),
            12.pw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  settingText,
                  style: TextStylesInter.textViewMedium16,
                ),
                value != null && value!.isNotEmpty
                    ? Text(
                        value!,
                        style:
                            TextStylesInter.textViewRegular13.copyWith(color: Color(0xFF7C7C7C)),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
