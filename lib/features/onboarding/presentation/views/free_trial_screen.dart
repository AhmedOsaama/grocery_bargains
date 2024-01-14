import 'dart:developer';

import 'package:bargainb/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes/app_navigator.dart';
import '../../../../providers/tutorial_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../../services/purchase_service.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/assets_manager.dart';
import '../../../../utils/tracking_utils.dart';
import '../../../../view/components/button.dart';

class FreeTrialScreen extends StatelessWidget {
  const FreeTrialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 110),
                child: Text(
                  "Your Free Trial Awaits!".tr(),
                  textAlign: TextAlign.center,
                  style: TextStylesInter.textViewBold26,
                ),
              ),
              15.ph,
              Text(
                "Thanks for sharing your insights! You're all set to dive into your one-month free trial of BargainB."
                    " Start exploring and enjoy the savings!".tr(),
                textAlign: TextAlign.center,
                style: TextStylesInter.textViewRegular14,
              ),
              60.ph,
              Image.asset(onboarding1),
              100.ph,
              GenericButton(
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                  color: brightOrange,
                  height: 60,
                  onPressed: () async {
                    await initiateFreeSubscription(context);
                    AppNavigator.pushReplacement(context: context, screen: OnBoardingScreen());
                  },
                  child: Text(
                    "Begin Free Trial".tr(),
                    style: TextStylesInter.textViewSemiBold16,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initiateFreeSubscription(BuildContext context) async {
     final offerings = await PurchaseApi.fetchOffers();
    bool hasPurchased = false;
    if (offerings.isEmpty) {
      print("No plans found");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Couldn't fetch plans from Google or Apple store. Please try again later")));
    } else {
      final packages = offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();
        hasPurchased = await PurchaseApi.purchasePackage(packages[0]).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Couldn't buy the monthly package")));
          AppNavigator.pop(context: context);
        });
    }
    if(hasPurchased){
      trackSubscription();
      AppNavigator.pushReplacement(context: context, screen: OnBoardingScreen());
    }
  }
  void trackSubscription() {
    try {
      TrackingUtils().trackSubscriptionAction(
          "Guest", DateTime.now().toUtc().toString(), "Free Trial Subscription Screen",
          "Monthly", "Free");
    }catch(e){
      print("Failed to track subscription: $e");
    }
  }
}
