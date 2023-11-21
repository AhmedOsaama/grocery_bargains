import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/components/dotted_container.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../view/widgets/invite_members_dialog.dart';

class AddFriendsWidget extends StatelessWidget {
  AddFriendsWidget({
    required this.showInviteDialog,
    super.key,
  });

  Function showInviteDialog = (){};

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottedBorder(
        strokeCap: StrokeCap.round,
        borderType: BorderType.RRect,
        radius: Radius.circular(10),
        dashPattern: [3, 3],
        strokeWidth: 1,
        color: Color(0xFF7192F2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                messagesPlaceholder,
                width: 130,
              ),
              15.ph,
              Container(
                width: 218.w,
                // padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  LocaleKeys.addYourFriendsAndFamily.tr(),
                  textAlign: TextAlign.center,
                  style: TextStylesInter.textViewMedium14.copyWith(
                    color: blackSecondary,
                  ),
                ),
              ),
              20.ph,
              GenericButton(
                  borderRadius: BorderRadius.circular(6),
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  color: brightOrange,
                  onPressed: () => showInviteDialog(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocaleKeys.add.tr(),
                        style: TextStyles.textViewSemiBold16,
                      ),
                      10.pw,
                      SvgPicture.asset(newperson),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
