import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/components/dotted_container.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../view/widgets/invite_members_dialog.dart';

class ChatPrompts extends StatelessWidget {
  final Function sendPrompt;
  const ChatPrompts({super.key, required this.sendPrompt});


  @override
  Widget build(BuildContext context) {
    var prompts = [
      "@BB Find the best price for cheese",
      "@BB Build a me a grocery list for 150 euros.",
      "@BB What are the latest offers from Jumbo",
      "@BB Give me a recipe for the fried chicken",
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image.asset(newBee),
        10.ph,
        Text("Hi! I’m your BargainB grocery assistant", style: TextStylesPaytoneOne.textViewRegular24.copyWith(fontSize: 12),),
        10.ph,
        SizedBox(
          width: 230,
            child: Text(" I’m here to help you save money, find the best deals, and make your shopping easier", style: TextStylesInter.textViewRegular10, textAlign: TextAlign.center,)),
        20.ph,
        Wrap(
          runSpacing: 20,
          spacing: 20,
          children: prompts.map((prompt) {
            return GestureDetector(
                onTap: () => sendPrompt(prompt),
                child: Container(
                  width: 170,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xffCBEBCC),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Color.fromRGBO(0, 178, 7, 0.1)
                      )
                    ]
                  ),
                  child: Text(prompt, style: TextStylesInter.textViewRegular10,),
                ),
              );
          }).toList()
        )
      ],
    );
  }
}
