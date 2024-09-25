import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/search/presentation/views/algolia_search_screen.dart';
import 'package:bargainb/providers/tutorial_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../../providers/products_provider.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tooltips_keys.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../../utils/triangle_painter.dart';
import '../../../../search/presentation/views/widgets/search_widget.dart';
import '../product_detail_screen.dart';
import '../../../data/models/product.dart';
import 'skip_tutorial_button.dart';

class SearchShowcase extends StatefulWidget {
  final BuildContext showcaseContext;
  const SearchShowcase({Key? key, required this.showcaseContext}) : super(key: key);

  @override
  State<SearchShowcase> createState() => _SearchShowcaseState();
}

class _SearchShowcaseState extends State<SearchShowcase> {
  var key = GlobalKey<State<StatefulWidget>>();
  @override
  Widget build(BuildContext context) {
    var tutorialProvider = Provider.of<TutorialProvider>(context);
    return Showcase.withWidget(
        targetBorderRadius: BorderRadius.circular(10),
        key: tutorialProvider.isTutorialRunning ? TooltipKeys.showCase2 : key,
        container: Column(
          children: [
            SizedBox(
              height: 11,
              width: 13,
              child: CustomPaint(
                painter: TrianglePainter(
                  strokeColor: Colors.white,
                  strokeWidth: 1,
                  paintingStyle: PaintingStyle.fill,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              width: 180.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white,
              ),
              child: Column(children: [
                Text(
                  "Use the search bar to locate products and uncover the best deals".tr(),
                  style: TextStyles.textViewRegular16,
                ),
                GestureDetector(
                  onTap: () async {
                    await goToProductPageTutorial(context, widget.showcaseContext);
                    ShowCaseWidget.of(widget.showcaseContext).next();
                  },
                  child: Row(
                    children: [
                      SkipTutorialButton(tutorialProvider: tutorialProvider, context: widget.showcaseContext),
                      Spacer(),
                      Text(
                        "Next".tr(),
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
          ],
        ),
        height: 50,
        width: 50,
        child: const SearchWidget());
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
