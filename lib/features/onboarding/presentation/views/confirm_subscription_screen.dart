import 'dart:developer';
import 'dart:io';

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

  List<String> premiumFeatures = [
    premium1,
    premium2,
    premium3,
    premium4,
    premium5,
  ];

  late Future<List<Offering>> offersFuture;

  @override
  void initState() {
    offersFuture = PurchaseApi.fetchOffers();
    trackPage();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(context.locale.languageCode == "nl"){
      premiumFeatures = [premium1Dutch, premium2Dutch, premium3Dutch, premium4Dutch, premium5Dutch];
    }
    super.didChangeDependencies();
  }

  void trackPage() {
    TrackingUtils().trackPageView(
        FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Confirm Subscription Screen");
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                OnboardingStepper(activeStep: 0, stepSize: 13),
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
                  height: 230.h,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: premiumFeatures
                        .map((feature) => Image.asset(
                              feature,
                            ))
                        .toList(),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
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
                // FutureBuilder<List<Offering>>(
                FutureBuilder<List<Offering>>(
                    future: offersFuture,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var offerings = snapshot.data ?? [];
                      final packages =
                          offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();
                      log(packages[1].toString());
                      var plan = userProvider.onboardingSubscriptionPlan;
                      var monthlyPrice = packages[0].storeProduct.priceString;
                      var yearlyPrice = packages[1].storeProduct.priceString;
                      double yearlyOriginalPrice = packages[1].storeProduct.price;
                      int yearlyDiscountPercentage = 0;
                      try {
                        if (Platform.isIOS) {
                          var introductoryPrice = packages[1].storeProduct.introductoryPrice;
                          if (introductoryPrice != null) yearlyPrice = introductoryPrice.priceString;
                        }
                        if (Platform.isAndroid) {
                          var subscriptionOptions = packages[1].storeProduct.subscriptionOptions;
                          if (subscriptionOptions!.first.introPhase != null) {
                            yearlyPrice = subscriptionOptions.first.introPhase!.price.formatted;
                            var currencyCode = subscriptionOptions.first.introPhase!.price.currencyCode;
                            double yearlyPriceDiscounted = double.parse(yearlyPrice.replaceAll(currencyCode, ""));
                            yearlyDiscountPercentage = 100 - ((yearlyPriceDiscounted / yearlyOriginalPrice) * 100).round();
                          }
                        }
                      } catch (e) {
                        print("Something went wrong while fetching offers: $e");
                      }
                      if (plan == 'Yearly') {
                        userProvider.onboardingSubscriptionPlanPrice = yearlyPrice;
                      } else if (plan == "Monthly") {
                        userProvider.onboardingSubscriptionPlanPrice = monthlyPrice;
                      }
                      return Column(
                        children: [
                          if (plan == "Yearly")
                            PlanContainer(
                              selectedPlan: plan,
                              changePlan: (value) {
                                trackSubscriptionChoice("Choose Yearly");
                              },
                              price: yearlyPrice,
                              plan: plan,
                              offerText: yearlyDiscountPercentage == 0 ? null : "You save $yearlyDiscountPercentage%",
                            ),
                          if (plan == "Monthly")
                            PlanContainer(
                              selectedPlan: plan,
                              changePlan: (value) {
                                trackSubscriptionChoice("Choose Monthly");
                              },
                              price: monthlyPrice,
                              plan: plan,
                            ),
                          15.ph,
                          GenericButton(
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(10),
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            color: brightOrange,
                            onPressed: () async {
                              var hasPurchased =
                                  await initiateSubscription(context, userProvider.onboardingSubscriptionPlan);
                              if (hasPurchased) {
                                trackSubscription(userProvider);
                                AppNavigator.pushReplacement(context: context, screen: CustomizeExperienceScreen());
                              }
                            },
                            child: Text(
                              userProvider.onboardingSubscriptionPlan == "Yearly"
                                  ? '${"Pay".tr()} ${userProvider.onboardingSubscriptionPlanPrice.tr()}, ${"get an Assistant for 1 year".tr()}'
                                  : '${"Pay".tr()} ${userProvider.onboardingSubscriptionPlanPrice.tr()} ${"Monthly".tr()}, ${"get an Assistant".tr()} ',
                              style: TextStylesInter.textViewSemiBold13.copyWith(color: white),
                              textAlign: TextAlign.center,
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
                      );
                    }),
                14.ph,
                10.ph,
                Text(
                  """Subscription renew automatically. 
Cancel Anytime: You have the freedom to cancel your subscription at any time before the next billing cycle to avoid future charges.
How to Cancel: To cancel, simply go to your Google Play account settings, navigate to 'Subscriptions,' select BargainB, and tap 'Cancel Subscription.'""".tr(),
                  style: TextStylesInter.textViewLight12,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void trackSubscription(UserProvider userProvider) {
    try {
      TrackingUtils().trackSubscriptionAction(
          FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Confirm Subscription Screen",
          userProvider.onboardingSubscriptionPlan, userProvider.onboardingSubscriptionPlanPrice);
    }catch(e){
      print("Failed to track subscription: $e");
    }
  }

  void trackSubscriptionChoice(String choice) {
    TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, choice, DateTime.now().toUtc().toString(),
        "Confirm Subscription Screen");
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Couldn't buy the monthly package")));
          AppNavigator.pop(context: context);
        });
      }
      if (selectedPlan == "Yearly") {
        hasPurchased = await PurchaseApi.purchasePackage(packages[1]).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Couldn't buy the monthly package")));
          AppNavigator.pop(context: context);
        });
      }
    }
    if (hasPurchased) {
      TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Confirm and buy Subscription",
          DateTime.now().toUtc().toString(), "Confirm Subscription Screen");
    }
    return hasPurchased;
  }
}
