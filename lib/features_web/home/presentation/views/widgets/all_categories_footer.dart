import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/style_utils.dart';

class AllCategoriesFooter extends StatelessWidget {
  const AllCategoriesFooter({super.key});

  @override
  Widget build(BuildContext context) {
  final List<String> categories = [
    "Salads, pizza, meals",
   "Meat, chicken, fish, vegetarian",
    "Cheese, cold cuts, tapas",
    "Bakery, banquete",
    "Candy, cakes, chips, chocolate",
    "Snacks",
    "Drinks",
  ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("All categories", style: TextStylesInter.textViewMedium25,),
        26.ph,
        ...categories.map((category) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(onPressed: (){}, child: Text(category, style: TextStylesInter.textViewRegular16.copyWith(color: Color(0xff7C7C7C)),)),
        )).toList(),
      ],
    );
  }
}
