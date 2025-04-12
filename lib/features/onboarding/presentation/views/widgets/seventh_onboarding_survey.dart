import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/onboarding/presentation/views/free_trial_screen.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/style_utils.dart';
import '../../../../../view/components/button.dart';

class SeventhOnboardingSurvey extends StatefulWidget {
  final PageController pageController;
  final Function saveSeventhScreenResponses;
  const SeventhOnboardingSurvey({super.key, required this.pageController, required this.saveSeventhScreenResponses});

  @override
  State<SeventhOnboardingSurvey> createState() => _SeventhOnboardingSurveyState();
}

class _SeventhOnboardingSurveyState extends State<SeventhOnboardingSurvey> {
  List<String> budgets = [
    "Less than €100",
    "€100 - €200",
    "€200 - €300",
    "€400 - €500",
    "More than €500",
  ];

  String selectedBudget = "";

  bool showErrorText = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Last Question! What’s your monthly grocery budget ?".tr(),
          style: TextStylesPaytoneOne.textViewRegular24,
        ),
        10.ph,
        Text(
          "Please enter your average monthly grocery budget to help us find the best deals within your spending range".tr(),
          style: TextStylesInter.textViewMedium12,
        ),
        25.ph,
        Column(
          children: budgets
              .map(
                (budget) => RadioListTile(
                title: Text(
                  budget.tr(),
                  style: TextStylesInter.textViewRegular14,
                ),
                value: budget,
                groupValue: selectedBudget,
                activeColor: primaryGreen,
                dense: true,
                onChanged: (value) {
                  setState(() {
                    selectedBudget = value!;
                  });
                }),
          )
              .toList(),
        ),
        if (showErrorText)
          Text(
            "Please select at least one choice to proceed.".tr(),
            style: TextStylesInter.textViewRegular10.copyWith(color: Colors.red),
          ),
        Spacer(),
        GenericButton(
            onPressed: () async {
              if (selectedBudget.isEmpty) {
                setState(() {
                  showErrorText = true;
                });
              } else {
                await widget.saveSeventhScreenResponses(selectedBudget);
                AppNavigator.pushReplacement(context: context, screen: FreeTrialScreen());
                // widget.pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
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
