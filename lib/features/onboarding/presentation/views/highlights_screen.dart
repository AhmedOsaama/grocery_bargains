import 'dart:developer';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/onboarding/presentation/views/policy_screen.dart';
import 'package:bargainb/features/onboarding/presentation/views/terms_of_service_screen.dart';
import 'package:bargainb/features/registration/presentation/views/login_screen.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'highlights_screen.dart';
import 'welcome_screen.dart';

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  int _currentPage = 0;
  PageController _pageController = PageController();
  var highlights = [
    {
      "title": "Shop Smart, Save Big",
      "subtitle": "Find deals, build lists, & save big at your favorite stores with our AI assistant",
      "image": highlight1
    },
    {
      "title": "Tailored Just for You",
      "subtitle": "Set your dietary preferences & shopping habits to get personalized recommendations & deals",
      "image": highlight2
    },
    {
      "title": "Shop Together, Save Together",
      "subtitle": "Share lists and deals with family and friends. Collaborate on finding the best prices",
      "image": highlight3
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        allowImplicitScrolling: true,
        onPageChanged: (pageNumber) {
          setState(() {
            _currentPage = pageNumber;
          });
        },
        children: highlights
            .map((highlight) => Stack(
          children: [
            Image.asset(highlight['image']!),
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.transparent, Color(0xff081609)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    highlight['title']!.tr(),
                    style: TextStyles.textViewSemiBold24.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  10.ph,
                  Text(
                    highlight['subtitle']!.tr(),
                    style: TextStyles.textViewRegular18.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  DotsIndicator(
                    dotsCount: 3,
                    position: _currentPage.toDouble(),
                    decorator: DotsDecorator(
                        color: const Color(0xff84D187).withOpacity(0.24),
                        size: const Size(12, 12),
                        activeSize: const Size(12, 12),
                        activeColor: const Color(0xff00B207)),
                  ),
                  16.ph,
                  GenericButton(
                    onPressed: () {
                      log(_pageController.page.toString());
                      if (_pageController.page! < 2) {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                      }
                      else if(_pageController.page! >= 2){
                        AppNavigator.pushReplacement(context: context, screen: const WelcomeScreen());
                      }
                    },
                    width: double.infinity,
                    height: 48,
                    color: primaryGreen,
                    borderRadius: BorderRadius.circular(6),
                    child: Text(
                      "Get Started".tr(),
                      style: TextStylesInter.textViewMedium16,
                    ),
                  ),
                  15.ph,
                  GenericButton(
                    onPressed: () {
                      AppNavigator.push(context: context, screen: const LoginScreen());
                    },
                    width: double.infinity,
                    height: 48,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    child: Text(
                      "I got an account, Log me in".tr(),
                      style: TextStylesInter.textViewMedium16.copyWith(color: Colors.black),
                    ),
                  ),
                  10.ph,
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                        text: "By logging or registering you agree to our ".tr(),
                        style: TextStylesInter.textViewRegular12.copyWith(color: Colors.white),
                        children: [
                          TextSpan(
                              text: "Terms of Service".tr(),
                              style: const TextStyle(color: Colors.brown),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => AppNavigator.push(context: context, screen: TermsOfServiceScreen())),
                          TextSpan(
                            text: " and ".tr(),
                          ),
                          TextSpan(
                              text: "Privacy Policy".tr(),
                              style: const TextStyle(color: Colors.brown),
                              recognizer: TapGestureRecognizer()..onTap = () => AppNavigator.push(context: context, screen: PolicyScreen()))
                        ]),
                  ),
                  20.ph,
                ],
              ),
            )
          ],
        ))
            .toList(),
      ),
    );
  }
}