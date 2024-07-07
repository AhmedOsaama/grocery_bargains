import 'dart:developer';
import 'dart:io';

import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/providers/subscription_provider.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../config/routes/app_navigator.dart';
import '../../../../providers/tutorial_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../../services/purchase_service.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/assets_manager.dart';
import '../../../../utils/tracking_utils.dart';
import '../../../../view/components/button.dart';

class FreeTrialScreen extends StatefulWidget {
  const FreeTrialScreen({Key? key}) : super(key: key);

  @override
  State<FreeTrialScreen> createState() => _FreeTrialScreenState();
}

class _FreeTrialScreenState extends State<FreeTrialScreen> {

  @override
  void initState() {
    super.initState();
    TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "Begin Trial Screen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Your Free Trial Awaits!".tr(),
                    textAlign: TextAlign.center,
                    style: TextStylesInter.textViewBold26,
                  ),
                ),
                15.ph,
                Text(
                  "Thanks for sharing your insights! You're all set to dive into your one-month free trial of BargainB. Start exploring and enjoy the savings! Here's what happens next:"
                      .tr(),
                  textAlign: TextAlign.center,
                  style: TextStylesInter.textViewRegular14,
                ),
                10.ph,
                Text(
                  "Enjoy Your Trial".tr(),
                  style: TextStylesInter.textViewSemiBold17,
                  textAlign: TextAlign.center,
                ),
                10.ph,
                Text(
                  """•Uninterrupted Access: Full features, zero charges for 1 month.
•Reminder: Look out for our notification before your trial period ends."""
                      .tr(),
                  style: TextStylesInter.textViewRegular14,
                ),
                Image.asset(onboarding1, width: 324.w, height: 250.h,),
                Text(
                  "After Your Trial".tr(),
                  style: TextStylesInter.textViewBold13,
                ),
                10.ph,
                Text(
                  """•Subscription Fee: Only 2.99/month after the free trial.
•Automatic Enrollment: Your subscription starts automatically after the free trial unless cancelled.
•Cancel Anytime: Change your mind? Cancel easily within the app settings or contact support."""
                      .tr(),
                  style: TextStylesInter.textViewRegular13,
                ),
                10.ph,
                GenericButton(
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(10),
                    color: brightOrange,
                    height: 60,
                    onPressed: () async {
                      await initiateFreeSubscription(context);
                      // AppNavigator.pushReplacement(context: context, screen: OnBoardingScreen());
                    },
                    child: Text(
                      "Begin Free Trial".tr(),
                      style: TextStylesInter.textViewSemiBold16,
                    )),
                10.ph,
                Text(
                  """By starting the free trial, you agree to the Terms of Service and acknowledge that the subscription will automatically renew each month at \$2.99 unless cancelled. You can cancel your subscription anytime by going to your account settings. This must be done 24 hours before the end of the trial or any subscription period to avoid being charged."""
                      .tr(),
                  style: TextStylesInter.textViewLight12.copyWith(fontStyle: FontStyle.italic),
                )
              ],
            ),
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
      if(Platform.isAndroid) {
        var subscriptionOption = packages.first.storeProduct.subscriptionOptions!.firstWhere((option) =>
        option.freePhase != null);
        hasPurchased = await PurchaseApi.purchaseSubscriptionOption(subscriptionOption).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Couldn't buy the monthly offer package android")));
          AppNavigator.pop(context: context);
        });
      }else if(Platform.isIOS){
        var product = packages[0].storeProduct;
        var discount = product.discounts![0];
        var promotionalObject = await Purchases.getPromotionalOffer(product, discount);
        hasPurchased = await PurchaseApi.purchaseDiscountedPackage(packages[0], promotionalObject).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Couldn't buy the free month trial ios")));
          AppNavigator.pop(context: context);
        });
      }
    }
    if (hasPurchased) {
      trackSubscription();
      SubscriptionProvider.get(context).changeSubscriptionStatus(hasPurchased);
      AppNavigator.pushReplacement(context: context, screen: MainScreen());
    }
  }

  void trackSubscription() {
    try {
      TrackingUtils().trackSubscriptionAction(
          "Guest", DateTime.now().toUtc().toString(), "Free Trial Subscription Screen", "Monthly", "Free");
    } catch (e) {
      print("Failed to track subscription: $e");
    }
  }
}
