import 'package:audioplayers/audioplayers.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/sounds_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';

class FourthOnboarding extends StatefulWidget {
  FourthOnboarding({Key? key}) : super(key: key);

  @override
  State<FourthOnboarding> createState() => _FourthOnboardingState();
}

class _FourthOnboardingState extends State<FourthOnboarding> {
  bool loading = true;
  late Future userMessageFuture;
  late Future botMessageFuture;

  @override
  void initState() {
    userMessageFuture = Future.delayed(Duration(milliseconds: 500));
    botMessageFuture = Future.delayed(Duration(milliseconds: 2000));
    userMessageFuture.whenComplete(() => AudioPlayer().play(AssetSource(messageSound)));
    botMessageFuture.whenComplete(() => AudioPlayer().play(AssetSource(messageSound)));
    TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "Fourth onboarding screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                future: userMessageFuture,
                builder: (context, snapshot) {
                  var loading = snapshot.connectionState == ConnectionState.waiting;
                  return Container(
                    height: loading ? 0.h : 130.h,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 500),
                          top: loading ? 50 : 0,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: loading ? 0 : 1,
                            child: Image.asset(context.locale.languageCode == "en" ? onboarding_bubble1 : onboarding_bubble1_dutch, width: 270.w,),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            ),
          FutureBuilder(
              future: botMessageFuture,
              builder: (context, snapshot) {
                var loading = snapshot.connectionState == ConnectionState.waiting;
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: loading ? 200.h : 800.h,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              top: loading ? 50 : 0,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: loading ? 0 : 1,
                                child: Image.asset(context.locale.languageCode == "en" ? onboarding_bubble2 : onboarding_bubble2_dutch, width: 330.w,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
          ),
          // FutureBuilder(
          //   future: Future.delayed(Duration(milliseconds: 200),),
          //   builder: (ctx, snapshot){
          //   loading = snapshot.connectionState == ConnectionState.waiting;
          //   return Column(
          //     children: [
          //       Container(
          //         height: loading ? 100.h : 90.h,
          //         child: Stack(
          //           alignment: Alignment.centerRight,
          //           children: [
          //             AnimatedPositioned(
          //               duration: Duration(milliseconds: 500),
          //               top: loading ? 50 : 0,
          //               child: AnimatedOpacity(
          //                 duration: Duration(milliseconds: 500),
          //                 opacity: loading ? 0 : 1,
          //                 child: Image.asset(onboarding_bubble1, width: 270.w,),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Container(
          //         height: loading ? 300.h : 450.h,
          //         child: Stack(
          //           alignment: Alignment.centerRight,
          //           children: [
          //             AnimatedPositioned(
          //               duration: Duration(milliseconds: 500),
          //               top: loading ? 50 : 0,
          //               child: AnimatedOpacity(
          //                 duration: Duration(milliseconds: 500),
          //                 opacity: loading ? 0 : 1,
          //                 child: Image.asset(onboarding_bubble2, width: 330.w,),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   );
          //   }
          // ),
        ],
      ),
    );
  }
}
