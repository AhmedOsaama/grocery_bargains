import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../../view/components/generic_field.dart';

class SecondSurvey extends StatefulWidget {
  SecondSurvey({Key? key, required this.questionsMap, required this.saveResponse, required this.saveGroceryChallengesOther}) : super(key: key);

  final Map questionsMap;
  final Function saveResponse;
  final Function saveGroceryChallengesOther;

  @override
  State<SecondSurvey> createState() => _SecondSurveyState();
}

class _SecondSurveyState extends State<SecondSurvey> {
  var groceryMethod = "";
  var groceryChallenges = [];
  var discountFindings = [];

  var _groceryChallengesController = TextEditingController();

  var screenName = "Survey Info Collection 2: A Little About You";

  @override
  void initState() {
    super.initState();
    TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), screenName);
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
                      groupValue: groceryMethod,
                      activeColor: purple70,
                      dense: true,
                      onChanged: (value) {
                        TrackingUtils().trackSurveyAction(
                            '$screenName - Q1: $value Clicked',
                            "Guest",
                            DateTime.now().toUtc().toString(),
                            screenName,
                            value,
                            "Q1 - ${widget.questionsMap['q1'].toString()}");
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
            children: (widget.questionsMap['q2_answers'] as Map).entries.map(
              (answer) {
                return CheckboxListTile(
                    title: Text(
                      answer.key.toString().tr(),
                      style: TextStylesInter.textViewRegular14,
                    ),
                    value: answer.value,
                    activeColor: purple70,
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    secondary: buildSecondaryWidget(answer),
                    onChanged: (value) {
                      TrackingUtils().trackSurveyAction(
                          '$screenName - Q2: ${answer.key} Clicked',
                          "Guest",
                          DateTime.now().toUtc().toString(),
                          screenName,
                          answer.key,
                          "Q2 - ${widget.questionsMap['q2'].toString()}");
                      if (value!) {
                        groceryChallenges.add(answer.key);
                      } else {
                        groceryChallenges.remove(answer.key);
                      }
                      setState(() {
                        widget.questionsMap['q2_answers'][answer.key] = value;
                      });
                      if(!groceryChallenges.contains("Other")){
                        _groceryChallengesController.clear();
                        widget.saveGroceryChallengesOther("");
                      }
                        widget.saveResponse(groceryMethod, groceryChallenges, discountFindings);
                    });
              },
            ).toList(),
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
                        TrackingUtils().trackSurveyAction(
                            '$screenName - Q3: ${answer.key} Clicked',
                            "Guest",
                            DateTime.now().toUtc().toString(),
                            screenName,
                            answer.key,
                            "Q3 - ${widget.questionsMap['q3'].toString()}");
                        if (value!) {
                          discountFindings.add(answer.key);
                        } else {
                          discountFindings.remove(answer.key);
                        }
                        setState(() {
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

  SizedBox? buildSecondaryWidget(MapEntry<dynamic, dynamic> answer) {
    return answer.key == "Other"
        ? SizedBox(
            width: 180.w,
            child: GenericField(
              controller: _groceryChallengesController,
              onChanged: (value) {
                widget.saveGroceryChallengesOther(value);
              },
              validation: (value){
                value = value!.replaceAll(" ", '');
                if(value.isEmpty) return "Field must not be empty".tr();
                return null;
              },
              autoValidateMode: AutovalidateMode.always,
              enabled: groceryChallenges.contains("Other"),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              colorStyle: purple70,
              boxShadow: BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 14,
                offset: Offset(0, 2),
                spreadRadius: 1,
              ),
              // colorStyle: Color.fromRGBO(237, 237, 237, 1),
            ),
          )
        : null;
  }
}
