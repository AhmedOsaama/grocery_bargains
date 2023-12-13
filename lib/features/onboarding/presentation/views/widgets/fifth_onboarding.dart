import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';

class FifthOnboarding extends StatefulWidget {
  FifthOnboarding({Key? key}) : super(key: key);

  @override
  State<FifthOnboarding> createState() => _FifthOnboardingState();
}

class _FifthOnboardingState extends State<FifthOnboarding> {
  bool loading = true;

  @override
  void initState() {
    TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "Fifth onboarding screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Share BargainB today!".tr(),
          style: TextStylesInter.textViewBold26,
        ),
        10.ph,
        Text(
          'Let your family and friends in on the secret to smarter grocery shopping. '.tr(),
          style: TextStylesInter.textViewSemiBold16,
          textAlign: TextAlign.center,
        ),
        10.ph,
        Text(
          'Spread the savings and culinary delights',
          style: TextStylesInter.textViewLight15,
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
