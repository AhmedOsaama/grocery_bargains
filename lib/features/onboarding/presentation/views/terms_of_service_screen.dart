import 'dart:developer';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/onboarding/presentation/manager/terms_screen_text.dart';
import 'package:bargainb/features/onboarding/presentation/views/policy_screen.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/style_utils.dart';
import '../../../../utils/tracking_utils.dart';
import '../../../../view/screens/support_screen.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  final TextStyle headerFont = TextStylesInter.textViewBold28;

  final TextStyle subHeaderFont = TextStylesInter.textViewBold20;

  final TextStyle bodyFont = TextStylesInter.textViewRegular16;

  bool showFAB = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    addScrollListener();
    super.initState();
  }

  void addScrollListener() {
    return scrollController.addListener(() {
      double showOffset = 200.0;
      if (scrollController.offset > showOffset) {
        if (!showFAB)
          setState(() {
            showFAB = true;
          });
      } else {
        if (showFAB)
          setState(() {
            showFAB = false;
          });
      }
    });
  }

  Opacity buildFAB() {
    return Opacity(
        opacity: showFAB ? 0.6 : 0.0, //set obacity to 1 on visible, or hide
        child: GestureDetector(
          onTap: () {
            scrollController.animateTo(
                //go to top of scroll
                0, //scroll offset to go
                duration: Duration(milliseconds: 500), //duration of scroll
                curve: Curves.fastOutSlowIn //scroll type
                );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(255, 154, 65, 1), width: 3), shape: BoxShape.circle),
            child: Icon(
              Icons.arrow_upward,
              color: brightOrange,
            ),
          ),
        ));
  }

  Future<void> launchLink(String link) async {
    final url = Uri.parse(link);
    try {
      await launchUrl(url);
    } catch (e) {
      log(e.toString());
    }
    try {
      TrackingUtils().trackTextLinkClicked(
          "Guest", DateTime.now().toUtc().toString(), "Terms of service screen", "Open terms link");
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: MyAppBar(
        title: "Terms Of Service".tr(),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Effective date: 03/01/2023",
                style: TextStylesInter.textViewRegular20.copyWith(color: Color(0xFF7C7C7C)),
              ),
              50.ph,
              Text(
                TermsOfServiceText.introductionHeader,
                style: headerFont,
              ),
              36.ph,
              Text(
                TermsOfServiceText.introductionBody1,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.introductionBody2,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.introductionBody3,
                style: bodyFont,
              ),
              TextButton(onPressed: () => launchLink('https://thebargainb.com/privacy-policy/'), child: Text(TermsOfServiceText.introductionBody3Link)),
              20.ph,
              Text(
                TermsOfServiceText.introductionBody4,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.introductionBody5,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.communicationsHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.communicationsBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.purchasesHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.purchasesBody1,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.purchasesBody2,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.purchasesBody3,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.purchasesBody4,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.purchasesBody5,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.contestsHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.contestsBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.subscriptionsHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.subscriptionsBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.freeTrialHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.freeTrialBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.feeChangesHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.feeChangesBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.refundsHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.refundsBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.contentHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.contentBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.prohibitedHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.prohibitedBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.analyticsHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.analyticsBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.googleAnalyticsHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.googleAnalyticsBody1,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.googleAnalyticsBody2,
                style: bodyFont,
              ),
              TextButton(onPressed: () => launchLink('https://policies.google.com/privacy?hl=en'), child: Text(TermsOfServiceText.googleAnalyticsBody2Link)),
              Text(
                TermsOfServiceText.googleAnalyticsBody3,
                style: bodyFont,
              ),
              TextButton(onPressed: () => launchLink('https://support.google.com/analytics/answer/6004245'), child: Text(TermsOfServiceText.googleAnalyticsBody3Link)),
              35.ph,
              Text(
                TermsOfServiceText.firebaseHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.firebaseBody1,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.firebaseBody2,
                style: bodyFont,
              ),
              TextButton(onPressed: () => launchLink('https://policies.google.com/privacy?hl=en'), child: Text(TermsOfServiceText.firebaseBody2Link)),
              Text(
                TermsOfServiceText.firebaseBody3,
                style: bodyFont,
              ),
              TextButton(onPressed: () => launchLink('https://policies.google.com/privacy?hl=en'), child: Text(TermsOfServiceText.firebaseBody3Link)),
              35.ph,
              Text(
                TermsOfServiceText.noUseHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.noUseBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.accountsHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.accountsBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.intellectualHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.intellectualBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.copyrightHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.copyrightBody1,
                style: bodyFont,
              ),
              TextButton(onPressed: () => launchLink('customersupport@bargainb.com'), child: Text(TermsOfServiceText.copyrightBody1Link)),
              Text(
                TermsOfServiceText.copyrightBody2,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.dmcaHeader,
                style: headerFont,
              ),
              Text(
                TermsOfServiceText.dmcaBody1,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.dmcaBody2,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.dmcaBody3,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.errorHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.errorBody1,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.errorBody2,
                style: bodyFont,
              ),
              TextButton(onPressed: () => launchLink('https://smartbear.com/privacy/'), child: Text(TermsOfServiceText.errorBody2Link)),
              Text(
                TermsOfServiceText.errorBody3,
                style: bodyFont,
              ),
              TextButton(onPressed: () => launchLink('https://sentry.io/privacy/'), child: Text(TermsOfServiceText.errorBody3Link)),
              Text(
                TermsOfServiceText.errorBody4,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.errorBody5,
                style: bodyFont,
              ),
              TextButton(onPressed: () => launchLink('https://policies.google.com/privacy?hl=en'), child: Text(TermsOfServiceText.errorBody5Link)),
              35.ph,
              Text(
                TermsOfServiceText.linksHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.linksBody1,
                style: bodyFont,
              ),
              20.ph,
              Text(
                TermsOfServiceText.linksBody2,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.disclaimerHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.disclaimerBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.limitationsHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.limitationsBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.terminationHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.terminationBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.governingLawHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.governingLawBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.changesHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.changesBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.amendmentsHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.amendmentsBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.waiverHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.waiverBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.acknowledgementHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.acknowledgementBody,
                style: bodyFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.contactUsHeader,
                style: headerFont,
              ),
              35.ph,
              Text(
                TermsOfServiceText.contactUsBody,
                style: bodyFont,
              ),
              TextButton(onPressed: () => launchLink('customersupport@bargainb.com'), child: Text(TermsOfServiceText.contactUsBodyLink)),
              100.ph,
              Row(
                children: [
                  Text('RedCastleCP All right Reserved. 2023', style: TextStyles.textViewLight8,),
                  Spacer(),
                    TextButton(onPressed: () => AppNavigator.pushReplacement(context: context, screen: TermsOfServiceScreen()),
                        child: Text("Terms & Conditions".tr(), style: TextStyles.textViewLight8.copyWith(decoration: TextDecoration.underline),)),
                    TextButton(onPressed: () => AppNavigator.pushReplacement(context: context, screen: PolicyScreen()), child: Text("Privacy Policy".tr(), style: TextStyles.textViewLight8.copyWith(decoration: TextDecoration.underline),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
