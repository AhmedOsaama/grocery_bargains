import 'dart:developer';
import 'dart:io';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/onboarding/presentation/views/confirm_subscription_screen.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/onboarding_stepper.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/services/purchase_service.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/screens/register_screen.dart';
import 'package:bargainb/view/screens/support_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../providers/tutorial_provider.dart';
import '../../../../providers/user_provider.dart';

class OnboardingSubscriptionScreen extends StatefulWidget {
  final bool isChangingPlan;
  OnboardingSubscriptionScreen({Key? key, required this.isChangingPlan}) : super(key: key);

  @override
  State<OnboardingSubscriptionScreen> createState() => _OnboardingSubscriptionScreenState();
}

class _OnboardingSubscriptionScreenState extends State<OnboardingSubscriptionScreen> {
  final List<String> premiumFeatures = [
    "AI grocery sidekick",
    'Unlimited shopping list management',
    'Personalised product recommendations',
    'Share with family & friends',
    'Exclusive access to the best deals',
    'Track your savings',
    '30 messages per month (you can add more)'
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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
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
                Container(
                  height: 250.h,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: premiumFeatures
                          .map((featureText) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 7),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(checkmark_icon),
                                    15.pw,
                                    Text(
                                      featureText.tr(),
                                      style: TextStylesInter.textViewSemiBold14,
                                    )
                                  ],
                                ),
                              ))
                          .toList()),
                ),
                Text(
                  "Seize the opportunity to save big – these deals won't last long".tr(),
                  style: TextStylesInter.textViewLight15,
                  textAlign: TextAlign.center,
                ),
                15.ph,
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
                            offerText: "You save 63%",
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
                    onPressed: () {
                      if(selectedPlan != "None")
                      finishOnboarding(context);
                    },
                    child: Text(
                      "SUBSCRIBE NOW!".tr(),
                      style: TextStylesInter.textViewSemiBold16,
                    )),
                15.ph,
                Text(
                  'Subscription renew automatically. You can cancel in the store settings.'.tr(),
                  style: TextStylesInter.textViewLight12,
                  textAlign: TextAlign.center,
                ),
                15.ph,
                GenericButton(
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFEBEBEB),
                    height: 60,
                    onPressed: () {
                      finishOnboarding(context, isSkipping: true);
                    },
                    child: Text(
                      "Use it for free, No Assistant, No Sharing".tr(),
                      style: TextStylesInter.textViewSemiBold16.copyWith(
                        color: Color(0xFF7C7C7C),
                      ),
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> finishOnboarding(BuildContext context,{bool isSkipping = false}) async {
      Provider.of<UserProvider>(context, listen: false).turnOffFirstTime();
      Provider.of<TutorialProvider>(context, listen: false).activateWelcomeTutorial();
    if(isSkipping){
      AppNavigator.pushReplacement(context: context, screen: MainScreen());
    }else if (widget.isChangingPlan) {
    await Provider.of<UserProvider>(context, listen: false).setOnboardingSubscriptionPlan(selectedPlan, selectedPlanPrice);
      AppNavigator.pushReplacement(context: context, screen: ConfirmSubscriptionScreen());
    }else{
      Provider.of<UserProvider>(context, listen: false).setOnboardingSubscriptionPlan(selectedPlan, selectedPlanPrice);
      AppNavigator.pushReplacement(context: context, screen: RegisterScreen());       //case: choosing plan before creating account
    }

  }
}

class PlanContainer extends StatefulWidget {
  final String plan;
  final String selectedPlan;
  final Function changePlan;
  final String? offerText;
  final String price;
  PlanContainer(
      {Key? key,
      required this.selectedPlan,
      required this.changePlan,
      this.offerText,
      required this.price,
      required this.plan})
      : super(key: key);

  @override
  State<PlanContainer> createState() => _PlanContainerState();
}

class _PlanContainerState extends State<PlanContainer> {
  @override
  Widget build(BuildContext context) {
    Color accentColor = widget.plan == "Monthly" ? Color(0xFFFF8A1F) : Color(0xFF3463ED);
    return Stack(
      // alignment: Alignment.topCenter,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: accentColor, width: 2),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Radio(
                value: widget.plan,
                groupValue: widget.selectedPlan,
                onChanged: (value) => widget.changePlan(value),
                activeColor: accentColor,
              ),
              Text(
                widget.plan.tr(),
                style: TextStylesInter.textViewRegular19,
              ),
              10.pw,
              if (widget.offerText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: accentColor,
                  ),
                  child: Text(
                    widget.offerText!,
                    style: TextStylesInter.textViewRegular10.copyWith(color: Colors.white),
                  ),
                ),
              Spacer(),
              Text(widget.price,
                  textAlign: TextAlign.center, style: TextStylesInter.textViewSemiBold20.copyWith(fontSize: 18.sp)),
            ],
          ),
        ),
        Container(
          width: 86,
          height: 15,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 4, left: 30),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: accentColor),
          child: Text(
            "LIMITED TIME OFFER".tr(),
            style: TextStyles.textViewBold7.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
