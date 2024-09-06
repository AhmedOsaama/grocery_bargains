import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../view/components/button.dart';

class ThirdOnboardingSurvey extends StatefulWidget {
  final PageController pageController;
  final Function saveThirdScreenResponses;
  const ThirdOnboardingSurvey({super.key, required this.pageController, required this.saveThirdScreenResponses});

  @override
  State<ThirdOnboardingSurvey> createState() => _ThirdOnboardingSurveyState();
}

class _ThirdOnboardingSurveyState extends State<ThirdOnboardingSurvey> {
  List<String> choices = [
    "Compare Prices",
    "Save Money",
    "Find Deals",
    "Share Lists",
    "Dietary Needs",
    "Recipe Ideas",
    "Discover Stores",
    "Organize by Store",
    "Manage Lists",
    "Multi-Household Shopping"
  ];

  List<String> selectedChoices = [];

  bool showErrorText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What are your goals with Bargainb ?", style: TextStylesPaytoneOne.textViewRegular24,),
        10.ph,
        Text("Select one or more goals to help us personalize your experience", style: TextStylesInter.textViewMedium12,),
        25.ph,
        Wrap(
          spacing: 10,
          children: choices.map((choice) {
            return ActionChip(label: Text(choice),padding: EdgeInsets.all(10), onPressed: selectedChoices.contains(choice) ? null : (){
              setState(() {
                selectedChoices.add(choice);
                if(showErrorText) showErrorText = false;
              });
            }, pressElevation: 0, backgroundColor: Color(0xffCBEBCC),);
          }).toList(),
        ),
        30.ph,
        if(selectedChoices.isNotEmpty) Text("Selected Choices: $selectedChoices"),
        if(showErrorText) Text("Please select at least one goal to proceed.", style: TextStylesInter.textViewRegular10.copyWith(color: Colors.red),),
        Spacer(),
        GenericButton(
            onPressed: () {
              if(selectedChoices.isEmpty){
                setState(() {
                showErrorText = true;
                });
              }else{
                  widget.saveThirdScreenResponses(selectedChoices);
                  widget.pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
              }
            },
            width: double.infinity,
            height: 48,
            color: primaryGreen,
            borderRadius: BorderRadius.circular(6),
            child: Text(
              "Next",
              style: TextStylesInter.textViewMedium16,
            ))
      ],
    );
  }
}
