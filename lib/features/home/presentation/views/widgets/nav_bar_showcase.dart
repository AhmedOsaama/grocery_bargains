import 'package:bargainb/providers/subscription_provider.dart';
import 'package:bargainb/providers/tutorial_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../providers/products_provider.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/down_triangle_painter.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tooltips_keys.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../data/models/product.dart';
import '../product_detail_screen.dart';
import 'skip_tutorial_button.dart';

class NavBarTutorial extends StatelessWidget {
  final BuildContext builder;
  const NavBarTutorial({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tutorialProvider = Provider.of<TutorialProvider>(context);
    return Showcase.withWidget(
      key: tutorialProvider.isTutorialRunning ? TooltipKeys.showCase1 : GlobalKey<State<StatefulWidget>>(),
      container: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            width: 180.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.white,
            ),
            child: Column(children: [
              Text(
                "Navigate easily with the navigation bar: Discover deals, access your sidekick, and manage your profile".tr(),
                style: TextStyles.textViewRegular16,
              ),
              GestureDetector(
                onTap: () {
                  if(SubscriptionProvider.get(context).isSubscribed){
                    goToProductPageTutorial(context, builder);
                    return;
                  }
                  ShowCaseWidget.of(builder).next();
                  // ShowCaseWidget.of(builder).dismiss();
                },
                child: Row(
                  children: [
                    SkipTutorialButton(tutorialProvider: tutorialProvider, context: builder),
                    Spacer(),
                    Text(
                      LocaleKeys.next.tr(),
                      style: TextStyles.textViewSemiBold14,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15.sp,
                    )
                  ],
                ),
              )
            ]),
          ),
          Container(
            height: 11,
            width: 13,
            child: CustomPaint(
              painter: DownTrianglePainter(
                strokeColor: Colors.white,
                strokeWidth: 1,
                paintingStyle: PaintingStyle.fill,
              ),
            ),
          ),
        ],
      ),
      height: 110.h,
      width: 190.h,
      child: Container(
        height: 0,
        color: Colors.transparent,
      ),
    );
  }
  Future<void> goToProductPageTutorial(BuildContext context, BuildContext builder) async {
    var productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    ShowCaseWidget.of(builder).dismiss();
    try {
      Product product = Provider.of<ProductsProvider>(context, listen: false).products[10];
      await pushNewScreen(context,
          screen: ProductDetailScreen(
            product: product,
          ));
      ShowCaseWidget.of(builder).next();
      try {
        TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open product page",
            DateTime.now().toUtc().toString(), "Home screen");
      } catch (e) {
        print(e);
        TrackingUtils()
            .trackButtonClick("Guest", "Open product page", DateTime.now().toUtc().toString(), "Home screen");
      }
    } catch (e) {
      print(e);
    }
  }

}
