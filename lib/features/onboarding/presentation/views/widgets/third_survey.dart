import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../view/components/generic_field.dart';

class ThirdSurvey extends StatefulWidget {
  ThirdSurvey({Key? key, required this.questionsMap, required this.saveResponse}) : super(key: key);

  final Map questionsMap;
  final Function saveResponse;

  @override
  State<ThirdSurvey> createState() => _ThirdSurveyState();
}

class _ThirdSurveyState extends State<ThirdSurvey> {
  var groceryAttractions = "";
  var groceryInterests = "";
  var groceryConcerns = [];

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
                      dense: true,
                      onChanged: (value) {
                        setState(() {
                          groceryAttractions = value!;
                        });
                        widget.saveResponse(groceryAttractions, groceryInterests, groceryConcerns);
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
                      onChanged: (value) {
                        setState(() {
                          groceryInterests = value;
                        });
                        widget.saveResponse(groceryAttractions, groceryInterests, groceryConcerns);
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
                        widget.saveResponse(groceryAttractions, groceryInterests, groceryConcerns);
                      }),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
