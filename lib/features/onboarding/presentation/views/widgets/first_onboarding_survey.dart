import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/validator.dart';
import '../../../../../view/components/button.dart';

class FirstOnboardingSurvey extends StatefulWidget {
  final PageController pageController;
  final Function saveFirstScreenResponses;
  const FirstOnboardingSurvey({super.key, required this.saveFirstScreenResponses, required this.pageController});

  @override
  State<FirstOnboardingSurvey> createState() => _FirstOnboardingSurveyState();
}

class _FirstOnboardingSurveyState extends State<FirstOnboardingSurvey> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text("What's your name ?".tr(), style: TextStylesPaytoneOne.textViewRegular24,),
          10.ph,
          Text("Let us know how to properly address you".tr(), style: TextStylesInter.textViewMedium12,),
          20.ph,
          Text("First Name".tr(), style: TextStylesInter.textViewMedium12,),
          5.ph,
          GenericField(
            controller: _firstNameController,
            hintText: "Enter first name".tr(),
            validation: (value) => Validator.text(value),
          ),
          20.ph,
          Text("Last Name".tr(), style: TextStylesInter.textViewMedium12,),
          5.ph,
          GenericField(
            controller: _lastNameController,
            hintText: "Enter last name".tr(),
            validation: (value) => Validator.text(value),
          ),
          Spacer(),
          GenericButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  widget.saveFirstScreenResponses(_firstNameController.text.trim(), _lastNameController.text.trim());
                    widget.pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                }
              },
              width: double.infinity,
              height: 48,
              color: primaryGreen,
              borderRadius: BorderRadius.circular(6),
              child: Text(
                "Next".tr(),
                style: TextStylesInter.textViewMedium16,
              )),
        ],
      ),
    );
  }
}
