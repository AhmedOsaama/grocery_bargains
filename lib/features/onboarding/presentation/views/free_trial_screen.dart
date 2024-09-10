import 'dart:developer';
import 'dart:io';

import 'package:bargainb/features/onboarding/presentation/views/widgets/sub_info_widget.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/providers/subscription_provider.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/features/home/presentation/views/main_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
import 'widgets/plan_container.dart';

class FreeTrialScreen extends StatefulWidget {
  const FreeTrialScreen({Key? key}) : super(key: key);

  @override
  State<FreeTrialScreen> createState() => _FreeTrialScreenState();
}

class _FreeTrialScreenState extends State<FreeTrialScreen> {
  late Future<List<Offering>> offersFuture;

  var displayedContent = "info";

  var selectedPlan = "None";
  var selectedPlanPrice = "None";

  @override
  void initState() {
    super.initState();
    offersFuture = PurchaseApi.fetchOffers();
    TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "Begin Trial Screen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(premiumBB),
                  10.pw,
                  Text("PREMIUM".tr(), style: TextStylesInter.textViewBold14.copyWith(color: primaryGreen),)
                ],
              ),
              Text.rich(TextSpan(
                text: "Pays".tr(),
                style: TextStylesPaytoneOne.textViewRegular24.copyWith(color: primaryGreen),
                children: [
                   TextSpan(text: " for Itself".tr(), style: TextStyle(color: Color(0xff002401))),
                  TextSpan(text: " with".tr(), style: TextStyle(color: primaryGreen)),
                   TextSpan(text: " Grocery".tr(), style: TextStyle(color: Color(0xff002401))),
                  TextSpan(text: " Savings".tr(), style: TextStyle(color: primaryGreen)),
                ]
              )),
              10.ph,
              if(displayedContent == "plans") ...[
              Text("How your free trial works".tr(), style: TextStylesPaytoneOne.textViewRegular24.copyWith(color: const Color(0xff181818)),),
                if(!SubscriptionProvider.get(context).isSubscribed) ...[
                  FutureBuilder(
                      future: offersFuture,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        var offerings = snapshot.data ?? [];
                        if(offerings.isEmpty){
                          return const SizedBox.shrink();
                        }
                        final packages = offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();
                        var monthlyPrice = packages[0].storeProduct.priceString;
                        var yearlyPrice = packages[1].storeProduct.priceString;
                        var currencyCode = packages.first.storeProduct.currencyCode;
                        var yearlyBeforeDiscountPrice = packages[1].storeProduct.price / 0.33;
                        return Column(
                          children: [
                            PlanContainer(
                              selectedPlan: selectedPlan,
                              changePlan: (value) {
                                setState(() {
                                  selectedPlan = value!;
                                  selectedPlanPrice = monthlyPrice;
                                });
                              },
                              price: monthlyPrice,
                              currencyCode: currencyCode,
                              plan: "Monthly",
                            ),
                            PlanContainer(
                              selectedPlan: selectedPlan,
                              changePlan: (value) {
                                setState(() {
                                  selectedPlan = value!;
                                  selectedPlanPrice = yearlyPrice;
                                });
                              },
                              price: yearlyPrice,
                              beforeDiscountPrice: yearlyBeforeDiscountPrice,
                              currencyCode: currencyCode,
                              plan: "Yearly",
                              offerText: "${"You Save".tr()} 67%",
                            ),
                          ],
                        );
                      }),
                  10.ph,
                ],
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text("You authorize a recurring annual or monthly charge of your plan".tr(), textAlign: TextAlign.center,style: TextStylesInter.textViewRegular12,),
                ),
                10.ph,
                Center(child: Text("Terms of service".tr(), style: TextStylesInter.textViewRegular12.copyWith(decoration: TextDecoration.underline),)),
                5.ph,
                Center(child: Text("Privacy Policy".tr(), style: TextStylesInter.textViewRegular12.copyWith(decoration: TextDecoration.underline),)),
                15.ph,
              ],
              if(displayedContent == "info") ...[
                const SubInfoWidget(
                  imagePath: subInfo1,
                    title: " AI-Powered Grocery Assistant", subTitle: " Personalized shopping recommendations, optimized lists, and meal planning made just for you."),
                30.ph,
                const SubInfoWidget(
                  imagePath: subInfo2,
                    title: "Best Prices, Latest Deals", subTitle: "Always access the freshest deals and the lowest prices from your favorite stores."),
                30.ph,
                const SubInfoWidget(
                  imagePath: subInfo3,
                    title: "Smart Price Comparisons", subTitle: "Compare prices across multiple stores automatically to ensure you're getting the best value."),
                30.ph,
                const SubInfoWidget(
                  imagePath: subInfo4,
                    title: "Collaborative Shopping", subTitle: "Share your shopping lists and savings with family, friends, or housemates."),
                const Spacer(),
              ],
              GenericButton(
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                  color: primaryGreen,
                  height: 60,
                  onPressed: () async {
                    if(displayedContent == "plans") {
                      await initiateSubscription(context, selectedPlan);
                    } else {
                      setState(() {
                        displayedContent = "plans";
                      });
                    }
                  },
                  child: Text(
                    "Try BargainB Premium FREE for 7 Days".tr(),
                    style: TextStylesInter.textViewSemiBold16,
                  )),
              10.ph,
              GenericButton(
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  height: 60,
                  shadow: [
                    BoxShadow(
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                      color: Colors.black.withOpacity(0.05),
                    )
                  ],
                  onPressed: () async {
                    Provider.of<TutorialProvider>(context, listen: false).activateWelcomeTutorial();
                    AppNavigator.pushReplacement(context: context, screen: const MainScreen());
                  },
                  child: Text(
                    "No Thanks".tr(),
                    style: TextStylesInter.textViewSemiBold16.copyWith(color: Colors.black),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> initiateFreeSubscription(BuildContext context) async {
  //   final offerings = await PurchaseApi.fetchOffers();
  //   bool hasPurchased = false;
  //   if (offerings.isEmpty) {
  //     print("No plans found");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Couldn't fetch plans from Google or Apple store. Please try again later")));
  //   } else {
  //     final packages = offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();
  //     if(Platform.isAndroid) {
  //       var subscriptionOption = packages.first.storeProduct.subscriptionOptions!.firstWhere((option) =>
  //       option.freePhase != null);
  //       hasPurchased = await PurchaseApi.purchaseSubscriptionOption(subscriptionOption).catchError((e) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Couldn't buy the monthly offer package android")));
  //         AppNavigator.pop(context: context);
  //       });
  //     }else if(Platform.isIOS){
  //       var product = packages[0].storeProduct;
  //       var introductoryOffer = product.introductoryPrice;
  //       if(introductoryOffer == null){
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Couldn't buy the free month trial. The offer might have been expired")));
  //         return;
  //       }
  //       hasPurchased = await PurchaseApi.purchasePackage(packages[0]).catchError((e) {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Couldn't buy the free month trial ios")));
  //         AppNavigator.pop(context: context);
  //       });
  //     }
  //   }
  //   if (hasPurchased) {
  //     trackSubscription();
  //     SubscriptionProvider.get(context).changeSubscriptionStatus(hasPurchased);
  //     Provider.of<TutorialProvider>(context, listen: false).activateWelcomeTutorial();
  //     AppNavigator.pushReplacement(context: context, screen: MainScreen());
  //   }
  // }

  Future<bool> initiateSubscription(BuildContext context, String selectedPlan) async {
    final offerings = await PurchaseApi.fetchOffers();
    bool hasPurchased = false;
    if (offerings.isEmpty) {
      print("No plans found");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't fetch plans from Google or Apple store. Please try again later")));
    } else {
      final packages = offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();
      if (selectedPlan == "Monthly") {
        if(Platform.isAndroid) {
          var subscriptionOption = packages.first.storeProduct.subscriptionOptions!.firstWhere((option) =>
          option.freePhase != null);
          hasPurchased = await PurchaseApi.purchaseSubscriptionOption(subscriptionOption).catchError((e) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Couldn't buy the monthly offer package android")));
          });
        }else {
          hasPurchased = await PurchaseApi.purchasePackage(packages[0]).catchError((e) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Couldn't buy the monthly package")));
          });
        }
      }
      if (selectedPlan == "Yearly") {
        hasPurchased = await PurchaseApi.purchasePackage(packages[1]).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Couldn't buy the monthly package")));
        });
      }
    }
    if(hasPurchased) {
      trackSubscription();
      SubscriptionProvider.get(context).changeSubscriptionStatus(hasPurchased);
      Provider.of<TutorialProvider>(context, listen: false).activateWelcomeTutorial();
      AppNavigator.pushReplacement(context: context, screen: const MainScreen());
    }
    return hasPurchased;
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
