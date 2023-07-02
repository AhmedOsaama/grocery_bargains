import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../screens/main_screen.dart';
import 'generic_field.dart';

class SearchWidget extends StatelessWidget {
  final bool isNotificationOpened;
  final bool isBackButton;
  const SearchWidget({Key? key, this.isNotificationOpened = false, required this.isBackButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // isBackButton ? 15.pw : Container(),
        isBackButton ?
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isNotificationOpened ? () => AppNavigator.pushReplacement(
              context: context, screen: MainScreen()) : () => AppNavigator.pop(context: context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(isBackButton)
              Icon(Icons.arrow_back_ios,color: mainPurple,),
              SvgPicture.asset(bargainbIcon,height: 42.h,),
            ],
          ),
        ) :  SvgPicture.asset(bargainbIcon,height: 42.h,),

        6.pw,
        Expanded(
          child: GestureDetector(
            onTap: () async {
              SharedPreferences pref =
              await SharedPreferences.getInstance();
              return showSearch(
                  context: context,
                  delegate: MySearchDelegate(pref, true));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 12.h),
              decoration: BoxDecoration(
                color: white,
                border: Border.all(color: grey),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.search,color: Colors.black,),
                  10.pw,
                  Text(LocaleKeys.whatAreYouLookingFor.tr(),style: TextStyles.textViewSemiBold14
                      .copyWith(color: greyText),)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
