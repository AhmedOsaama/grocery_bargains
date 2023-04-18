import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/screens/profile_screen.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

enum Language { english, dutch }

class SubscriptionScreen extends StatefulWidget {
  SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  var selectedLanguage = Language.english;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // leading: backButt,
        title: Text(
          "Subscription",
          style: TextStyles.textViewSemiBold16.copyWith(color: black1),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
        child: Container(
          height: ScreenUtil().screenHeight / 2,
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 35.h),
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 20),
                color: shadowColor,
                blurRadius: 20.0,
              )
            ],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color.fromRGBO(238, 238, 238, 1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                bee1,
                width: 120.w,
                height: 120.h,
                fit: BoxFit.fill,
              ),
              16.ph,
              Text(
                LocaleKeys.freePlan.tr(),
                style: TextStyles.textViewSemiBold24.copyWith(color: black2),
              ),
              24.ph,
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: yellow,
                  ),
                  5.pw,
                  Text(
                    'Unlimited lists',
                    style: TextStyles.textViewRegular16.copyWith(color: black1),
                  )
                ],
              ),
              10.ph,
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: yellow,
                  ),
                  5.pw,
                  Text(
                    'Unlimited Shared chats',
                    style: TextStyles.textViewRegular16.copyWith(color: black1),
                  )
                ],
              ),
              10.ph,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.star,
                    color: yellow,
                  ),
                  5.pw,
                  Flexible(
                    child: Text(
                      'Unlimited Product searches per month',
                      style:
                          TextStyles.textViewRegular16.copyWith(color: black1),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
