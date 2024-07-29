import 'package:bargainb/features_web/home/presentation/views/widgets/categories_row_web.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/generic_field_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../features/home/presentation/views/widgets/categories_list.dart';
import '../../../../../features/home/presentation/views/widgets/categories_row.dart';
import '../../../../../utils/assets_manager.dart';

class HomeBodyWeb extends StatelessWidget {
  const HomeBodyWeb({super.key});


  @override
  Widget build(BuildContext context) {
    final Map stores = {
      "Albert Heijn": albert,
      "Jumbo": jumbo,
      "Dirk": dirkLogo,
      "Hoogvliet": hoogLogo,
      "Spar": spar_store,
      "Coop": coop_store,
      "Lidl": lidle_store,
      "Aldi": aldi,
    };
    final assistantPrompts = [dealsPrompt, mealsPrompt, dietaryPrompt, nutritionPrompt];
    return Column(
      children: [
        30.ph,
        Text("Welcome to BargainB", style: TextStylesInter.textViewMedium30.copyWith(color: Color(0xffFF8A1F)),),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Your", style: TextStylesInter.textViewSemiBold12.copyWith(fontSize: 70.sp, color: Color(0xff191B26)),),
            10.pw,
            Text("Grocery", style: TextStylesInter.textViewSemiBold12.copyWith(fontSize: 70.sp, color: mainPurple),),
            10.pw,
            Text("Genius", style: TextStylesInter.textViewSemiBold12.copyWith(fontSize: 70.sp, color: mainPurple),),
            10.pw,
            Text("Awaits", style: TextStylesInter.textViewSemiBold12.copyWith(fontSize: 70.sp, color: Color(0xff191B26)),),
          ],
        ),
        20.ph,
        Text("Unleash the power of AI to navigate deals, organize your  groceries, and tailor your shopping experience with precision.", style: TextStylesInter.textViewRegular20,),
        30.ph,
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 30,
          runSpacing: 10,
          children: stores.entries
              .map((entry) => GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(blurRadius: 15, offset: Offset(0, 4), color: Color(0xff0000001A))
                ],
                border: Border.all(color: Color(0xffBABBBE))
                 ),
              child: Image.asset(
                entry.value,
                width: 60,
                height: 60,
              ),
            ),
          ))
              .toList(),
        ),
        30.ph,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: assistantPrompts.map((prompt) => SizedBox(
            width: 304.w,
            height: 320.h,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: (){},
                  child: Image.asset(prompt)),
            ),
          )).toList(),
        ),
        30.ph,
      GenericFieldWeb(
        width: 760.w,
        hintText: "Type a message or choose from above to try BargainB",
        suffixIcon: Icon(Icons.send),
      ),
        30.ph,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 200.w),
          child: const CategoriesRowWeb(),
        ),
        const CategoriesList(),
      ],
    );
  }
}
