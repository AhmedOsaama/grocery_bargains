import 'package:audioplayers/audioplayers.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/sounds_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';

class FifthOnboarding extends StatefulWidget {
  FifthOnboarding({Key? key}) : super(key: key);

  @override
  State<FifthOnboarding> createState() => _FifthOnboardingState();
}

class _FifthOnboardingState extends State<FifthOnboarding> {
  bool loading = true;
  late Future userMessageFuture;
  late Future botMessageFuture;
  @override
  void initState() {
    userMessageFuture = Future.delayed(Duration(milliseconds: 500));
    botMessageFuture = Future.delayed(Duration(milliseconds: 2000));
    userMessageFuture.whenComplete(() => AudioPlayer().play(AssetSource(messageSound)));
    botMessageFuture.whenComplete(() => AudioPlayer().play(AssetSource(messageSound)));
    TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "Fifth onboarding screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
              future: userMessageFuture,
              builder: (context, snapshot) {
                var loading = snapshot.connectionState == ConnectionState.waiting;
                return Container(
                  height: loading ? 0.h : 100.h,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        top: loading ? 50 : 0,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: loading ? 0 : 1,
                          child: Image.asset(onboarding_bubble3, width: 270.w,),
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
                      20.ph,
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
                                child: Image.asset(onboarding_bubble4, width: 330.w,),
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
        ],
      ),
    );
  }
}
