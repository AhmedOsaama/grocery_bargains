import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/screens/profile_screen.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../widgets/backbutton.dart';

enum Language {
  english,
  dutch
}

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          LocaleKeys.settings.tr(),
          style: TextStyles.textViewSemiBold16.copyWith(color: black1),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.ph,
            Text(LocaleKeys.subscription.tr(),style: TextStyles.textViewSemiBold30.copyWith(color: black2),),
            18.ph,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 35.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color.fromRGBO(238, 238, 238, 1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: purple30
                        ),
                        child: SvgPicture.asset(beeBlack),
                      ),
                      16.pw,
                      Text(LocaleKeys.freePlan.tr(),style: TextStyles.textViewSemiBold24.copyWith(color: black2),),
                    ],
                  ),
                  24.ph,
                  Row(
                    children: [
                      Icon(Icons.star, color: yellow,),
                      5.pw,
                      Text('3 lists',style: TextStyles.textViewRegular16.copyWith(color: black1),)
                    ],
                  ),
                  10.ph,
                  Row(
                    children: [
                      Icon(Icons.star, color: yellow,),
                      5.pw,
                      Text('5 Shared chats',style: TextStyles.textViewRegular16.copyWith(color: black1),)
                    ],
                  ),
                  10.ph,
                  Row(
                    children: [
                      Icon(Icons.star, color: yellow,),
                      5.pw,
                      Text('50 per month searches',style: TextStyles.textViewRegular16.copyWith(color: black1),)
                    ],
                  ),
                ],
              ),
            ),
            40.ph,
            Text(LocaleKeys.language.tr(), style: TextStyles.textViewSemiBold18.copyWith(color: black2),),
            10.ph,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color.fromRGBO(238, 238, 238, 1)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocaleKeys.english.tr(),style: TextStyles.textViewMedium14.copyWith(color: black1),),
                      Radio(value: Language.english, groupValue: selectedLanguage, onChanged: (_){
                        setState(() {
                          selectedLanguage = Language.english;
                        });
                      })
                    ],
                  ),
                  5.ph,
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(LocaleKeys.dutch.tr(),style: TextStyles.textViewMedium14.copyWith(color: black1),),
                      Radio(value: Language.dutch, groupValue: selectedLanguage, onChanged: (_){
                        setState(() {
                          selectedLanguage = Language.dutch;
                        });
                      })
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            GenericButton(onPressed: (){},
              width: double.infinity,
              height: 60.h,
              borderRadius: BorderRadius.circular(6),
              borderColor: Color.fromRGBO(137, 137, 137, 1),
              child: Text(LocaleKeys.deleteMyAccount.tr(),
              style: TextStylesDMSans.textViewBold14.copyWith(color: black2),),color: Colors.white,),
            10.ph,
          ],
        ),
      ),
    );
  }
}
