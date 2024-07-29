import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../config/routes/app_navigator.dart';
import '../../../../../features/home/presentation/views/all_categories_screen.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';

class CategoriesRowWeb extends StatelessWidget {
  const CategoriesRowWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Popular Categories".tr(),
          style: TextStylesInter.textViewBold16.copyWith(color: prussian),
        ),
        TextButton(
            onPressed: () {
              AppNavigator.push(context: context, screen: AllCategoriesScreen());
              try {
                TrackingUtils().trackTextLinkClicked(FirebaseAuth.instance.currentUser!.uid,
                    DateTime.now().toUtc().toString(), "Home screen", "See all categories");
              } catch (e) {
                print(e);
                TrackingUtils().trackTextLinkClicked(
                    'Guest', DateTime.now().toUtc().toString(), "Home screen", "See all categories");
              }
            },
            child: Text(
              'seeAll'.tr(),
              style: TextStylesInter.textViewRegular16.copyWith(color: mainPurple),
            ))
      ],
    );
  }
}
