
import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bargainb/features/onboarding/presentation/views/onboarding_subscription_screen.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/fifth_onboarding.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/first_onboarding.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/fourth_onboarding.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/second_onboarding.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/sixth_onboarding.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/third_onboarding.dart';
import 'package:bargainb/utils/sounds_manager.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  bool showFAB = true;
  final PageController _pageController = PageController();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: buildFAB(),                                                                  //controlled by second onboarding screen
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
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
                    SecondOnboarding(
                      showFAB: (){
                        if(showFAB == false)
                        setState(() {
                        showFAB = true;
                        });
                      },
                      disableFAB: (){
                        showFAB = false;
                    },),
                    ThirdOnboarding(goToNextPage: goToNextPage,),
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

  Widget? buildFAB() {
    if(pageNumber == 2) return null;
    if(showFAB) {
      return Padding(
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
      );
    }
    return null;
  }

  ScrollPhysics getPhysics() {
    if(pageNumber == 2 || pageNumber == 1)
      return NeverScrollableScrollPhysics();
    return BouncingScrollPhysics();
  }

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
    trackFirstTimeUser();
    if(kReleaseMode)
      sendNewInstallEmail();
    super.initState();
  }

  Future<void> sendNewInstallEmail() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    await post(url,
        headers: {
          "Content-Type": "Application/json",
          'origin': "http://localhost",
        },
        body: jsonEncode({
          'service_id': 'service_in1p4en',
          'template_id': 'template_lso7get',
          'user_id': 'oVDOMhMkZ5BgtIH4g',
          'template_params': {
            'user_name': "BargainB App",
            'user_email': "support@thebargainB.com",
            'user_message': "This is to notify you of a new first time user that installed the app. \n Store: ${packageInfo.installerStore} Package Name: ${packageInfo.packageName}, version: ${packageInfo.version}, Build Number: ${packageInfo.buildNumber}",
          }
        })
    ).catchError((e){
      print(e);
    });
  }


  void trackOnboarding() {
    try {
      TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "Onboarding screen");
    } catch (e) {}
  }

  void trackFirstTimeUser() {
    try {
      TrackingUtils().trackFirstTimeUser(DateTime.now().toUtc().toString());
    } catch (e) {}
  }
}







