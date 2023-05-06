import 'dart:developer';

import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../widgets/discountItem.dart';

class LatestBargainsScreen extends StatefulWidget {
  const LatestBargainsScreen({Key? key}) : super(key: key);

  @override
  State<LatestBargainsScreen> createState() => _LatestBargainsScreenState();
}

class _LatestBargainsScreenState extends State<LatestBargainsScreen> {
  final PagingController<int, ComparisonProduct> _pagingController =
      PagingController(firstPageKey: 0);
  static const _pageSize = 5;
  int startingIndex = 0;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var comparisonProducts =
        Provider.of<ProductsProvider>(context, listen: true).comparisonProducts;
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: white,
          foregroundColor: Colors.black,
          title: Text(
            "Latest Bargains",
            style: TextStylesInter.textViewSemiBold17.copyWith(color: black2),
          ),
        ),
        body: comparisonProducts.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    10.ph,
                    GenericField(
                      isFilled: true,
                      onTap: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        return showSearch(
                            context: context,
                            delegate: MySearchDelegate(pref, true));
                      },
                      prefixIcon: Icon(Icons.search),
                      borderRaduis: 999,
                    ),
                    10.ph,
                    Expanded(
                      child: PagedGridView<int, ComparisonProduct>(
                        shrinkWrap: true,
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
                            inGridView: true,
                            comparisonProduct: item,
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
      log("new page $pageKey");
      if (pageKey > 0) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .getLimitedPriceComparisons(pageKey);
      }
      final newProducts = Provider.of<ProductsProvider>(context, listen: false)
          .comparisonProducts;

      final isLastPage = newProducts.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newProducts);
      } else {
        int nextPageKey = pageKey + newProducts.length;
        _pagingController.appendPage(newProducts, nextPageKey);
      }
      startingIndex++;
    } catch (error) {
      _pagingController.error = "Something wrong ! Please try again";
    }
  }
}
