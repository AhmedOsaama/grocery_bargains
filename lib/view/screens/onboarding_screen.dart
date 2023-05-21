import 'dart:io';

import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/screens/location_access_screen.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  double pageNumber = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    pageNumber = page.toDouble();
                  });
                },
                physics: const BouncingScrollPhysics(),
                children: [slide1, slide2, slide3],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => finishOnBoarding(context),
                  child: Text(
                    LocaleKeys.skip.tr(),
                    style: TextStyles.textViewRegular14
                        .copyWith(color: Color.fromRGBO(113, 146, 242, 1)),
                  ),
                ),
                Container(
                  child: DotsIndicator(
                    dotsCount: 3,
                    position: pageNumber,
                    decorator: const DotsDecorator(
                      spacing: EdgeInsets.symmetric(horizontal: 3),
                      size: Size.square(7),
                      activeSize: Size.square(7),
                      activeColor: yellow,
                    ),
                  ),
                ),
                GenericButton(
                  onPressed: () {
                    if (pageNumber == 2) finishOnBoarding(context);
                    setState(() {
                      if (pageNumber < 2) {
                        _pageController.animateToPage(pageNumber.toInt() + 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                        pageNumber++;
                      }
                    });
                  },
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(20),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  color: yellow,
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveFirstTimePref() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool("firstTime", false);
  }

  void finishOnBoarding(BuildContext context) {
    Platform.isIOS
        ? AppNavigator.pushReplacement(
            context: context, screen: LocationAccessScreen())
        : AppNavigator.pushReplacement(context: context, screen: MainScreen());
  }

  var slide1 = Column(
    children: [
      SizedBox(
        height: 100.h,
      ),
      SvgPicture.asset(bargainbIcon),
      30.ph,
      Image.asset(onboarding1),
      Spacer(),
      Text(
        LocaleKeys.findAllTheDiscountsHere.tr(),
        style: TextStyles.textViewSemiBold30.copyWith(color: prussian),
      ),
      SizedBox(
        height: 18.h,
      ),
      Text(
        LocaleKeys.exploreAllTheLatest.tr(),
        style: TextStyles.textViewRegular14.copyWith(color: gunmetal),
      ),
    ],
  );

  var slide2 = Column(
    children: [
      SizedBox(
        height: 80.h,
      ),
      SvgPicture.asset(bargainbIcon),
      30.ph,
      Text(
        LocaleKeys.chatWithFriends.tr(),
        style: TextStyles.textViewSemiBold30.copyWith(color: prussian),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 20.h,
      ),
      Text(
        LocaleKeys.easilyAddItems.tr(),
        style: TextStyles.textViewRegular14.copyWith(color: gunmetal),
      ),
      SizedBox(
        height: 40.h,
      ),
      Image.asset(onboarding2),
    ],
  );
  var slide3 = Column(
    children: [
      SizedBox(
        height: 70.h,
      ),
      SvgPicture.asset(bargainbIcon),
      30.ph,
      Text(
        LocaleKeys.comparePricesAndLatest.tr(),
        style: TextStyles.textViewSemiBold30.copyWith(color: prussian),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 20.h,
      ),
      Text(
        LocaleKeys.easilyAddFriends.tr(),
        style: TextStyles.textViewRegular14.copyWith(color: gunmetal),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 20.h,
      ),
      Image.asset(onboarding3),
      Spacer(),
    ],
  );
}
