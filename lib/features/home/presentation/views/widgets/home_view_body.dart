import 'dart:async';
import 'dart:developer';

import 'package:bargainb/features/home/presentation/views/widgets/categories_list.dart';
import 'package:bargainb/features/home/presentation/views/widgets/categories_row.dart';
import 'package:bargainb/features/home/presentation/views/widgets/latest_bargains_row.dart';
import 'package:bargainb/features/home/presentation/views/widgets/search_showcase.dart';
import 'package:bargainb/features/home/presentation/views/widgets/see_more_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../../utils/tracking_utils.dart';
import '../../../data/models/product.dart';
import 'latest_bargains_list.dart';
import 'new_chatlist_widget.dart';

class HomeViewBody extends StatefulWidget {
  final ScrollController scrollController;
  final bool showFAB;
  final Function(bool) updateFAB;
  final BuildContext showcaseContext;
  const HomeViewBody(
      {Key? key,
      required this.scrollController,
      required this.showFAB,
      required this.updateFAB,
      required this.showcaseContext})
      : super(key: key);

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 0);
  List allProducts = [];
  var isLoading = false;
  TextStyle textButtonStyle = TextStylesInter.textViewRegular16.copyWith(color: mainPurple);
  bool dialogOpened = false;
  var isFetching = false;
  late Future getProductsFuture;

  @override
  void initState() {
    super.initState();
    getProductsFuture = Provider.of<ProductsProvider>(context, listen: false).getProducts(1);
    if (FirebaseAuth.instance.currentUser != null) {
      TrackingUtils()
          .trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Home Screen");
    }
    addScrollListener();
  }

  @override
  void didChangeDependencies() {
    // log("Tracking app start language: ${context.locale.languageCode}");
    TrackingUtils().trackAppStartLanguage(DateTime.now().toUtc().toString(), context.locale.languageCode);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            SliverToBoxAdapter(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15.h,
                ),
                SearchShowcase(showcaseContext: widget.showcaseContext),
                SizedBox(
                  height: 10.h,
                ),
                const CategoriesRow(),
                const CategoriesList(),
                const NewChatlistWidget(),
                SizedBox(
                  height: 10.h,
                ),
                const LatestBargainsRow(),
              ],
            )),
            const LatestBargainsList(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SeeMoreButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addScrollListener() {
    return widget.scrollController.addListener(() {
      double showOffset = 200.0;
      if (widget.scrollController.offset > showOffset) {
        if (!widget.showFAB) widget.updateFAB(true);
      } else {
        if (widget.showFAB) widget.updateFAB(false);
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    widget.scrollController.dispose();
    super.dispose();
  }
}
