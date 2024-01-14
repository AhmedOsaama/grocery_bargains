import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../view/components/generic_field.dart';

class SecondSurvey extends StatefulWidget {
  SecondSurvey({Key? key, required this.questionsMap, required this.saveResponse}) : super(key: key);

  final Map questionsMap;
  final Function saveResponse;

  @override
  State<SecondSurvey> createState() => _SecondSurveyState();
}

class _SecondSurveyState extends State<SecondSurvey> {
  var groceryMethod = "";
  var groceryChallenges = [];
  var discountFindings = [];

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
                  title: Text(answer.toString().tr(), style: TextStylesInter.textViewRegular14,),
                  value: answer,
                  groupValue: groceryMethod,
                  activeColor: purple70,
                  dense: true,
                  onChanged: (value) {
                    setState(() {
                      groceryMethod = value!;
                    });
                    widget.saveResponse(groceryMethod, groceryChallenges, discountFindings);
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
            children: (widget.questionsMap['q2_answers'] as Map).entries
                .map(
                  (answer) => CheckboxListTile(
                  title: Text(answer.key.toString().tr(), style: TextStylesInter.textViewRegular14,),
                  value: answer.value,
                  activeColor: purple70,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                  onChanged: (value) {
                    if(value!) {
                      groceryChallenges.add(answer.key);
                    }else{
                      groceryChallenges.remove(answer.key);
                    }
                    setState(() {
                      widget.questionsMap['q2_answers'][answer.key] = value;
                    });
                    widget.saveResponse(groceryMethod, groceryChallenges, discountFindings);
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
            children: (widget.questionsMap['q3_answers'] as Map).entries
                .map(
                  (answer) => CheckboxListTile(
                  title: Text(answer.key.toString().tr(), style: TextStylesInter.textViewRegular14,),
                  value: answer.value,
                  activeColor: purple70,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    if(value!) {
                      discountFindings.add(answer.key);
                    }else{
                      discountFindings.remove(answer.key);
                    }                    setState(() {
                      widget.questionsMap['q3_answers'][answer.key] = value;
                    });
                    widget.saveResponse(groceryMethod, groceryChallenges, discountFindings);
                  }),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}
