import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../view/components/button.dart';

class SecondOnboardingSurvey extends StatefulWidget {
  final PageController pageController;
  final Function saveSecondScreenResponses;
  const SecondOnboardingSurvey({super.key, required this.pageController, required this.saveSecondScreenResponses});

  @override
  State<SecondOnboardingSurvey> createState() => _SecondOnboardingSurveyState();
}

class _SecondOnboardingSurveyState extends State<SecondOnboardingSurvey> {
  bool? soloShopper;
  
  int grownUps = 0;
  int littleOnes = 0;
  int furryFriends = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Who’s on Your Shopping List ?".tr(), style: TextStylesPaytoneOne.textViewRegular24,),
        10.ph,
        Text("We want to make sure no one goes hungry. Who are you usually shopping for ?".tr(), style: TextStylesInter.textViewMedium12,),
        20.ph,
      GestureDetector(
        onTap: (){
          setState(() {
          soloShopper = true;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Color(0xffE4E4E7)),
            boxShadow: soloShopper == null || !soloShopper! ? null : [
              BoxShadow(
                color: Color(0xff001F8F).withOpacity(0.1),
                offset: Offset(0,10),
                blurRadius: 15,
                spreadRadius: -3
              ),
              BoxShadow(
                color: Color(0xff001F8F).withOpacity(0.1),
                offset: Offset(0,4),
                blurRadius: 6,
                spreadRadius: -4
              )
            ]
          ),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              if(soloShopper != null && soloShopper!)
                const Icon(Icons.check_circle_outline_rounded, color: Colors.green,),
              10.pw,
              SizedBox(
                width: ScreenUtil().screenWidth - 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Just Me, Myself, and I".tr(), style: TextStylesPaytoneOne.textViewRegular24.copyWith(color: Color(0xff1B461C))),
                    Text("The solo shopper's dream—your grocery list, your rules!".tr(), style: TextStylesInter.textViewMedium12,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
        30.ph,
        GestureDetector(
          onTap: (){
            setState(() {
            soloShopper = false;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xffE4E4E7)),
                boxShadow: soloShopper == null || soloShopper! ? null : [
                  BoxShadow(
                      color: Color(0xff001F8F).withOpacity(0.1),
                      offset: Offset(0,10),
                      blurRadius: 15,
                      spreadRadius: -3
                  ),
                  BoxShadow(
                      color: Color(0xff001F8F).withOpacity(0.1),
                      offset: Offset(0,4),
                      blurRadius: 6,
                      spreadRadius: -4
                  )
                ]
            ),
            child: Row(
              children: [
                if(soloShopper != null && !soloShopper!)
                  const Icon(Icons.check_circle_outline_rounded, color: Colors.green,),
                10.pw,
                SizedBox(
                  width: ScreenUtil().screenWidth - 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("I’ve Got a Hungry Bunch".tr(), style: TextStylesPaytoneOne.textViewRegular24.copyWith(color: Color(0xff1B461C))),
                      Text("Whether it's family, friends, or even pets, let's make sure everyone gets their favorites!".tr(), style: TextStylesInter.textViewMedium12,)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        20.ph,
        if(soloShopper != null && !soloShopper!)
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  // color: Colors.white,
                    border: Border.all(color: const Color(0xffE4E4E7))),
                child: Row(
                  children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Grown-Ups".tr(), style: TextStylesInter.textViewMedium14,),
                      Text("Spouses, partners, or anyone who’s got an appetite.".tr(), style: TextStylesInter.textViewRegular10,),
                    ],
                  ),
                    Spacer(),
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          setState(() {
                            if(grownUps > 0) grownUps--;
                          });
                        }, icon: Icon(Icons.remove)),
                        Text("$grownUps"),
                        IconButton(onPressed: (){
                          setState(() {
                            grownUps++;
                          });
                        }, icon: Icon(Icons.add)),
                      ],
                    )
                  ],
                ),
              ),
              20.ph,
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  // color: Colors.white,
                    border: Border.all(color: const Color(0xffE4E4E7))),
                child: Row(
                  children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Little Ones".tr(), style: TextStylesInter.textViewMedium14,),
                      Text("Because your little ones are important".tr(), style: TextStylesInter.textViewRegular10,),
                    ],
                  ),
                    Spacer(),
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          setState(() {
                            if(littleOnes > 0) littleOnes--;
                          });
                        }, icon: Icon(Icons.remove)),
                        Text("$littleOnes"),
                        IconButton(onPressed: (){
                          setState(() {
                            littleOnes++;
                          });
                        }, icon: Icon(Icons.add)),
                      ],
                    )
                  ],
                ),
              ),
              20.ph,
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  // color: Colors.white,
                    border: Border.all(color: const Color(0xffE4E4E7))),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Furry Friends".tr(), style: TextStylesInter.textViewMedium14,),
                        Text("Because your pets have preferences too!".tr(), style: TextStylesInter.textViewRegular10,),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          setState(() {
                            if(furryFriends > 0) furryFriends--;
                          });
                        }, icon: Icon(Icons.remove)),
                        Text("$furryFriends"),
                        IconButton(onPressed: (){
                          setState(() {
                            furryFriends++;
                          });
                        }, icon: Icon(Icons.add)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        Spacer(),
        GenericButton(
            onPressed: () {
              if(soloShopper != null){
                widget.saveSecondScreenResponses(soloShopper, grownUps, littleOnes, furryFriends);
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
            )),
      ],
    );
  }
}
