import 'dart:convert';
import 'dart:developer';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/onboarding/presentation/views/widgets/onboarding_stepper.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/providers/user_provider.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../../providers/tutorial_provider.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/validator.dart';
import '../../../../view/components/button.dart';
import '../../../../view/components/generic_field.dart';

class CustomizeExperienceScreen extends StatefulWidget {
  CustomizeExperienceScreen({Key? key}) : super(key: key);

  @override
  State<CustomizeExperienceScreen> createState() => _CustomizeExperienceScreenState();
}

class _CustomizeExperienceScreenState extends State<CustomizeExperienceScreen> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController _goalsController = TextEditingController();

  TextEditingController _biggestFrustrationsController = TextEditingController();

  final List<String> stores = [
    "Albert Heijn",
    "Jumbo",
    "Dirk",
    "Hoogvliet",
    "Spar",
    "Coop",
    "Lidl",
    "Aldi",
  ];

  var selectedStore = "Jumbo";

  @override
  void initState() {
    trackPage();
    super.initState();
  }

  void trackPage() {
    TrackingUtils().trackPageView('Guest', DateTime.now().toUtc().toString(), "Onboarding Form Screen");
  }

  @override
  Widget build(BuildContext context) {
    bool isTextEmpty = (_goalsController.text.trim().isEmpty || _biggestFrustrationsController.text.trim().isEmpty);
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GenericButton(
          onPressed: submitForm(isTextEmpty, userProvider, context),
          width: 60,
          height: 60,
          borderRadius: BorderRadius.circular(20),
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
          color: brightOrange,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OnboardingStepper(activeStep: 1, stepSize: 15),
                  Text(
                    'Lets Customise Your Experience'.tr(),
                    style: TextStylesInter.textViewBold26,
                    textAlign: TextAlign.center,
                  ),
                  15.ph,
                  Text(
                    'Tell us about your grocery shopping habits and goals to help us tailor the app to your specific needs.'
                        .tr(),
                    style: TextStylesInter.textViewLight15,
                    textAlign: TextAlign.center,
                  ),
                  20.ph,
                  Text(
                    "What are your top grocery shopping goals?".tr(),
                    style: TextStyles.textViewRegular15,
                  ),
                  10.ph,
                  GenericField(
                    controller: _goalsController,
                    hintText: "(e.g., Save money on groceries)".tr(),
                    onSaved: (value) {},
                    onChanged: (_) {
                      setState(() {});
                    },
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                    boxShadow: BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 14,
                      offset: Offset(0, 2),
                      spreadRadius: 1,
                    ),
                    validation: (value) => Validator.text(value),
                    // colorStyle: Color.fromRGBO(237, 237, 237, 1),
                  ),
                  20.ph,
                  Text(
                    "What are your favorite stores to shop at?".tr(),
                    style: TextStyles.textViewRegular15,
                  ),
                  10.ph,
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 14,
                          offset: Offset(0, 2),
                          spreadRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Color.fromRGBO(11, 36, 58, 0.2)),
                    ),
                    child: DropdownButton<String>(
                      value: selectedStore,
                      items: stores
                          .map((store) => DropdownMenuItem<String>(
                              value: store,
                              child: Text(
                                store,
                                style: TextStylesInter.textViewRegular14,
                              )))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStore = value!;
                        });
                      },
                      underline: Container(),
                      isExpanded: true,
                    ),
                  ),
                  20.ph,
                  Text(
                    "What are your biggest frustrations with grocery shopping?".tr(),
                    style: TextStyles.textViewRegular15,
                  ),
                  10.ph,
                  GenericField(
                    controller: _biggestFrustrationsController,
                    hintText: "(e.g., findind discounts)".tr(),
                    onSaved: (value) {},
                    onChanged: (_) {
                      setState(() {});
                    },
                    maxLines: 5,
                    boxShadow: BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 14,
                      offset: Offset(0, 2),
                      spreadRadius: 1,
                    ),
                    validation: (value) => Validator.text(value),
                    // colorStyle: Color.fromRGBO(237, 237, 237, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Function()? submitForm(bool isTextEmpty, UserProvider userProvider, BuildContext context) {
    return isTextEmpty
        ? null
        : () {
            var isValid = _formKey.currentState?.validate();
            if (isValid!) {
              _formKey.currentState!.save();
              var contactData = {
                "email": userProvider.email,
                "firstname": userProvider.name,
                'phone': userProvider.phoneNumber,
                'shopping_goals': _goalsController.text.trim(),
                'favorite_store': selectedStore,
                'biggest_frustration': _biggestFrustrationsController.text.trim(),
                "hubspot_owner_id": "1252705237",
              };
              createHubspotContact(contactData);
              // AppNavigator.pushReplacement(context: context, screen: MainScreen());
              AppNavigator.pop(context: context);
              Provider.of<UserProvider>(context, listen: false).turnOffFirstTime();
              Provider.of<TutorialProvider>(context, listen: false).activateWelcomeTutorial();
              trackFormSubmitted();
            }
          };
  }

  void trackFormSubmitted() {
    TrackingUtils().trackFormSubmitted('Guest', DateTime.now().toUtc().toString(), "Onboarding Form Submission");
  }

  Future<void> createHubspotContact(Map userData) async {
    print("creating hubspot contact");
    var contactData = jsonEncode({"properties": userData});
    try {
      var response = await post(
        Uri.parse('https://api.hubapi.com/crm/v3/objects/contacts'),
        headers: {
          'Authorization': 'Bearer pat-eu1-6afeefb9-6630-45c6-b31e-e292f251c251',
          'Content-Type': 'application/json'
        },
        body: contactData,
      ).catchError((e) {
        print("ERROR CREATING HUBSPOT CONTACT");
        print(e);
      });
      if(response.statusCode == 201) {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'isHubspotContact': true,
        });
        print("DONE creating hubspot contact");
      }else{
        log("ERROR CREATING HUBSPOT CONTACT: ${response.statusCode} ---> ${response.body}");
      }
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added Hubspot Contact")));
    } catch (e) {
      print(e);
    }
  }
}
