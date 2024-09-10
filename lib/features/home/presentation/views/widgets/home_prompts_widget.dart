import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/style_utils.dart';

class HomePrompts extends StatelessWidget {
  final Function sendPrompt;
  const HomePrompts({super.key, required this.sendPrompt});

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
                  child: Text(prompt.tr(), style: TextStylesInter.textViewRegular10,),
                ),
              );
            }).toList()
        )
      ],
    );
  }
}
