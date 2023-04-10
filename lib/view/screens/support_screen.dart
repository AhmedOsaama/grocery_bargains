import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/utils/utils.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/screens/profile_screen.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';
import '../widgets/profile_dialog.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.2,
        title: Text(
          LocaleKeys.support.tr(),
          style: TextStyles.textViewSemiBold16.copyWith(color: black1),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            36.ph,
            Text(
              LocaleKeys.support.tr(),
              style: TextStyles.textViewSemiBold30.copyWith(color: black2),
            ),
            40.ph,
            Text(
              LocaleKeys.yourName.tr(),
              style: TextStylesDMSans.textViewBold12.copyWith(color: black1),
            ),
            10.ph,
            GenericField(
              hintText: "Dina Tairovic",
              boxShadow: Utils.boxShadow[0],
              colorStyle: Color.fromRGBO(237, 237, 237, 1),
            ),
            20.ph,
            Text(
              LocaleKeys.email.tr(),
              style: TextStylesDMSans.textViewBold12.copyWith(color: black1),
            ),
            10.ph,
            GenericField(
              hintText: "dina@me.com",
              boxShadow: Utils.boxShadow[0],
              colorStyle: Color.fromRGBO(237, 237, 237, 1),
            ),
            20.ph,
            Text(
              LocaleKeys.yourName.tr(),
              style: TextStylesDMSans.textViewBold12.copyWith(color: black1),
            ),
            10.ph,
            GenericField(
              hintText: "...",
              boxShadow: Utils.boxShadow[0],
              colorStyle: Color.fromRGBO(237, 237, 237, 1),
            ),
            Spacer(),
            GenericButton(
              onPressed: () {},
              width: double.infinity,
              height: 60.h,
              borderRadius: BorderRadius.circular(6),
              color: yellow,
              child: Text(
                LocaleKeys.submit.tr(),
                style: TextStylesDMSans.textViewSemiBold16.copyWith(color: black2),
              ),
            ),
            10.ph
          ],
        ),
      ),
    );
  }
}
