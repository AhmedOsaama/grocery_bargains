
import 'package:bargainb/features/onboarding/presentation/views/onboarding_subscription_screen.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/fifth_onboarding.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/first_onboarding.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/fourth_onboarding.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/second_onboarding.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/sixth_onboarding.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/third_onboarding.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_navigator.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/tracking_utils.dart';
import '../../../../view/components/button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  double pageNumber = 0;
  int _totalPages = 6;
  final PageController _pageController = PageController();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GenericButton(
            onPressed: () {
              if (pageNumber == 2) (){};
              else setState(() {
                goToNextPage();
              });
            },
            width: 60,
            height: 60,
            borderRadius: BorderRadius.circular(20),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            color: brightOrange,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                  physics: getPhysics(),
                  children: [
                    FirstOnboarding(),
                    SecondOnboarding(),
                    ThirdOnboarding(goToNextPage: goToNextPage),
                    FourthOnboarding(),
                    FifthOnboarding(),
                    SixthOnboarding(),
                  ],
                ),
              ),
              Container(
                child: DotsIndicator(
                  dotsCount: _totalPages,
                  position: pageNumber,
                  decorator: const DotsDecorator(
                    spacing: EdgeInsets.symmetric(horizontal: 3),
                    size: Size.square(7),
                    activeSize: Size.square(7),
                    activeColor: brightOrange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ScrollPhysics getPhysics() => pageNumber == 2 ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics();

  void goToNextPage() {
    if (pageNumber < _totalPages - 1) {
      _pageController.animateToPage(pageNumber.toInt() + 1,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      pageNumber++;
    }else if(pageNumber >= _totalPages - 1){
      AppNavigator.pushReplacement(context: context, screen: OnboardingSubscriptionScreen(isChangingPlan: false,));
    }
  }

  @override
  void initState() {
    trackOnboarding();
    super.initState();
  }

  void trackOnboarding() {
    try {
      TrackingUtils().trackPageView(
          FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Onboarding screen");
    } catch (e) {}
  }
}







