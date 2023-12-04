import 'dart:io';

import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/widgets/feature_widget.dart';
import 'package:bargainb/view/widgets/subscription_paywall.dart';
import 'package:bargainb/view/widgets/subscription_plan_widget.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../generated/locale_keys.g.dart';
import '../../services/purchase_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../widgets/plan_widget.dart';

enum Language { english, dutch }

class SubscriptionScreen extends StatefulWidget {
  SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  var scrollController = ScrollController();
  var selectedLanguage = Language.english;
  var subscriptionPlan = "None";
  var subscriptionPrice = "None";
  var subscriptionPricePerMonth = "None";

  @override
  void initState() {
    subscriptionPlan = PurchaseApi.subscriptionPeriod;
    subscriptionPrice = PurchaseApi.subscriptionPrice;
    subscriptionPricePerMonth = PurchaseApi.subscriptionPricePerMonth;
    TrackingUtils().trackPageView(
        FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Subscription screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // leading: backButt,
        title: Text(
          LocaleKeys.goPremium.tr(),
          style: TextStylesInter.textViewSemiBold18.copyWith(color: blackSecondary),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                LocaleKeys.ourAppIsCompletelyFree.tr(),
                textAlign: TextAlign.center,
                style: TextStylesInter.textViewRegular14.copyWith(color: Color(0xFF48484A)),
              ),
              23.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  LocaleKeys.unlockPremiumFeatures.tr(),
                  style: TextStylesInter.textViewSemiBold18.copyWith(color: Color(0xFF181A26)),
                ),
              ),
              10.ph,
              Container(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  children: [
                    FeatureContainer(
                      heading: LocaleKeys.spendingInsights.tr(),
                      body: LocaleKeys.gainDeepInsights.tr(),
                    ),
                    FeatureContainer(
                      heading: LocaleKeys.personalizedRecommendations.tr(),
                      body: LocaleKeys.receiveTailored.tr(),
                    ),
                  ],
                ),
              ),
              // DotsIndicator(
              //   dotsCount: 4,
              //   position: 0.0,
              // ),
              15.ph,
              subscriptionPlan == 'None'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PlanWidget(
                          promotion: LocaleKeys.mostFlexible.tr(),
                          type: LocaleKeys.monthly.tr(),
                          price: "1.09",
                          pricePerMonth: "1.09 / month*",
                        ),
                        PlanWidget(
                          promotion: LocaleKeys.mostFlexible.tr(),
                          type: LocaleKeys.yearly.tr(),
                          price: "9.49",
                          pricePerMonth: "0.79 / month*",
                        ),
                        PlanWidget(
                          promotion: LocaleKeys.onePayment.tr(),
                          type: LocaleKeys.lifetime.tr(),
                          price: "15.99",
                          pricePerMonth: "Pay only once",
                        ),
                      ],
                    )
                  : Column(
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
                        SubscriptionPlanWidget(
                            promotion: LocaleKeys.currentPlan.tr(),
                            type: subscriptionPlan,
                            price: subscriptionPrice,
                            pricePerMonth: subscriptionPricePerMonth,
                            selectedPlan: subscriptionPlan,
                            onSubscriptionChanged: () {}),
                      ],
                    ),
              14.ph,
              GenericButton(
                width: double.infinity,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.symmetric(vertical: 20),
                color: brightOrange,
                onPressed: () async {
                  final offerings = await PurchaseApi.fetchOffers();
                  if (offerings.isEmpty) {
                    print("No plans found");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Couldn't fetch plans from Google or Apple store. Please try again later")));
                  } else {
                    final packages = offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();
                    var value = await showModalBottomSheet(
                        clipBehavior: Clip.antiAlias,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        context: context,
                        builder: (ctx) => SubscriptionPaywall(
                              packages: packages,
                            ));
                    if (value != null) {
                      setState(() {
                        subscriptionPlan = PurchaseApi.subscriptionPeriod;
                        subscriptionPrice = PurchaseApi.subscriptionPrice;
                        subscriptionPricePerMonth = PurchaseApi.subscriptionPricePerMonth;
                      });
                    }
                  }
                },
                child: Text(
                  LocaleKeys.upgradeNow.tr(),
                  style: TextStylesInter.textViewSemiBold16.copyWith(color: white),
                ),
              ),
              10.ph,
              Text(
                LocaleKeys.subscriptionRenew.tr(),
                style: TextStylesInter.textViewRegular12.copyWith(color: Color(0xFF48484A)),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> fetchOffers() async {
  //
  //
  //     showModalBottomSheet(
  //         context: context,
  //         builder: (context) => Column(
  //               children: packages
  //                   .map((package) => InkWell(
  //                         onTap: () {
  //                           print("Purchasing");
  //                           PurchaseApi.purchasePackage(package);
  //                         },
  //                         child: Container(
  //                           margin: EdgeInsets.all(5),
  //                           decoration: BoxDecoration(border: Border.all(color: Colors.black)),
  //                           child: Column(
  //                             children: [
  //                               Text(package.storeProduct.title),
  //                               Text(package.storeProduct.description),
  //                               Text(package.storeProduct.priceString),
  //                             ],
  //                           ),
  //                         ),
  //                       ))
  //                   .toList(),
  //             ));
  //   }
}
