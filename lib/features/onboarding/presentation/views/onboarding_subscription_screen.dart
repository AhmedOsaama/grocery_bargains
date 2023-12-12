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
    '20 messages per month (you can add more)'
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
              Text("Seize the opportunity to save big – these deals won't last long".tr(), style: TextStylesInter.textViewLight15, textAlign: TextAlign.center,),
              15.ph,
              FutureBuilder(
                future: offersFuture,
                  builder: (ctx, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
                  var offerings = snapshot.data ?? [];
                  final packages = offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();
                  print(packages);
                  return Column(
                    children: [
                      PlanContainer(
                        selectedPlan: selectedPlan, changePlan: (value){
                        setState(() {
                          selectedPlan = value!;
                          selectedPlanPrice = packages[0].storeProduct.priceString;
                        });
                      },
                        price: packages[0].storeProduct.priceString, plan: "Monthly".tr(),),
                      PlanContainer(selectedPlan: selectedPlan, changePlan: (value){
                        setState(() {
                          selectedPlan = value!;
                          selectedPlanPrice = packages[1].storeProduct.priceString;
                        });
                      },
                        price: packages[1].storeProduct.priceString, plan: "Yearly".tr(), offerText: "You save 63%",),

                    ],
                  );
                  }
              ),
              10.ph,
              GenericButton(
                width: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                  color: brightOrange,
                  height: 60,
                  onPressed: (){
                    finishOnboarding(context, RegisterScreen());
                  }, child: Text("SUBSCRIBE NOW!".tr(), style: TextStylesInter.textViewSemiBold16,)),
              15.ph,
              Text('Subscription renew automatically. You can cancel in the store settings.'.tr(), style: TextStylesInter.textViewLight12, textAlign: TextAlign.center,),
              15.ph,
              GenericButton(
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFEBEBEB),
                  height: 60,
                  onPressed: (){
                    finishOnboarding(context, MainScreen());
                  }, child: Text("Use it for free, No Sidekick, No Sharing".tr(), style: TextStylesInter.textViewSemiBold16.copyWith(color: Color(0xFF7C7C7C),), textAlign: TextAlign.center,))
            ],
          ),
        ),
      ),
    );
  }

  void finishOnboarding(BuildContext context, Widget screen) {
      Provider.of<UserProvider>(context, listen: false).setOnboardingSubscriptionPlan(selectedPlan, selectedPlanPrice);
    if(widget.isChangingPlan) {
      AppNavigator.pushReplacement(context: context, screen: ConfirmSubscriptionScreen());
      return;
    }
      Provider.of<UserProvider>(context, listen: false).turnOffFirstTime();
      Provider.of<TutorialProvider>(context, listen: false).activateWelcomeTutorial();
      AppNavigator.pushReplacement(context: context, screen: screen);
    }
  }

class PlanContainer extends StatelessWidget {
  final String plan;
  final String selectedPlan;
  final Function changePlan;
  final String? offerText;
  final String price;
  PlanContainer({Key? key, required this.selectedPlan, required this.changePlan, this.offerText, required this.price, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  Color accentColor = plan == "Monthly".tr() ? Color(0xFFFF8A1F) : Color(0xFF3463ED);
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
              Radio(value: plan, groupValue: selectedPlan, onChanged: (value) => changePlan(value), activeColor: accentColor,),
              Text(plan, style: TextStylesInter.textViewRegular19,),
              10.pw,
              if(offerText != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: accentColor,
                ),
                child: Text(offerText!, style: TextStylesInter.textViewRegular10.copyWith(color: Colors.white),),
              ),
              Spacer(),
              Text(
                  price,
                  textAlign: TextAlign.center,
                  style: TextStylesInter.textViewSemiBold20.copyWith(fontSize: 18.sp)
              ),
            ],
          ),
        ),
        Container(
          width: 86,
          height: 15,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 4, left: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: accentColor
          ),
          child: Text("LIMITED TIME OFFER".tr(), style: TextStyles.textViewBold7.copyWith(color: Colors.white),),
        ),
      ],
    );
  }
}

