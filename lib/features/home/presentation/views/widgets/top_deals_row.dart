import 'dart:developer';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../utils/algolia_utils.dart';
import '../../../../search/presentation/views/algolia_search_screen.dart';
import '../../../data/models/product.dart';
import 'product_item.dart';

class TopDealsRow extends StatefulWidget {
  const TopDealsRow({super.key});

  @override
  State<TopDealsRow> createState() => _TopDealsRowState();
}

class _TopDealsRowState extends State<TopDealsRow> {
  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 0);
  final _productsSearcher =
  HitsSearcher(applicationID: AlgoliaApp.applicationID,
      apiKey: AlgoliaApp.searchOnlyKey,
      indexName: AlgoliaApp.hitsIndex);

  Stream<HitsPage> get _searchPage => _productsSearcher.responses.map(HitsPage.fromResponse);

  @override
  void initState() {
    super.initState();
    _productsSearcher.query('');

    _searchPage.listen((page) {
      if (page.pageKey == 0) {
        _pagingController.refresh();
      }
      _pagingController.appendPage(page.items, page.nextPageKey);
      log(page.items.map((e) => "price: ${e.price}, oldPrice: ${e.oldPrice}\n").toList().toString());
    }).onError((error) {
      print("ERROR IN TopDealsRow pagination: $error");
      return _pagingController.error = error;
    });

    _pagingController.addPageRequestListener((pageKey) => _productsSearcher.applyState((state) => state.copyWith(
        page: pageKey,
        clickAnalytics: true
    )));

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      child: PagedListView(
          pagingController: _pagingController,
          scrollDirection: Axis.horizontal,
          builderDelegate: PagedChildBuilderDelegate<Product>(
            noItemsFoundIndicatorBuilder: (_) => const Center(
              child: Text('No results found'),
            ),
            itemBuilder: (_, item, __) => ProductItem(
              product: item,
            ),
          )),
    );
  }
}
