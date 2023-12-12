import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';

class FourthOnboarding extends StatelessWidget {
  FourthOnboarding({Key? key}) : super(key: key);
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Feeling Hungry?".tr(),
          style: TextStylesInter.textViewBold26,
          textAlign: TextAlign.center,
        ),
        10.ph,
        Text(
          'Not sure what to do with those leftover groceries?'.tr(),
          style: TextStylesInter.textViewSemiBold16,
          textAlign: TextAlign.center,
        ),
        10.ph,
        Text(
          'Let BargainB turn them into a delicious meal',
          style: TextStylesInter.textViewLight15,
          textAlign: TextAlign.center,
        ),
        FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 200),),
          builder: (ctx, snapshot){
          loading = snapshot.connectionState == ConnectionState.waiting;
          return Column(
            children: [
              Container(
                height: loading ? 100.h : 90.h,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      top: loading ? 50 : 0,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: loading ? 0 : 1,
                        child: Image.asset(onboarding_bubble1, width: 270.w,),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: loading ? 300.h : 450.h,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      top: loading ? 50 : 0,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: loading ? 0 : 1,
                        child: Image.asset(onboarding_bubble2, width: 330.w,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          }
        ),
      ],
    );
  }
}
