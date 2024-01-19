import 'dart:convert';
import 'dart:developer';

import 'package:bargainb/features/onboarding/presentation/views/widgets/first_survey.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/fourth_survey.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/second_survey.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/third_survey.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/routes/app_navigator.dart';
import '../../../../utils/app_colors.dart';
import '../../../../view/components/button.dart';
import 'free_trial_screen.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  double pageNumber = 0;
  int _totalPages = 4;
  bool showFAB = false;
  final PageController _pageController = PageController();

  var questionsList = [
    {
      "title": "A Little About You",
      "subtitle": "Let's start with some basics to understand our shoppers better. Your journey, your way.",
      "q1": "What is your age range?",
      "q1_answers": [
        "Below 18",
        "18-25",
        "26-35",
        "36-45",
        "46-55",
        "56+",
      ],
      "q2": "What city do you reside in?",
      "q2_answers": "",
      "q3": "How often do you do grocery shopping?",
      "q3_answers": [
        "Weekly",
        "Bi-weekly",
        "Monthly",
        "Rarely",
      ],
    },
    {
      "title": "Unpacking Your Grocery Habits",
      "subtitle": "Understanding your shopping preferences helps us make BargainB just right for you.",
      "q1": "What is your preferred method of grocery shopping?",
      "q1_answers": [
        "Online",
        "In-store",
        "Both",
      ],
      "q2": "What challenges do you face during grocery shopping? (Select all that apply)",
      "q2_answers": {
        "Time-consuming": false,
        "Finding deals": false,
        "Staying within budget": false,
        "Overwhelming choices": false,
        "Other": false
      },
      "q3": "How do you typically find deals or discounts on groceries? (Select all that apply)",
      "q3_answers": {
        "Online search": false,
        "Store flyers": false,
        "Apps": false,
        "Word of mouth": false,
        "I don't look for deals": false
      },
    },
    {
      "title": "Crafting Your Ideal App",
      "subtitle": "Tell us what features sparkle for you. Your choices help us build a better BargainB.",
      "q1": "Which features would attract you to a grocery shopping app?",
      "q1_answers": [
        "Personalized recommendations",
        "Deal aggregation",
        "Recipe suggestions",
        "Collaborative list sharing",
        "Budget tracking",
        "Other",
      ],
      "q2": "What is most important to you in a grocery shopping app?",
      "q2_answers": [
        "Ease of use",
        "Variety of products",
        "Personalization",
        "Savings and deals",
        "Other",
      ],
      "q3": "What concerns would you have using a new grocery shopping app? (Select all that apply)",
      "q3_answers": {
        "Privacy concerns": false,
        "Technical issues": false,
        "Effectiveness of features": false,
        "Cost": false,
        "Other": false
      },
    },
    {
      "title": "Valuing Your Views",
      "subtitle": "Your opinions on value & concerns are crucial to align BargainB with your expectations",
      "q1": "Would you be interested in a premium version of a grocery app with added features?",
      "q1_answers": [
        "Yes",
        "No",
        "Maybe",
      ],
      "q2": "What is a reasonable monthly subscription price range for a grocery shopping app that helps you save money?",
      "q2_answers": [
        "Under €2",
        "€2-€4",
        "€5-€7",
        "More than €7",
      ],
      "q3": "If BargainB saved you \$50 or more every month, would you be willing to pay?",
      "q3_answers": [
        "€5",
        "€10",
        "€15",
        "€20",
      ],
    },
  ];

  var ageRange = "";
  var city = "";
  var groceryTime = "";

  var groceryMethod = "";
  var groceryChallenges = [];
  var groceryChallengesOther = "";        //other option value
  var discountFindings = [];

  var groceryAttractions = "";
  var groceryInterests = "";
  var groceryConcerns = [];
  var groceryConcernsOther = "";

  var premiumAppInterest = "";
  var monthlySubscriptionPrice = "";
  var monthPayPreference = "";



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: buildFAB(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    FirstSurvey(questionsMap: questionsList[0], saveResponse: saveFirstScreenResponses,),
                    SecondSurvey(questionsMap: questionsList[1],
                      saveResponse: saveSecondScreenResponses,
                      saveGroceryChallengesOther: saveGroceryChallengesOther,
                    ),
                    ThirdSurvey(questionsMap: questionsList[2],
                      saveGroceryAttractions: saveGroceryAttractions,
                      saveGroceryInterests: saveGroceryInterests,
                      saveGroceryConcerns: saveGroceryConcerns,
                      saveGroceryConcernsOther: saveGroceryConcernsOther,
                    ),
                    FourthSurvey(questionsMap: questionsList[3], saveResponse: saveFourthScreenResponses,),
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

  void saveFirstScreenResponses(String ageRange, String city, String groceryTime){
    setState(() {
      this.ageRange = ageRange;
      this.city = city;
      this.groceryTime = groceryTime;
    });
  }

  void saveSecondScreenResponses(String groceryMethod, List groceryChallenges, List discountFindings){
    print(groceryMethod);
    print(groceryChallenges);
    print(discountFindings);
    setState(() {
      this.groceryMethod = groceryMethod;
      this.groceryChallenges = groceryChallenges;
      this.discountFindings = discountFindings;
    });
  }

  void saveGroceryChallengesOther(String groceryChallengesOther){
    print(groceryChallengesOther);
    setState(() {
      this.groceryChallengesOther = groceryChallengesOther;
    });
  }

  void saveGroceryConcernsOther(String groceryConcernsOther){
    groceryConcernsOther = groceryConcernsOther.replaceAll(" ", '');
    print(groceryConcernsOther);
    setState(() {
      this.groceryConcernsOther = groceryConcernsOther;
    });
  }

  void saveGroceryAttractions(String groceryAttractions){
    groceryAttractions = groceryAttractions.replaceAll(" ", '');
    print(groceryAttractions);
    setState(() {
      this.groceryAttractions = groceryAttractions;
    });
}

  void saveGroceryInterests(String groceryInterests){
    groceryInterests = groceryInterests.replaceAll(" ", '');
    print(groceryInterests);
    setState(() {
      this.groceryInterests = groceryInterests;
    });
}
  void saveGroceryConcerns(List groceryConcerns){
    print(groceryConcerns);
    setState(() {
      this.groceryConcerns = groceryConcerns;
    });
}


  void saveFourthScreenResponses(String premiumAppInterest, String monthlySubscriptionPrice, String monthPayPreference){
    setState(() {
      this.premiumAppInterest = premiumAppInterest;
      this.monthlySubscriptionPrice = monthlySubscriptionPrice;
      this.monthPayPreference = monthPayPreference;
    });
  }

  Widget? buildFAB() {
    validateForms();
    if (showFAB) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GenericButton(
          onPressed: () {
            finalizeForm();
            setState(() {
                goToNextPage();
              });
            FocusScope.of(context).unfocus();
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

  void finalizeForm() {
     if(groceryChallenges.contains("Other")){
     groceryChallenges.remove("Other");
     groceryChallenges.add(groceryChallengesOther);
     }
     if(groceryConcerns.contains("Other")){
    groceryConcerns.remove("Other");
    groceryConcerns.add(groceryConcernsOther);
     }
  }

  void validateForms() {
      if(pageNumber == 0 && ageRange.isNotEmpty && city.isNotEmpty && city != "Choose City" && groceryTime.isNotEmpty){
      showFAB = true;
    }else if(pageNumber == 1 && groceryMethod.isNotEmpty && groceryChallenges.isNotEmpty && discountFindings.isNotEmpty){
        groceryChallengesOther = groceryChallengesOther.replaceAll(" ", '');
        print(groceryChallengesOther.isEmpty);
        if(groceryChallenges.contains("Other") && groceryChallengesOther.isEmpty){
      showFAB = false;
        }else{
          showFAB = true;
        }
    }else if(pageNumber == 2 && groceryAttractions.isNotEmpty && groceryInterests.isNotEmpty && groceryConcerns.isNotEmpty){

        if(groceryAttractions == "Other" || groceryInterests == "Other"){
          showFAB = false;
        }else if(groceryConcerns.contains("Other") && groceryConcernsOther.isEmpty){
          showFAB = false;
        }else{
          showFAB = true;
        }
    }else if(pageNumber == 3 && premiumAppInterest.isNotEmpty && monthlySubscriptionPrice.isNotEmpty && monthPayPreference.isNotEmpty){
      showFAB = true;
    }else{
      showFAB = false;
    }
  }

  void goToNextPage() {
    if (pageNumber < _totalPages - 1) {
      _pageController.animateToPage(pageNumber.toInt() + 1,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      pageNumber++;
    } else if (pageNumber >= _totalPages - 1) {
      var contactData = {
        "firstname": "Guest",
        'phone': "Guest Phone",
        'age': ageRange,
        'city': city,
        'grocery_time': groceryTime,

        'grocery_method': groceryMethod,
        'grocery_challenges':  groceryChallenges.toString(),
        "discount_findings": discountFindings.toString(),

        'grocery_attractions': groceryAttractions,
        'grocery_interests': groceryInterests,
        'grocery_concerns': groceryConcerns.toString(),

        'premium_app_interest': premiumAppInterest,
        'monthly_subscription_price': monthlySubscriptionPrice,
        'month_pay_preference': monthPayPreference,
        "hubspot_owner_id": "1252705237",
      };
      if (kReleaseMode) createHubspotContact(contactData);
      if(kDebugMode) log(contactData.toString());
      AppNavigator.pushReplacement(
          context: context,
          screen: FreeTrialScreen());
    }
  }

  Future<void> createHubspotContact(Map userData) async {
    print("creating hubspot contact");
    var contactData = jsonEncode({"properties": userData});
    try {
      var response = await post(
        Uri.parse('https://api.hubapi.com/crm/v3/objects/contacts'),
        headers: {
          'Authorization': 'Bearer pat-eu1-6afeefb9-6630-45c6-b31e-e292f251c251',
          'Content-Type': 'application/json'
        },
        body: contactData,
      );
      if(response.statusCode == 201) {
        var decodedResponse = jsonDecode(response.body);
        print("DONE creating hubspot contact: ${decodedResponse}");
        // var pref = await SharedPreferences.getInstance();
        // pref.setString("hubspot_id", decodedResponse['id']);
      }else{
        log("ERROR CREATING HUBSPOT CONTACT: ${response.statusCode} ---> ${response.body}");
      }
    } catch (e) {
      print(e);
    }
  }

}
