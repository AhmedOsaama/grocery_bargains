import 'dart:developer';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:bargainb/features/search/presentation/views/widgets/filter_bottom_sheet.dart';
import 'package:bargainb/features/search/presentation/views/widgets/search_appBar.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/algolia_utils.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes/app_navigator.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/icons_manager.dart';
import '../../../../utils/style_utils.dart';
import '../../../home/data/models/product.dart';
import '../../../home/presentation/views/widgets/product_item.dart';

class AlgoliaSearchScreen extends StatefulWidget {
  final String query;
  final String? category;
  final String? store;
  const AlgoliaSearchScreen({Key? key, this.query = '', this.category, this.store}) : super(key: key);

  @override
  State<AlgoliaSearchScreen> createState() => _AlgoliaSearchScreenState();
}

class _AlgoliaSearchScreenState extends State<AlgoliaSearchScreen> {
  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 0);
  final _searchTextController = TextEditingController();
  final _productsSearcher = HitsSearcher(
      applicationID: AlgoliaApp.applicationID, apiKey: AlgoliaApp.searchOnlyKey, indexName: AlgoliaApp.hitsIndex);

  final _filterState = FilterState();

  late final FacetList storeFilter;
  late final FacetList categoryFilter;
  late final FacetList subcategoryFilter;

  Stream<SearchMetadata> get _searchMetadata => _productsSearcher.responses.map(SearchMetadata.fromResponse);
  Stream<HitsPage> get _searchPage => _productsSearcher.responses.map(HitsPage.fromResponse);

  late String queryId;

  // var storeList = ['Store', 'Albert Heijn', 'Jumbo', 'Hoogvliet', "Dirk"];

  @override
  void initState() {
    storeFilter = _productsSearcher.buildFacetList(
      filterState: _filterState,
      selectionMode: SelectionMode.multiple,
      attribute: 'store_name',
    );

    categoryFilter = _productsSearcher.buildFacetList(
      filterState: _filterState,
      selectionMode: SelectionMode.single,
      attribute: 'category_name',
    );

    subcategoryFilter = _productsSearcher.buildFacetList(
      filterState: _filterState,
      selectionMode: SelectionMode.single,
      attribute: 'subcategory_name',
    );

    _searchTextController.text = widget.query;
    _productsSearcher.query(_searchTextController.text);
    _searchTextController.addListener(() => _productsSearcher.query(_searchTextController.text));

    _searchTextController.addListener(
      () => _productsSearcher.applyState(
        (state) => state.copyWith(query: _searchTextController.text, page: 0, clickAnalytics: true),
      ),
    );

    _searchPage.listen((page) {
      if (page.pageKey == 0) {
        _pagingController.refresh();
      }
      queryId = page.queryId!;
      _pagingController.appendPage(page.items, page.nextPageKey);
      Provider.of<ProductsProvider>(context, listen: false).products.addAll(page.items);
    }).onError((error) {
      print("ERROR IN SEARCH: $error");
      return _pagingController.error = error;
    });

    _pagingController.addPageRequestListener(
        (pageKey) => _productsSearcher.applyState((state) => state.copyWith(page: pageKey, clickAnalytics: true)));

    _productsSearcher.connectFilterState(_filterState);
    _filterState.filters.listen((_) => _pagingController.refresh());

    if (widget.category != null) {
      categoryFilter.toggle(widget.category!);
    }
    if (widget.store != null) {
      storeFilter.toggle(widget.store!);
    }

    try {
      TrackingUtils()
          .trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Search screen");
    } catch (e) {
      TrackingUtils().trackPageView('Guest', DateTime.now().toUtc().toString(), "Search screen");
    }
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _productsSearcher.dispose();
    _pagingController.dispose();
    _filterState.dispose();
    storeFilter.dispose();
    categoryFilter.dispose();
    subcategoryFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(controller: _searchTextController),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.ph,
            widget.category != null
                ? Text(
                    "Results for '${widget.category}'",
                    style: TextStylesPaytoneOne.textViewRegular24,
                  )
                : Text(
                    "Results for '${widget.query}'",
                    style: TextStylesPaytoneOne.textViewRegular24,
                  ),
            Center(
              child: StreamBuilder<SearchMetadata>(
                stream: _searchMetadata,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${snapshot.data!.nbHits} items'),
                  );
                },
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () async {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          builder: (ctx) => FilterBottomSheet(
                                storeFilter: storeFilter,
                                categoryFilter: categoryFilter,
                                subCategoryFilter: subcategoryFilter,
                                filterState: _filterState,
                                productSearcher: _productsSearcher,
                              ));
                    },
                    icon: Icon(Icons.filter_list))),
            Expanded(child: _hits(context))
          ],
        ),
      ),
    );
  }

  Widget _hits(BuildContext context) => PagedGridView<int, Product>(
      pagingController: _pagingController,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.w, mainAxisExtent: 280, crossAxisSpacing: 10, mainAxisSpacing: 10),
      builderDelegate: PagedChildBuilderDelegate<Product>(
        noItemsFoundIndicatorBuilder: (_) => Center(
          child: Text('No results found'.tr()),
        ),
        itemBuilder: (_, item, index) => ProductItem(
          product: item,
          productIndex: index,
          queryId: queryId,
        ),
      ));
}

class SearchMetadata {
  final int nbHits;

  const SearchMetadata(this.nbHits);

  factory SearchMetadata.fromResponse(SearchResponse response) => SearchMetadata(response.nbHits);
}

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey, this.queryId);

  final List<Product> items;
  final int pageKey;
  final int? nextPageKey;
  final String? queryId;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(Product.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    // items.removeWhere((element) => element.availableNow == 0);
    List<String> objectIDs = items.map((e) => e.id.toString()).toList();
    List<int> positions = items.map((e) => items.indexOf(e) + 1).toList();
    trackSearch(response.query, response.queryID, objectIDs: objectIDs, positions: positions);
    return HitsPage(items, response.page, nextPageKey, response.queryID);
  }
}

void trackSearch(String query, String? queryId, {required List<String> objectIDs, required List<int> positions}) {
  try {
    TrackingUtils().trackSearch(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), query,
        queryId: queryId!, objectIDs: objectIDs, positions: positions);
  } catch (e) {
    print(e);
    TrackingUtils().trackSearch("Guest", DateTime.now().toUtc().toString(), query,
        queryId: queryId!, objectIDs: objectIDs, positions: positions);
  }
}
