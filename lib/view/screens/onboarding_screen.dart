import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/screens/home_screen.dart';
import 'package:swaav/view/screens/main_screen.dart';

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
                Text(
                  LocaleKeys.skip.tr(),
                  style: TextStyles.textViewRegular14
                      .copyWith(color: Color.fromRGBO(82, 75, 107, 1)),
                ),
                // SizedBox(width: 5.w,),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: DotsIndicator(
                    dotsCount: 3,
                    position: pageNumber,
                    decorator: const DotsDecorator(
                      spacing: EdgeInsets.symmetric(horizontal: 3),
                      size: Size.square(7),
                      activeSize: Size.square(7),
                      activeColor: verdigris,
                    ),
                  ),
                ),
                GenericButton(
                  onPressed: () {
                    if(pageNumber == 2) AppNavigator.pushReplacement(context: context, screen: MainScreen());
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
                  color: verdigris,
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

  var slide1 = Column(
    children: [
      SizedBox(
        height: 170.h,
      ),
      SvgPicture.asset(discount),
      Spacer(),
      Text(
        LocaleKeys.findAllTheDiscountsHere.tr(),
        style: TextStyles.textViewSemiBold40.copyWith(color: prussian),
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
      SizedBox(height: 100.h,),
      Text(
        LocaleKeys.createShoppingLists.tr(),
        style: TextStyles.textViewSemiBold40.copyWith(color: prussian),
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
        height: 100.h,
      ),
      SvgPicture.asset(lists),
      Spacer(),
    ],
  );
  var slide3 = Column(
    children: [
      SizedBox(height: 100.h,),
      Text(
        LocaleKeys.shareTheLists.tr(),
        style: TextStyles.textViewSemiBold40.copyWith(color: prussian),
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
        height: 100.h,
      ),
      SvgPicture.asset(sharing),
      Spacer(),
    ],
  );
}
