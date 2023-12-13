import 'dart:developer';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/onboarding/presentation/views/onboarding_subscription_screen.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/screens/support_screen.dart';
import 'package:bargainb/view/widgets/feature_widget.dart';
import 'package:bargainb/view/widgets/subscription_paywall.dart';
import 'package:bargainb/view/widgets/subscription_plan_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../providers/user_provider.dart';
import '../../../../services/purchase_service.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/icons_manager.dart';
import '../../../../utils/style_utils.dart';
import '../../../../view/widgets/backbutton.dart';
import 'customize_experience_screen.dart';
import 'widgets/onboarding_stepper.dart';

enum Language { english, dutch }

class ConfirmSubscriptionScreen extends StatefulWidget {
  ConfirmSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmSubscriptionScreen> createState() => _ConfirmSubscriptionScreenState();
}

class _ConfirmSubscriptionScreenState extends State<ConfirmSubscriptionScreen> {
  var scrollController = ScrollController();
  var _pageController = PageController();
  var pageNumber = 0;
  var selectedLanguage = Language.english;
  var subscriptionPlan = "None";
  var subscriptionPrice = "None";
  var subscriptionPricePerMonth = "None";

  // List<Map<String, String>> premiumFeatures = [
  //   {
  //     "heading": "AI grocery sidekick",
  //     "body": "Your AI Grocery buddy finds the best deals and discounts across a wide range of grocery stores",
  //   },
  //   {
  //     "heading": "Personalized Recommendations",
  //     "body": "Receive tailored recommendations to save more on specific products and categories.",
  //   },
  //   {
  //     "heading": "Unlimited shopping lists",
  //     "body": "Create, edit, and share shopping lists with ease, ensuring you never miss a grocery item again.",
  //   },
  //   {
  //     "heading": "Share with family & friends",
  //     "body": "Spread the smart grocery love by sharing BargainB with your loved ones",
  //   },
  //   {
  //     "heading": "Exclusive access to the best deals",
  //     "body": "Uncover hidden discounts, and offers that are not available to free users.",
  //   },
  // ];
  List<String> premiumFeatures = [
    premium1,
    premium2,
    premium3,
    premium4,
    premium5,
  ];

  late Future<List> offersFuture;

  @override
  void initState() {
    offersFuture = PurchaseApi.fetchOffers();
    trackPage();
    super.initState();
  }

  void trackPage() {
     TrackingUtils().trackPageView(
        FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Confirm Subscription Screen");
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: PurchaseApi.isSubscribed ? MyAppBar(title: '') : null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (!PurchaseApi.isSubscribed) OnboardingStepper(activeStep: 0, stepSize: 13),
                Text(
                  'Review and Confirm Your Subscription'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStylesInter.textViewBold26,
                ),
                23.ph,
                Text(
                  'With Premium, get the ultimate grocery sidekick tailored to your needs and preferences'.tr(),
                  style: TextStylesInter.textViewLight15,
                  textAlign: TextAlign.center,
                ),
                10.ph,
                Container(
                  height: 200.h,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: premiumFeatures
                        .map((feature) => Image.asset(feature,))
                        .toList(),
                  ),
                ),
                15.ph,
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(checkmark_icon),
                        15.pw,
                        Text(
                          "No ads".tr(),
                          style: TextStylesInter.textViewSemiBold14,
                        )
                      ],
                    ),
                  ),
                ),
                if (!PurchaseApi.isSubscribed)
                  // FutureBuilder<List<Offering>>(
                  FutureBuilder(
                    future: offersFuture,
                    builder: (ctx, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
                      var offerings = snapshot.data ?? [];
                      final packages = offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();
                      log(packages[1].toString());
                      var plan = userProvider.onboardingSubscriptionPlan;
                      var monthlyPrice = packages[0].storeProduct.priceString;
                      var yearlyPrice = packages[1].storeProduct.priceString;
                      var offer = packages[1].storeProduct.subscriptionOptions;
                      log(offer.toString());
                      if(plan == "Yearly") {
                        userProvider.onboardingSubscriptionPlanPrice = yearlyPrice;
                        return PlanContainer(
                          selectedPlan: plan,
                          changePlan: (value) {
                            trackSubscriptionChoice("Choose Yearly");
                          },
                          price: yearlyPrice,
                          plan: plan,
                          offerText: "You save 63%",
                        );
                      }else{
                        userProvider.onboardingSubscriptionPlanPrice = monthlyPrice;
                        return PlanContainer(
                          selectedPlan: plan,
                          changePlan: (value) {
                            trackSubscriptionChoice("Choose Monthly");
                          },
                          price: monthlyPrice,
                          plan: plan,
                        );
                      }
                      
                    }
                ),


                      // : PlanContainer(
                      //     selectedPlan: userProvider.onboardingSubscriptionPlan,
                      //     changePlan: (value) {
                      //       trackSubscriptionChoice("Choose Monthly");
                      //     },
                      //     price: userProvider.onboardingSubscriptionPlanPrice,
                      //     plan: userProvider.onboardingSubscriptionPlan),
                if (PurchaseApi.isSubscribed)
                  Column(
                    children: [
                      Text(
                        LocaleKeys.thankYou.tr(),
                        style: TextStylesInter.textViewSemiBold18.copyWith(color: blackSecondary),
                      ),
                      10.ph,
                      Text(
                        LocaleKeys.youAreUpgraded.tr(),
                        style: TextStylesInter.textViewLight15.copyWith(color: Color(0xFF48484A)),
                      ),
                      10.ph,
                      PlanContainer(
                        selectedPlan: subscriptionPlan,
                        changePlan: (value) {},
                        price: subscriptionPrice,
                        plan: subscriptionPlan,
                      ),
                    ],
                  ),
                14.ph,
                if (!PurchaseApi.isSubscribed) ...[
                  GenericButton(
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(10),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: brightOrange,
                    onPressed: () async {
                     var hasPurchased = await initiateSubscription(context, userProvider.onboardingSubscriptionPlan);
                     if(hasPurchased) AppNavigator.pushReplacement(context: context, screen: CustomizeExperienceScreen());
                    },
                    child: Text(
                      userProvider.onboardingSubscriptionPlan == "Yearly"
                          ? 'Pay ${userProvider.onboardingSubscriptionPlanPrice}, get an Assistant for 1 year'
                              .tr()
                          : 'Pay ${userProvider.onboardingSubscriptionPlanPrice} Monthly, get an Assistant'.tr(),
                      style: TextStylesInter.textViewSemiBold13.copyWith(color: white),
                    ),
                  ),
                  10.ph,
                  GenericButton(
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(10),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    color: Color(0xFFEBEBEB),
                    onPressed: () async {
                      AppNavigator.push(
                          context: context,
                          screen: OnboardingSubscriptionScreen(
                            isChangingPlan: true,
                          ));
                    },
                    child: Text(
                      "Change Plan".tr(),
                      style: TextStylesInter.textViewSemiBold16.copyWith(color: Color(0xFF3463ED)),
                    ),
                  ),
                ],
                10.ph,
                Text(
                  'Subscription renew automatically. You can cancel in the store settings.'.tr(),
                  style: TextStylesInter.textViewRegular12.copyWith(color: Color(0xFF48484A)),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void trackSubscriptionChoice(String choice) {
    TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, choice, DateTime.now().toUtc().toString(), "Confirm Subscription Screen");
  }

  Future<bool> initiateSubscription(BuildContext context, String selectedPlan) async {
    final offerings = await PurchaseApi.fetchOffers();
    bool hasPurchased = false;
    if (offerings.isEmpty) {
      print("No plans found");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Couldn't fetch plans from Google or Apple store. Please try again later")));
    } else {
      final packages = offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();
      if (selectedPlan == "Monthly") {
        hasPurchased = await PurchaseApi.purchasePackage(packages[0]).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Couldn't buy the monthly package")));
          AppNavigator.pop(context: context);
        });
      }
      if (selectedPlan == "Yearly") {
        hasPurchased = await PurchaseApi.purchasePackage(packages[1]).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Couldn't buy the monthly package")));
          AppNavigator.pop(context: context);
        });
      }
    }
    if(hasPurchased) {
      TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Confirm and buy Subscription",DateTime.now().toUtc().toString(), "Confirm Subscription Screen");
      setState(() {
        subscriptionPlan = PurchaseApi.subscriptionPeriod;
        subscriptionPrice = PurchaseApi.subscriptionPrice;
      });
    }
    return hasPurchased;
    // final offerings = await PurchaseApi.fetchOffers();
    // if (offerings.isEmpty) {
    //   print("No plans found");
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text("Couldn't fetch plans from Google or Apple store. Please try again later")));
    // } else {
    //   final packages = offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();
    //   // var value = await showModalBottomSheet(
    //   //     clipBehavior: Clip.antiAlias,
    //   //     isScrollControlled: true,
    //   //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    //   //     context: context,
    //   //     builder: (ctx) => SubscriptionPaywall(
    //   //           packages: packages,
    //   //         ));
    //   if (value != null) {
    //     setState(() {
    //       subscriptionPlan = PurchaseApi.subscriptionPeriod;
    //       subscriptionPrice = PurchaseApi.subscriptionPrice;
    //     });
    //   }
    // }
  }
}
