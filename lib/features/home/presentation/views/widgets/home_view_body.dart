import 'dart:async';
import 'dart:developer';

import 'package:bargainb/features/home/presentation/views/widgets/categories_list.dart';
import 'package:bargainb/features/home/presentation/views/widgets/categories_row.dart';
import 'package:bargainb/features/home/presentation/views/widgets/latest_bargains_row.dart';
import 'package:bargainb/features/home/presentation/views/widgets/search_showcase.dart';
import 'package:bargainb/features/home/presentation/views/widgets/see_more_button.dart';
import 'package:bargainb/features/profile/presentation/views/subscription_screen.dart';
import 'package:bargainb/features/search/presentation/views/algolia_search_screen.dart';
import 'package:bargainb/features/search/presentation/views/widgets/search_widget.dart';
import 'package:bargainb/providers/subscription_provider.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../../config/routes/app_navigator.dart';
import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../chatlists/presentation/views/widgets/chatlist_overview_widget.dart';
import '../../../data/models/product.dart';
import '../top_deals_screen.dart';
import 'forward_button.dart';
import 'home_stores.dart';
import 'latest_bargains_list.dart';
import 'new_chatlist_widget.dart';
import 'top_deals_row.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              15.ph,
              // SearchWidget(),
              SearchShowcase(showcaseContext: widget.showcaseContext,),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Shop Latest Offer By Categories",
                style: TextStylesPaytoneOne.textViewRegular24,
              ),
              const CategoriesList(),
              // const NewChatlistWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top deals",
                    style: TextStylesPaytoneOne.textViewRegular24,
                  ),
                  ForwardButton(onTap: () {
                    AppNavigator.push(context: context, screen: AlgoliaSearchScreen());
                  }),
                ],
              ),
              TopDealsRow(),
              10.ph,
              Text(
                "Shop Latest Offer By Store",
                style: TextStylesPaytoneOne.textViewRegular24,
              ),
              10.ph,
              const HomeStores(),
              20.ph,
              if(!Provider.of<SubscriptionProvider>(context, listen: false).isSubscribed)
              GestureDetector(
                onTap: (){
                  AppNavigator.push(context: context, screen: SubscriptionScreen());
                },
                  child: Image.asset(homeSubscribe)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    widget.scrollController.dispose();
    super.dispose();
  }
}
