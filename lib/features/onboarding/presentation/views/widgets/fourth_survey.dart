import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../../view/components/generic_field.dart';

class FourthSurvey extends StatefulWidget {
  FourthSurvey({Key? key, required this.questionsMap, required this.saveResponse}) : super(key: key);

  final Map questionsMap;
  final Function saveResponse;

  @override
  State<FourthSurvey> createState() => _FourthSurveyState();
}

class _FourthSurveyState extends State<FourthSurvey> {

  var premiumAppInterest = "";
  var monthlySubscriptionPrice = "";
  var monthPayPreference = "";

  var screenName = "Survey Info Collection 4: Valuing Your Views";

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
                  title: Text(answer.toString().tr(), style: TextStylesInter.textViewRegular14,),
                  value: answer,
                  groupValue: premiumAppInterest,
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
                      premiumAppInterest = value!;
                    });
                    widget.saveResponse(premiumAppInterest, monthlySubscriptionPrice, monthPayPreference);
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
                  title: Text(answer.toString().tr(), style: TextStylesInter.textViewRegular14,),
                  value: answer,
                  groupValue: monthlySubscriptionPrice,
                  activeColor: purple70,
                  dense: true,
                  onChanged: (value) {
                    TrackingUtils().trackSurveyAction(
                        '$screenName - Q2: $value Clicked',
                        "Guest",
                        DateTime.now().toUtc().toString(),
                        screenName,
                        value,
                        "Q2 - ${widget.questionsMap['q2'].toString()}");
                    setState(() {
                      monthlySubscriptionPrice = value!;
                    });
                    widget.saveResponse(premiumAppInterest, monthlySubscriptionPrice , monthPayPreference);
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
            children: (widget.questionsMap['q3_answers'] as List)
                .map(
                  (answer) => RadioListTile(
                  title: Text(answer.toString().tr(), style: TextStylesInter.textViewRegular14,),
                  value: answer,
                  groupValue: monthPayPreference,
                  activeColor: purple70,
                  dense: true,
                  onChanged: (value) {
                    TrackingUtils().trackSurveyAction(
                        '$screenName - Q3: $value Clicked',
                        "Guest",
                        DateTime.now().toUtc().toString(),
                        screenName,
                        value,
                        "Q3 - ${widget.questionsMap['q3'].toString()}");
                    setState(() {
                      monthPayPreference = value!;
                    });
                    widget.saveResponse(premiumAppInterest, monthlySubscriptionPrice , monthPayPreference);
                  }),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}
