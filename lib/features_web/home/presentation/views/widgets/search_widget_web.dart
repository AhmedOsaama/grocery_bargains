import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/routes/app_navigator.dart';
import '../../../../../features/search/presentation/views/algolia_autocomplete_screen.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';

class SearchWidgetWeb extends StatelessWidget {
  const SearchWidgetWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // AppNavigator.push(context: context, screen: AlgoliaSearchScreen());
        AppNavigator.push(context: context, screen: AlgoliaAutoCompleteScreen());
        try{
          TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open search", DateTime.now().toUtc().toString(), "Home screen");
        }catch(e){
          TrackingUtils().trackButtonClick("Guest", "Open search", DateTime.now().toUtc().toString(), "Home screen");
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 12.h),
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: grey),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.search,color: Colors.black,),
            10.pw,
            Text(LocaleKeys.whatAreYouLookingFor.tr(),style: TextStyles.textViewSemiBold14
                .copyWith(color: greyText),)
          ],
        ),
      ),
    );
  }
}
