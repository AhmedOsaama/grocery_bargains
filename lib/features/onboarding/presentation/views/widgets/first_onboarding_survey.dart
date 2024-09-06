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
        Text("What's your name ?", style: TextStylesPaytoneOne.textViewRegular24,),
          10.ph,
          Text("Let us know how to properly address you", style: TextStylesInter.textViewMedium12,),
          20.ph,
          Text("First Name", style: TextStylesInter.textViewMedium12,),
          5.ph,
          GenericField(
            controller: _firstNameController,
            hintText: "Enter first name",
            validation: (value) => Validator.text(value),
          ),
          20.ph,
          Text("Last Name", style: TextStylesInter.textViewMedium12,),
          5.ph,
          GenericField(
            controller: _lastNameController,
            hintText: "Enter last name",
            validation: (value) => Validator.text(value),
          ),
          Spacer(),
          GenericButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  widget.saveFirstScreenResponses(_firstNameController.text.trim(), _lastNameController.text.trim());
                    widget.pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                }
                // if (_pageNumber >= _totalPages - 1) {
                //   log("Survey Finished");
                // } else if (_pageNumber < _totalPages - 1) {
                //   _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                // }
              },
              width: double.infinity,
              height: 48,
              color: primaryGreen,
              borderRadius: BorderRadius.circular(6),
              child: Text(
                "Next",
                style: TextStylesInter.textViewMedium16,
              )),
        ],
      ),
    );
  }
}
