import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_navigator.dart';
import '../../../home/presentation/views/main_screen.dart';

class AccountFeedbackScreen extends StatelessWidget {
  final bool isPremium;
  const AccountFeedbackScreen({super.key, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(beeCheckmark),
            30.ph,
            if(isPremium) ...[
            Text("Your 7-day Premium", style: TextStylesPaytoneOne.textViewRegular24.copyWith(color: primaryGreen),textAlign: TextAlign.center,),
            Text("trial has started", style: TextStylesPaytoneOne.textViewRegular24,textAlign: TextAlign.center,)
            ],
            if(!isPremium)
            Text("Your all set up with a free account", style: TextStylesPaytoneOne.textViewRegular24,textAlign: TextAlign.center,),
            30.ph,
            GenericButton(
              width: double.infinity,
                borderRadius: BorderRadius.circular(6),
                height: 48,
                color: primaryGreen,
                onPressed: (){
              AppNavigator.pushReplacement(context: context, screen: const MainScreen());
            }, child: Text("Let's go", style: TextStylesInter.textViewMedium16,))
          ],
        ),
      ),
    );
  }
}
