import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swaav/view/screens/profile_screen.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';

class ProfileDialog extends StatelessWidget {
  final String title;
  final String body;
  final String buttonText;
  const ProfileDialog({Key? key, required this.title, required this.body, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$title ?', style: TextStyles.textViewSemiBold28.copyWith(color: black2),),
                10.ph,
                Text(body, style: TextStyles.textViewRegular16.copyWith(color: Color.fromRGBO(72, 72, 72, 1)),),
                10.ph,
                Row(
                  children: [
                    Expanded(child: GenericButton(
                        color: Colors.white,
                        height: 60.h,
                        borderColor: Color.fromRGBO(237, 237, 237, 1),
                        borderRadius: BorderRadius.circular(6),
                        onPressed: (){}, child: Text(LocaleKeys.cancel.tr(),style: TextStyles.textViewSemiBold16.copyWith(color: black2),))),
                    10.pw,
                    Expanded(child: GenericButton(
                        color: yellow,
                        height: 60.h,
                        borderRadius: BorderRadius.circular(6),
                        onPressed: (){}, child: Text(buttonText,style: TextStyles.textViewSemiBold16.copyWith(color: black2),))),
                  ],
                )
              ],
            ),
          ),
        );
  }
}
