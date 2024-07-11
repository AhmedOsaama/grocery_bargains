import 'dart:io';
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/services/purchase_service.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../providers/subscription_provider.dart';
import '../../../../utils/tracking_utils.dart';
import 'support_screen.dart';
import '../../../onboarding/presentation/views/widgets/plan_container.dart';

class SubscriptionScreen extends StatefulWidget {
  SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final List<String> premiumFeatures = [
    "AI grocery sidekick",
    'Unlimited shopping list management',
    'Personalised product recommendations',
    'Share with family & friends',
    'Exclusive access to the best deals',
    'Track your savings',
  ];

  List<String> subscriptionPlans = ['Yearly', 'Monthly'];

  var selectedPlan = "None";
  var selectedPlanPrice = "None";
  late Future<List> offersFuture;

  @override
  void initState() {
    offersFuture = PurchaseApi.fetchOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: ''),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Upgrade to BargainB Premium'.tr(),
                style: TextStylesInter.textViewBold26,
                textAlign: TextAlign.center,
              ),
              20.ph,
              Text(
                'With Premium, get the ultimate grocery sidekick tailored to your needs and preferences'.tr(),
                style: TextStylesInter.textViewLight15,
                textAlign: TextAlign.center,
              ),
              15.ph,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    children: premiumFeatures
                        .map((featureText) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        children: [
                          SvgPicture.asset(checkmark_icon),
                          15.pw,
                          Container(
                            width: ScreenUtil().screenWidth * 0.6,
                            child: Text(
                              featureText.tr(),
                              style: TextStylesInter.textViewSemiBold14,
                            ),
                          )
                        ],
                      ),
                    ))
                        .toList()),
              ),
              15.ph,
              if (SubscriptionProvider.get(context).isSubscribed)
                Column(
                  children: [
                    Text(
                      "Thank you".tr(),
                      style: TextStylesInter.textViewSemiBold18.copyWith(color: blackSecondary),
                    ),
                    10.ph,
                    Text(
                      "You are upgraded to premium".tr(),
                      style: TextStylesInter.textViewLight15.copyWith(color: Color(0xFF48484A)),
                    ),
                    10.ph,
                    PlanContainer(
                      selectedPlan: PurchaseApi.subscriptionPeriod,
                      changePlan: (value) {},
                      price: PurchaseApi.subscriptionPrice,
                      plan: PurchaseApi.subscriptionPeriod,
                    ),
                  ],
                ),
              if(!SubscriptionProvider.get(context).isSubscribed) ...[
                FutureBuilder(
                    future: offersFuture,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      var offerings = snapshot.data ?? [];
                      final packages = offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();
                      var monthlyPrice = packages[0].storeProduct.priceString;
                      var yearlyPrice = packages[1].storeProduct.priceString;
                      try {
                        if (Platform.isIOS) {
                          var introductoryPrice = packages[1].storeProduct.introductoryPrice;
                          if (introductoryPrice != null) yearlyPrice = introductoryPrice.priceString;
                        }
                        if (Platform.isAndroid) {
                          var subscriptionOptions = packages[1].storeProduct.subscriptionOptions;
                          if (subscriptionOptions!.first.introPhase != null)
                            yearlyPrice = subscriptionOptions.first.introPhase!.price.formatted;
                        }
                      } catch (e) {
                        print("Something went wrong while fetching offers: $e");
                      }
                      // log(offer.toString());
                      return Column(
                        children: [
                          PlanContainer(
                            selectedPlan: selectedPlan,
                            changePlan: (value) {
                              setState(() {
                                selectedPlan = value!;
                                selectedPlanPrice = yearlyPrice;
                              });
                            },
                            price: yearlyPrice,
                            plan: "Yearly",
                            offerText: "You Save".tr() + " 63%",
                          ),
                          PlanContainer(
                            selectedPlan: selectedPlan,
                            changePlan: (value) {
                              setState(() {
                                selectedPlan = value!;
                                selectedPlanPrice = monthlyPrice;
                              });
                            },
                            price: monthlyPrice,
                            plan: "Monthly",
                          ),
                        ],
                      );
                    }),
                10.ph,
                GenericButton(
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(10),
                    color: brightOrange,
                    height: 60,
                    onPressed: () async {
                      await initiateSubscription(context, selectedPlan);
                    },
                    child: Text(
                      "SUBSCRIBE NOW!".tr(),
                      style: TextStylesInter.textViewSemiBold16,
                    )),
              ],
              15.ph,
              Text(
                """Subscription renew automatically. 
Cancel Anytime: You have the freedom to cancel your subscription at any time before the next billing cycle to avoid future charges.
How to Cancel: To cancel, simply go to your Google Play account settings, navigate to 'Subscriptions,' select BargainB, and tap 'Cancel Subscription.'""".tr(),
                style: TextStylesInter.textViewLight12,
                textAlign: TextAlign.center,
              ),
              15.ph,
            ],
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
      SubscriptionProvider.get(context).changeSubscriptionStatus(hasPurchased);
      trackSubscription();
      setState(() {
        this.selectedPlan = PurchaseApi.subscriptionPeriod;
        selectedPlanPrice = PurchaseApi.subscriptionPrice;
      });
      AppNavigator.pop(context: context);
    }
    return hasPurchased;
  }

  void trackSubscription() {
    try {
      TrackingUtils().trackSubscriptionAction(
          FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Profile Subscription Screen",
          this.selectedPlan, selectedPlanPrice);
    }catch(e){
      print("Failed to track subscription: $e");
    }
  }
}

