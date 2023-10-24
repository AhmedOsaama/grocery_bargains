import 'package:algolia/algolia.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:bargainb/utils/algolia_utils.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/components/search_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../models/product.dart';
import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../widgets/discountItem.dart';

class AlgoliaSearchScreen extends StatefulWidget {
  final String query;
  const AlgoliaSearchScreen({Key? key, this.query = ''}) : super(key: key);

  @override
  State<AlgoliaSearchScreen> createState() => _AlgoliaSearchScreenState();
}

class _AlgoliaSearchScreenState extends State<AlgoliaSearchScreen> {
  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 0);
  final _searchTextController = TextEditingController();
  final _productsSearcher =
      HitsSearcher(applicationID: 'DG62X9U03X', apiKey: 'e862c47c6741eef540abe9fb5f68eef6', indexName: 'dev_PRODUCTS');
  // indexName: 'productss');

  final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();

  final _filterState = FilterState();

  late final _facetList = FacetList(
      searcher: _productsSearcher,
      filterState: _filterState,
      selectionMode: SelectionMode.single,
      attribute: 'store_id');

  var storeDropdownValue = "Store";

  Stream<SearchMetadata> get _searchMetadata => _productsSearcher.responses.map(SearchMetadata.fromResponse);
  Stream<HitsPage> get _searchPage => _productsSearcher.responses.map(HitsPage.fromResponse);

  var storeList = ['Store', 'Albert Heijn', 'Jumbo', 'Hoogvliet', "Dirk"];

  @override
  void initState() {
    _searchTextController.text = widget.query;
    _productsSearcher.query(_searchTextController.text);
    _searchTextController.addListener(() => _productsSearcher.query(_searchTextController.text));

    _searchTextController.addListener(
      () => _productsSearcher.applyState(
        (state) => state.copyWith(
          query: _searchTextController.text,
          page: 0,
        ),
      ),
    );

    _searchPage.listen((page) {
      if (page.pageKey == 0) {
        _pagingController.refresh();
      }
      _pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) {
      print("ERROR IN SEARCH: $error");
      return _pagingController.error = error;
    });

    _pagingController.addPageRequestListener((pageKey) => _productsSearcher.applyState((state) => state.copyWith(
          page: pageKey,
        )));

    _productsSearcher.connectFilterState(_filterState);
    _filterState.filters.listen((_) => _pagingController.refresh());

    try {
      TrackingUtils()
          .trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Search screen");
    }catch(e){
      TrackingUtils()
          .trackPageView('Guest', DateTime.now().toUtc().toString(), "Search screen");
    }
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _productsSearcher.dispose();
    _pagingController.dispose();
    _filterState.dispose();
    _facetList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          80.ph,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => AppNavigator.pop(context: context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: mainPurple,
                      ),
                      SvgPicture.asset(
                        bargainbIcon,
                        height: 42.h,
                      ),
                    ],
                  ),
                ),
                6.pw,
                Expanded(
                  child: GenericField(
                    controller: _searchTextController,
                    borderRaduis: 999,
                    colorStyle: grey,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: LocaleKeys.whatAreYouLookingFor.tr(),
                    hintStyle: TextStyles.textViewSemiBold14.copyWith(color: greyText),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //     height: 50,
          //     child: TextField(
          //       controller: _searchTextController,
          //       decoration: const InputDecoration(
          //         border: InputBorder.none,
          //         hintText: 'Enter a search term',
          //         prefixIcon: Icon(Icons.search),
          //       ),
          //     )),
          10.ph,
          _filters(context),
          Center(
            child: StreamBuilder<SearchMetadata>(
              stream: _searchMetadata,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                try {
                  TrackingUtils().trackSearch(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(),
                      _searchTextController.text);
                } catch (e) {
                  print(e);
                  TrackingUtils().trackSearch("Guest", DateTime.now().toUtc().toString(), _searchTextController.text);
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${snapshot.data!.nbHits} hits'),
                );
              },
            ),
          ),
          Expanded(child: _hits(context))
        ],
      ),
    );
  }

  Widget _filters(BuildContext context) => StreamBuilder<List<SelectableItem<Facet>>>(
      stream: _facetList.facets,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final selectableFacets = snapshot.data ?? [];
        if (selectableFacets.length != storeList.length - 1) return SizedBox.shrink();
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.all(Radius.circular(6.r)), border: Border.all(color: grey)),
          child: DropdownButton<String>(
            value: storeDropdownValue,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: greyDropdownText,
            ),
            iconSize: 24,
            underline: Container(),
            style: TextStylesInter.textViewRegular14.copyWith(color: greyDropdownText),
            borderRadius: BorderRadius.circular(4.r),
            onChanged: changeFilter,
            items: storeList.map<DropdownMenuItem<String>>((String value) {
              var index = storeList.indexOf(value) - 1;
              if (value == 'Store' || selectableFacets.isEmpty) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyles.textViewMedium12,
                  ),
                );
              }
              // if(index >= 0 && index < selectableFacets.length)
              var selectableFacet = selectableFacets[index];
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  "$value (${selectableFacet.item.count})",
                  style: TextStyles.textViewMedium12,
                ),
              );
            }).toList(),
          ),
        );
      });

  void changeFilter(String? newValue) async {
    try {
      TrackingUtils().trackFilterUsed(
          FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Search screen", 'store');
    } catch (e) {
      print(e);
      TrackingUtils().trackFilterUsed("Guest", DateTime.now().toUtc().toString(), "Search screen", 'store');
    }
    setState(() {
      storeDropdownValue = newValue!;
    });
    if (storeDropdownValue == "Store") _filterState.clear();
    if (storeDropdownValue != 'Store') _facetList.toggle(storeList.indexOf(storeDropdownValue).toString());
  }

  Widget _hits(BuildContext context) => PagedGridView<int, Product>(
      pagingController: _pagingController,
      padding: EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisExtent: 260,
          childAspectRatio: 0.67,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      builderDelegate: PagedChildBuilderDelegate<Product>(
        noItemsFoundIndicatorBuilder: (_) => const Center(
          child: Text('No results found'),
        ),
        itemBuilder: (_, item, __) => DiscountItem(
          inGridView: false,
          product: item,
        ),
      ));
}

class SearchMetadata {
  final int nbHits;

  const SearchMetadata(this.nbHits);

  factory SearchMetadata.fromResponse(SearchResponse response) => SearchMetadata(response.nbHits);
}

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<Product> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(Product.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }
}
