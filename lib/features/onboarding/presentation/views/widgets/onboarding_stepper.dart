import 'package:bargainb/utils/style_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../utils/icons_manager.dart';

class OnboardingStepper extends StatefulWidget {
  final int activeStep;
  final double stepSize;
  OnboardingStepper({Key? key, required this.activeStep, required this.stepSize}) : super(key: key);

  @override
  State<OnboardingStepper> createState() => _OnboardingStepperState();
}

class _OnboardingStepperState extends State<OnboardingStepper> {
  late int activeStep;
  @override
  void initState() {
    activeStep = widget.activeStep;
    super.initState();
  }

  TextStyle style = TextStylesInter.textViewMedium12;
  var activeStepWidget = SvgPicture.asset(activeStepIcon);
  var unReachedStepWidget = SvgPicture.asset(unreachedStepIcon);


  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      activeStep: activeStep,
      lineLength: 35,
      lineSpace: 4,
      lineType: LineType.dotted,
      defaultLineColor: Color(0xFFE6E6E6),
      finishedLineColor: Color(0xFF0162DD),
      activeLineColor: Color(0xFF0162DD),
      internalPadding: 0,
      showLoadingAnimation: false,
      stepRadius: widget.stepSize,
      showStepBorder: false,
      lineThickness: 2,
      steps: [
        EasyStep(
          customStep: activeStep >= 0 ? activeStepWidget : unReachedStepWidget,
          customTitle: Text('Select Plan'.tr(), style: style.copyWith(color: activeStep >= 0 ?  Color(0xFF0162DD) :Color(0xFF465668)), textAlign: TextAlign.center,),
        ),
        EasyStep(
         customStep: activeStep >= 1 ? activeStepWidget : unReachedStepWidget,
          customTitle: Text('Payment'.tr(), style: style.copyWith(color: activeStep >= 1 ?  Color(0xFF0162DD) : Color(0xFF465668)), textAlign: TextAlign.center,),
        ),
        EasyStep(
          customStep: activeStep >= 2 ? activeStepWidget : unReachedStepWidget,
          customTitle: Text('Setup'.tr(), style: style.copyWith(color: activeStep >= 2 ?  Color(0xFF0162DD) :Color(0xFF465668)), textAlign: TextAlign.center,),
        ),
        EasyStep(
          customStep: activeStep >= 3 ? activeStepWidget : unReachedStepWidget,
          customTitle: Text('Tutorial'.tr(), style: style.copyWith(color: activeStep >= 3 ?  Color(0xFF0162DD) :Color(0xFF465668)), textAlign: TextAlign.center,),
        ),
        EasyStep(
          customStep: activeStep >= 4 ? activeStepWidget : unReachedStepWidget,
          customTitle: Text('Start Saving'.tr(), style: style.copyWith(color: activeStep >= 4 ?  Color(0xFF0162DD) : Color(0xFF465668)), textAlign: TextAlign.center,),
        ),
      ],
      // onStepReached: (index) =>
      //     setState(() => activeStep = index),
    );
  }
}
