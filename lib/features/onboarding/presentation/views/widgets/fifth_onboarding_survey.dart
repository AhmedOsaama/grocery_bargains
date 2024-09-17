import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../view/components/button.dart';

class FifthOnboardingSurvey extends StatefulWidget {
  final PageController pageController;
  final Function saveFifthScreenResponses;
  const FifthOnboardingSurvey({super.key, required this.pageController, required this.saveFifthScreenResponses});

  @override
  State<FifthOnboardingSurvey> createState() => _FifthOnboardingSurveyState();
}

class _FifthOnboardingSurveyState extends State<FifthOnboardingSurvey> {
  List<String> choices = [
    "Salads", "Quark", "Bread", "Pastries", "Cheese",
    "Dairy", "Meat", "Wine", "Coffee",
    "Yogurt", "Pasta", "Chocolate", "Snacks",
    "Chips", "Pet Food", "Soap", "Toiletries",
    "Cleaning Products", "Juice",
    "Cold Cuts", "Soft Drinks", "Sausages",
    "Fruits", "Ready Made", "Potatoes",
    "Beer", "Vegetables", "Candy", "Tea",
  ];

  List<String> selectedChoices = [];

  bool showErrorText = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What’s on your typical shopping list ?".tr(),
            style: TextStylesPaytoneOne.textViewRegular24,
          ),
          10.ph,
          Text(
            "Choose the items that are usually on your grocery shopping list. You can select multiple options.".tr(),
            style: TextStylesInter.textViewMedium12,
          ),
          20.ph,
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
            }).toList(),
          ),
          30.ph,
          if (showErrorText)
            Text(
              "Please select at least one goal to proceed.".tr(),
              style: TextStylesInter.textViewRegular10.copyWith(color: Colors.red),
            ),
          // Spacer(),
          20.ph,
          GenericButton(
              onPressed: () {
                if (selectedChoices.isEmpty) {
                  setState(() {
                    showErrorText = true;
                  });
                } else {
                  widget.saveFifthScreenResponses(selectedChoices);
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
      ),
    );
  }
}
