import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../view/components/generic_field.dart';

class FirstSurvey extends StatefulWidget {
  FirstSurvey({Key? key, required this.questionsMap, required this.saveResponse}) : super(key: key);

  final Map questionsMap;
  final Function saveResponse;

  @override
  State<FirstSurvey> createState() => _FirstSurveyState();
}

class _FirstSurveyState extends State<FirstSurvey> {
  var _cityController = TextEditingController();

  var age = "";
  var groceryTime = "";

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
                      groupValue: age,
                      activeColor: purple70,
                      dense: true,
                      onChanged: (value) {
                        setState(() {
                          age = value!;
                        });
                        widget.saveResponse(age, _cityController.text.trim(), groceryTime);

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
          GenericField(
            controller: _cityController,
            onSaved: (value) {},
            onChanged: (_) {
              widget.saveResponse(age, _cityController.text.trim(), groceryTime);
            },
            contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
            colorStyle: purple70,
            boxShadow: BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 14,
              offset: Offset(0, 2),
              spreadRadius: 1,
            ),
            // colorStyle: Color.fromRGBO(237, 237, 237, 1),
          ),
          20.ph,
          Text(
            widget.questionsMap['q3'].toString().tr(),
            style: TextStylesInter.textViewRegular14,
          ),
          11.ph,
          Column(
            children: (widget.questionsMap['q3_answers'] as List)
                .map(
                  (answer) => RadioListTile(
                      title: Text(answer.toString().tr(), style: TextStylesInter.textViewRegular14,),
                      value: answer,
                  groupValue: groceryTime,
                      activeColor: purple70,
                      dense: true,
                  onChanged: (value) {
                    setState(() {
                      groceryTime = value!;
                    });
                    widget.saveResponse(age, _cityController.text.trim(), groceryTime);
                  }),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}
