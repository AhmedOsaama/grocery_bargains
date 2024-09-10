import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bargainb/features/onboarding/presentation/views/widgets/fifth_onboarding_survey.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/first_onboarding_survey.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/second_onboarding_survey.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/third_onboarding_survey.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';

import '../../../../services/hubspot_service.dart';
import 'widgets/fourth_onboarding_survey.dart';
import 'widgets/seventh_onboarding_survey.dart';
import 'widgets/sixth_onboarding_survey.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();

  int _totalPages = 7;

  double _pageNumber = 0;

  String firstName = "";
  String lastName = "";

  bool soloShopper = false;
  int numOfGrownUps = 0;
  int numOfLittleOnes = 0;
  int numOfFurryFriends = 0;

  List<String> selectedGoals = [];

  List<String> selectedStores = [];

  List<String> shoppingList = [];

  List<String> dietaryPreferences = [];

  String selectedBudget = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          title: Image.asset(
            bargainbLogo,
            width: 90.w,
            height: 24.h,
          ),
          leading: _pageNumber > 0
              ? IconButton(
            icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
            onPressed: () {
              if (_pageNumber > 0) {
                _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
              }
            },
          )
              : null),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _pageNumber = page.toDouble();
                  });
                },
                children: [
                  FirstOnboardingSurvey(
                    saveFirstScreenResponses: saveFirstScreenResponses,
                    pageController: _pageController,
                  ),
                  SecondOnboardingSurvey(
                    saveSecondScreenResponses: saveSecondScreenResponses,
                    pageController: _pageController,
                  ),
                  ThirdOnboardingSurvey(
                      pageController: _pageController, saveThirdScreenResponses: saveThirdScreenResponses),
                  FourthOnboardingSurvey(
                      pageController: _pageController, saveFourthScreenResponses: saveFourthScreenResponses),
                  FifthOnboardingSurvey(
                      pageController: _pageController, saveFifthScreenResponses: saveFifthScreenResponses),
                  SixthOnboardingSurvey(
                      pageController: _pageController, saveSixthScreenResponses: saveSixthScreenResponses),
                  SeventhOnboardingSurvey(
                      pageController: _pageController, saveSeventhScreenResponses: saveSeventhScreenResponses)
                ],
              ),
            ),
            15.ph,
            DotsIndicator(
              dotsCount: _totalPages,
              position: _pageNumber,
              decorator: DotsDecorator(
                spacing: const EdgeInsets.symmetric(horizontal: 3),
                size: const Size.square(12),
                activeSize: const Size.square(12),
                activeColor: primaryGreen,
                color: Color(0xff84D187).withOpacity(0.24),
              ),
            ),
            20.ph,
          ],
        ),
      ),
    );
  }

  void saveFirstScreenResponses(String firstName, String lastName) {
    this.firstName = firstName;
    this.lastName = lastName;
    log("First screen Responses: $firstName, $lastName");
  }

  void saveSecondScreenResponses(bool soloShopper, [int? grownUps, int? littleOnes, int? furryFriends]) {
    this.soloShopper = soloShopper;
    if (!soloShopper) {
      numOfGrownUps = grownUps!;
      numOfLittleOnes = littleOnes!;
      numOfFurryFriends = furryFriends!;
    } else {
      numOfGrownUps = 0;
      numOfLittleOnes = 0;
      numOfFurryFriends = 0;
    }
    log("Second screen Responses: ${this.soloShopper}, $numOfGrownUps, $numOfLittleOnes, $numOfFurryFriends");
  }

  void saveThirdScreenResponses(List<String> selectedGoals) {
    this.selectedGoals = selectedGoals;
    log("Third screen Responses: $selectedGoals");
  }

  void saveFourthScreenResponses(List<String> selectedStores) {
    this.selectedStores = selectedStores;
    log("Fourth screen Responses: $selectedStores");
  }

  void saveFifthScreenResponses(List<String> shoppingList) {
    this.shoppingList = shoppingList;
    log("Fifth screen Responses: $shoppingList");
  }

  void saveSixthScreenResponses(List<String> dietaryPreferences) {
    this.dietaryPreferences = dietaryPreferences;
    log("Sixth screen Responses: $dietaryPreferences");
  }

  Future<void> saveSeventhScreenResponses(String selectedBudget) async {
    this.selectedBudget = selectedBudget;
    log("Seventh screen Responses: $selectedBudget");
    var country = "";
    var city = "";
    try {
      var response = await get(Uri.parse("http://ip-api.com/json"));
      if (response.statusCode == 200) {
        var responseMap = jsonDecode(response.body);
        country = responseMap['country'];
        city = responseMap['city'];
      }
    }catch(e){
      log(e.toString());
    }
    HubspotService.createHubspotContact({
      "firstname": firstName,
      'last_name': lastName,
      'country': country,
      'city': city,
      'bargainb_goals': selectedGoals.toString(),
      'dietary_preferences': dietaryPreferences.toString(),
      'favourite_stores': selectedStores.toString(),
      'shopping_list_people': soloShopper ? "One person" : "Grown ups: $numOfGrownUps, Little Ones: $numOfLittleOnes, Furry Friends $numOfFurryFriends",
      'typical_shopping_list': shoppingList.toString(),
      'grocery_monthly_budget': this.selectedBudget.toString(),
      "hubspot_owner_id": "1252705237",
    });
  }
}