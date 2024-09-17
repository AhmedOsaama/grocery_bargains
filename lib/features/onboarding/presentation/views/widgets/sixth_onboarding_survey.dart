import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../view/components/button.dart';

class SixthOnboardingSurvey extends StatefulWidget {
  final PageController pageController;
  final Function saveSixthScreenResponses;
  const SixthOnboardingSurvey({super.key, required this.pageController, required this.saveSixthScreenResponses});

  @override
  State<SixthOnboardingSurvey> createState() => _SixthOnboardingSurveyState();
}

class _SixthOnboardingSurveyState extends State<SixthOnboardingSurvey> {
  List<String> choices = [
    "Halal",
    "Vegetarian",
    "Gluten-Free",
    "Lactose-Free",
    "Nut-Free",
    "Low-Sugar",
    "Kosher",
    "Organic Only",
    "Vegan",
    "No Preferences"
  ];

  List<String> selectedChoices = [];

  bool showErrorText = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Do you have any dietary preferences ?".tr(),
          style: TextStylesPaytoneOne.textViewRegular24,
        ),
        10.ph,
        Text(
          "Please select any dietary preferences you have. This will help us tailor your grocery recommendations.".tr(),
          style: TextStylesInter.textViewMedium12,
        ),
        25.ph,
        Wrap(
          spacing: 10,
          children: choices.map((choice) {
            return ActionChip(
              label: Text(choice.tr(), style: TextStylesInter.textViewMedium14.copyWith(color: selectedChoices.contains(choice) ? primaryGreen : null),),
              padding: EdgeInsets.all(10),
              onPressed: selectedChoices.contains(choice)
                  ? () {
                    setState(() {
                      selectedChoices.remove(choice);
                    });
                  }
                  : () {
                setState(() {
                  selectedChoices.add(choice);
                  if(selectedChoices.contains("No Preferences")){
                    selectedChoices.removeRange(0, selectedChoices.length - 1);
                  }
                  if (showErrorText) showErrorText = false;
                });
              },
              pressElevation: 0,
              shape: selectedChoices.contains(choice) ? RoundedRectangleBorder(
                  side: BorderSide(color: primaryGreen, width: 3,),
                  borderRadius: BorderRadius.circular(999)
              ) : null,
              backgroundColor: selectedChoices.contains(choice) ? Colors.white : Color(0xffCBEBCC),
            );
            // return ActionChip(
            //   label: Text(choice.tr()),
            //   padding: EdgeInsets.all(10),
            //   onPressed: selectedChoices.contains(choice)
            //       ? null
            //       : () {
            //
            //         },
            //   pressElevation: 0,
            //   backgroundColor: Color(0xffCBEBCC),
            // );
          }).toList(),
        ),
        30.ph,
        if (showErrorText)
          Text(
            "Please select at least one goal to proceed.".tr(),
            style: TextStylesInter.textViewRegular10.copyWith(color: Colors.red),
          ),
        Spacer(),
        GenericButton(
            onPressed: () {
              if (selectedChoices.isEmpty) {
                setState(() {
                  showErrorText = true;
                });
              } else {
                widget.saveSixthScreenResponses(selectedChoices);
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
            ))
      ],
    );
  }
}
