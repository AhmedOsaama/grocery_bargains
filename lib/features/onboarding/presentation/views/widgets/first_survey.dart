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
  var city = "Choose City";
  List<String> countries = [
    'Choose City',
    'Russia',
    'Germany',
    'United Kingdom',
    'France',
    'Italy',
    'Spain',
    'Ukraine',
    'Poland',
    'Romania',
    'Netherlands',
    'Belgium',
    'Czechia',
    'Greece',
    'Portugal',
    'Sweden',
    'Hungary',
    'Belarus',
    'Austria',
    'Serbia',
    'Switzerland',
    'Bulgaria',
    'Denmark',
    'Finland',
    'Slovakia',
    'Norway',
    'Ireland',
    'Croatia',
    'Moldova',
    'Bosnia and Herzegovina',
    'Albania',
    'Lithuania',
    'North Macedonia',
    'Slovenia',
    'Latvia',
    'Kosovo',
    'Estonia',
    'Montenegro',
    'Luxembourg',
    'Malta',
    'Iceland',
    'Andorra',
    'Monaco',
    'Liechtenstein',
    'San Marino',
    'Holy See',
  ];


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
                        widget.saveResponse(age, city, groceryTime);

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
          Container(
            // width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 14,
                  offset: Offset(0, 2),
                  spreadRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Color(0xFF7192F2)),
            ),
            child: DropdownButton<String>(
              value: city,
              items: countries
                  .map((store) => DropdownMenuItem<String>(
                  value: store,
                  child: Text(
                    store,
                    style: TextStylesInter.textViewRegular14,
                  )))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  city = value!;
                });
                widget.saveResponse(age, city, groceryTime);
              },
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              underline: Container(),
              // isDense: true,
            ),
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
                    widget.saveResponse(age, city, groceryTime);
                  }),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}
