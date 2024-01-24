import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../view/components/generic_field.dart';

class ThirdSurvey extends StatefulWidget {
  ThirdSurvey({Key? key, required this.questionsMap, required this.saveGroceryConcerns, required this.saveGroceryInterests, required this.saveGroceryAttractions, required this.saveGroceryConcernsOther}) : super(key: key);

  final Map questionsMap;
  final Function saveGroceryConcerns;
  final Function saveGroceryInterests;
  final Function saveGroceryAttractions;
  final Function saveGroceryConcernsOther;

  @override
  State<ThirdSurvey> createState() => _ThirdSurveyState();
}

class _ThirdSurveyState extends State<ThirdSurvey> {
  var groceryAttractions = "";
  var groceryInterests = "";
  var groceryConcerns = [];

  var _groceryAttractionsController = TextEditingController();
  var _groceryInterestsController = TextEditingController();
  var _groceryConcernsController = TextEditingController();

  SizedBox? buildGroceryAttractionsSecondaryWidget(String answer) {
    return answer == "Other" ? SizedBox(
      width: 180.w,
      child: GenericField(
        controller: _groceryAttractionsController,
        onChanged: (value) {
            widget.saveGroceryAttractions(value);
        },
        enabled: groceryAttractions == "Other",
        validation: (value){
          value = value!.replaceAll(" ", '');
          if(value!.isEmpty) return "Field must not be empty".tr();
        },
        autoValidateMode: AutovalidateMode.always,
        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
        colorStyle: purple70,
        boxShadow: BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 14,
          offset: Offset(0, 2),
          spreadRadius: 1,
        ),
      ),) : null;
  }
  SizedBox? buildGroceryInterestsSecondaryWidget(String answer) {
    return answer == "Other" ? SizedBox(
      width: 180.w,
      child: GenericField(
        controller: _groceryInterestsController,
        onChanged: (value) {
            widget.saveGroceryInterests(value);
        },
        validation: (value){
          value = value!.replaceAll(" ", '');
          if(value!.isEmpty) return "Field must not be empty".tr();
        },
        autoValidateMode: AutovalidateMode.always,
        enabled: groceryInterests == "Other",
        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
        colorStyle: purple70,
        boxShadow: BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 14,
          offset: Offset(0, 2),
          spreadRadius: 1,
        ),
        // colorStyle: Color.fromRGBO(237, 237, 237, 1),
      ),) : null;
  }
  SizedBox? buildGroceryConcernsSecondaryWidget(MapEntry answer) {
    return answer.key == "Other" ? SizedBox(
      width: 180.w,
      child: GenericField(
        controller: _groceryConcernsController,
        validation: (value){
          value = value!.replaceAll(" ", '');
          if(value!.isEmpty) return "Field must not be empty".tr();
        },
        onChanged: (value) {
          widget.saveGroceryConcernsOther(value);
        },
        autoValidateMode: AutovalidateMode.always,
        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
        enabled: groceryConcerns.contains("Other"),
        colorStyle: purple70,
        boxShadow: BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 14,
          offset: Offset(0, 2),
          spreadRadius: 1,
        ),
        // colorStyle: Color.fromRGBO(237, 237, 237, 1),
      ),) : null;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.questionsMap['title'].toString().tr(),
              style: TextStylesInter.textViewBold26,
              textAlign: TextAlign.center,
            ),
          ),
          10.ph,
          Center(
            child: Text(
              widget.questionsMap['subtitle'].toString().tr(),
              style: TextStylesInter.textViewRegular14,
              textAlign: TextAlign.center,
            ),
          ),
          20.ph,
          Text(
            widget.questionsMap['q1'].toString().tr(),
            style: TextStylesInter.textViewRegular14,
          ),
          11.ph,
          Column(
            children: (widget.questionsMap['q1_answers'] as List)
                .map(
                  (answer) => RadioListTile(
                      title: Text(
                        answer.toString().tr(),
                        style: TextStylesInter.textViewRegular14,
                      ),
                      value: answer,
                      groupValue: groceryAttractions,
                      activeColor: purple70,
                      secondary: buildGroceryAttractionsSecondaryWidget(answer),
                      dense: true,
                      onChanged: (value) {
                        setState(() {
                          groceryAttractions = value!;
                          _groceryAttractionsController.clear();
                        });
                        // if(value != "Other")
                          widget.saveGroceryAttractions(value);
                      }),
                )
                .toList(),
          ),
          20.ph,
          Text(
            widget.questionsMap['q2'].toString().tr(),
            style: TextStylesInter.textViewRegular14,
          ),
          5.ph,
          Column(
            children: (widget.questionsMap['q2_answers'] as List)
                .map(
                  (answer) => RadioListTile(
                      title: Text(
                        answer.toString().tr(),
                        style: TextStylesInter.textViewRegular14,
                      ),
                      value: answer,
                      activeColor: purple70,
                      groupValue: groceryInterests,
                      dense: true,
                      secondary: buildGroceryInterestsSecondaryWidget(answer),
                      onChanged: (value) {
                        setState(() {
                          groceryInterests = value;
                          _groceryInterestsController.clear();
                        });
                        // if(value != "Other")
                        widget.saveGroceryInterests(value);
                      }),
                )
                .toList(),
          ),
          20.ph,
          Text(
            widget.questionsMap['q3'].toString().tr(),
            style: TextStylesInter.textViewRegular14,
          ),
          11.ph,
          Column(
            children: (widget.questionsMap['q3_answers'] as Map)
                .entries
                .map(
                  (answer) => CheckboxListTile(
                      title: Text(
                        answer.key.toString().tr(),
                        style: TextStylesInter.textViewRegular14,
                      ),
                      value: answer.value,
                      activeColor: purple70,
                      dense: true,
                      secondary: buildGroceryConcernsSecondaryWidget(answer),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        if (value!) {
                          groceryConcerns.add(answer.key);
                        } else {
                          groceryConcerns.remove(answer.key);
                        }
                        setState(() {
                          widget.questionsMap['q3_answers'][answer.key] = value;
                        });
                        if(!groceryConcerns.contains("Other")){
                          _groceryConcernsController.clear();
                          widget.saveGroceryConcernsOther("");
                        }
                       widget.saveGroceryConcerns(groceryConcerns);
                      }),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

}
