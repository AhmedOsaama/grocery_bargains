import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/services/purchase_service.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/view/widgets/subscription_plan_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';

class SubscriptionPaywall extends StatefulWidget {
  final List<Package> packages;
  const SubscriptionPaywall({Key? key, required this.packages}) : super(key: key);

  @override
  State<SubscriptionPaywall> createState() => _SubscriptionPaywallState();
}

class _SubscriptionPaywallState extends State<SubscriptionPaywall> {
  var selectedPlan = "None";          //can change at runtime
  var subscriptionPlan = "None";      //comes from revenuCat

  @override
  void initState() {
    subscriptionPlan = PurchaseApi.subscriptionPeriod;
    if(subscriptionPlan != "None")
    selectedPlan = subscriptionPlan;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          16.ph,
          Container(
              width: 32,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
              child: Divider(
                thickness: 4,
              )),
          16.ph,
          Text(
            LocaleKeys.chooseAPlan.tr(),
            style: TextStylesInter.textViewSemiBold18.copyWith(color: blackSecondary),
          ),
          15.ph,
          Column(
            children: [
              SubscriptionPlanWidget(
                promotion: subscriptionPlan == 'Monthly' ? LocaleKeys.currentPlan.tr() : LocaleKeys.mostFlexible.tr(),
                type: LocaleKeys.monthly.tr(),
                price: widget.packages[0].storeProduct.priceString,
                pricePerMonth: "${(widget.packages[0].storeProduct.price)} / Month",
                selectedPlan: selectedPlan,
                onSubscriptionChanged: (value) {
                  setState(() {
                    selectedPlan = value;
                  });
                },
              ),
              SubscriptionPlanWidget(
                promotion: subscriptionPlan == 'Yearly' ?  LocaleKeys.currentPlan.tr() : LocaleKeys.mostFlexible.tr(),
                type: LocaleKeys.yearly.tr(),
                price: widget.packages[1].storeProduct.priceString,
                pricePerMonth: "${(widget.packages[1].storeProduct.price / 12).toStringAsFixed(2)} / Month",
                selectedPlan: selectedPlan,
                onSubscriptionChanged: (value) {
                  setState(() {
                    selectedPlan = value;
                  });
                },
              ),
              SubscriptionPlanWidget(
                promotion: subscriptionPlan == 'Lifetime' ?  LocaleKeys.currentPlan.tr() : LocaleKeys.onePayment.tr(),
                type: LocaleKeys.lifetime.tr(),
                price: widget.packages[2].storeProduct.priceString,
                pricePerMonth: "One time payment",
                selectedPlan: selectedPlan,
                onSubscriptionChanged: (value) {
                  setState(() {
                    selectedPlan = value;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GenericButton(
                width: double.infinity,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.symmetric(vertical: 20),
                color: brightOrange,
                onPressed: selectedPlan == "None" ? null : () async {
                  if(selectedPlan == "Monthly") await PurchaseApi.purchasePackage(widget.packages[0]).catchError((e) {
                    print("Error in buying the monthly package");
                    AppNavigator.pop(context: context);
                  });
                  if(selectedPlan == "Yearly") await PurchaseApi.purchasePackage(widget.packages[1]).catchError((e){
                    print("Error in buying the yearly package");
                    AppNavigator.pop(context: context);
                  });
                  if(selectedPlan == "Lifetime") await PurchaseApi.purchasePackage(widget.packages[2]).catchError((e){
                    print("Error in buying the lifetime package");
                    AppNavigator.pop(context: context);
                  });
                  AppNavigator.pop(context: context, object: selectedPlan);
                },
                child: Text(
                 subscriptionPlan != "None" ? LocaleKeys.changePlan.tr() : LocaleKeys.subscribe.tr(),
                  style: TextStylesInter.textViewSemiBold16.copyWith(color: white),
                )),
          ),
          10.ph,
          Text(
            LocaleKeys.subscriptionRenew.tr(),
            style: TextStylesInter.textViewRegular12.copyWith(color: Color(0xFF48484A)),
          )
        ],
      ),
    );
  }
}
