import 'dart:developer';

import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/product.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/search_appBar.dart';
import '../widgets/discountItem.dart';

class LatestBargainsScreen extends StatefulWidget {
  const LatestBargainsScreen({Key? key}) : super(key: key);

  @override
  State<LatestBargainsScreen> createState() => _LatestBargainsScreenState();
}

class _LatestBargainsScreenState extends State<LatestBargainsScreen> {
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 1);
  static const _pageSize = 100;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    try{
    TrackingUtils().trackPageVisited("Latest bargains screen", FirebaseAuth.instance.currentUser!.uid);
    }catch(e){}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var comparisonProducts =
        Provider.of<ProductsProvider>(context, listen: true).products;
    return Scaffold(
        backgroundColor: white,
        appBar: SearchAppBar(isBackButton: true,),
        body: comparisonProducts.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    10.ph,
                    Expanded(
                      child: PagedGridView<int, Product>(
                        // shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                mainAxisExtent: 260,
                                childAspectRatio: 0.67,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        pagingController: _pagingController,
                        showNewPageProgressIndicatorAsGridChild: false,
                        builderDelegate: PagedChildBuilderDelegate(
                            itemBuilder: ((context, item, index) {
                          return DiscountItem(
                            inGridView: false,
                            product: item,
                          );
                        })),
                      ),
                    ),
                  ],
                ),
              ));
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      print("PAGE KEY: " + pageKey.toString());
      if (pageKey > 0) {
        // await Provider.of<ProductsProvider>(context, listen: false)
        //     .getLimitedPriceComparisons(pageKey);
      }
      final newProducts = await Provider.of<ProductsProvider>(context, listen: false).getProducts(pageKey);

      final isLastPage = newProducts.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newProducts);
      } else {
        int nextPageKey = pageKey + 1;
        _pagingController.appendPage(newProducts, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = "Something wrong ! Please try again";
    }
  }
}
