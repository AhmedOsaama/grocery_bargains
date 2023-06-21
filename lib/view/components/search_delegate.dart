import 'dart:convert';

import 'package:bargainb/models/product_category.dart';
import 'package:bargainb/services/network_services.dart';
import 'package:bargainb/view/screens/categories_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/screens/product_detail_screen.dart';
import 'package:bargainb/view/widgets/search_item.dart';

import '../../config/routes/app_navigator.dart';
import '../../models/product.dart';

class MySearchDelegate extends SearchDelegate {
  final SharedPreferences pref;
  final bool showCategories;
  MySearchDelegate(this.pref, this.showCategories);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      GestureDetector(
        onTap: () {
          query = '';
        },
        child: query.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, border: Border.all(color: grey)),
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ))
            : Container(),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    var productProvider = Provider.of<ProductsProvider>(context, listen: false);
    if (query.isNotEmpty) saveRecentSearches();
    // List allProducts =
    //     Provider.of<ProductsProvider>(context, listen: false).allProducts;
    // var searchResults = allProducts
    //     .where((product) => product['Name'].toString().contains(query))
    //     .toList();
    return FutureBuilder<List<Product>>(
        future: Provider.of<ProductsProvider>(context, listen: false)
            .searchProducts(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(
              child: CircularProgressIndicator(),
            );
          if (!snapshot.hasData || snapshot.hasError)
            return Center(
              child: Text("tryAgain".tr()),
            );
          var searchResults = snapshot.data ?? [];
          if (searchResults.isEmpty)
            return Center(
              child: Text("noMatchesFound".tr()),
            );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (ctx, i) {
                var id = searchResults[i].id;
                var productName = searchResults[i].name;
                var productBrand = searchResults[i].brand;
                var productLink = searchResults[i].url;
                var imageURL = searchResults[i].imageURL;
                var storeName = searchResults[i].storeName;
                var description = searchResults[i].description;
                var price1 = searchResults[i].price ?? '';
                var price2 = searchResults[i].price2 ?? '';
                var oldPrice = searchResults[i].oldPrice ?? "";
                var size1 = searchResults[i].size;
                var size2 = searchResults[i].size2 ?? "";
                return GestureDetector(
                  onTap: () async {
                    AppNavigator.push(
                        context: context,
                        screen: ProductDetailScreen(
                          productId: id,
                          oldPrice: oldPrice,
                          productBrand: productBrand,
                          storeName: storeName,
                          productName: productName,
                          imageURL: imageURL,
                          description: description,
                          size1: size1,
                          size2: size2,
                          price1: double.tryParse(price1) ?? 0.0,
                          price2: double.tryParse(price2) ?? 0.0,
                        ));
                  },
                  child: SearchItem(
                    name: productName,
                    imageURL: imageURL,
                    currentPrice: price1,
                    size: size1,
                    store: storeName,
                  ),
                );
              },
            ),
          );
        });
  }


  void saveRecentSearches() {
    var recentSearches = pref.getStringList('recentSearches') ?? [];
    if (recentSearches.contains(query)) return;
    recentSearches.add(query);
    pref.setStringList('recentSearches', recentSearches);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> searchResults = pref.getStringList('recentSearches') ?? [];
    List<ProductCategory> categories = [];
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return Consumer<ProductsProvider>(builder: (c, provider, _) {
      categories = provider.categories;
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !showCategories
                ? Container()
                : Expanded(
                    flex: 4,
                    child: categories.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: categories.map((element) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: categories.first == element ? 0 : 10.0,
                                ),
                                child: GestureDetector(
                                  onTap: () => AppNavigator.pushReplacement(
                                      context: context,
                                      screen: CategoriesScreen(
                                        category: element.category,
                                      )),
                                  child: SizedBox(
                                    width: 71.w,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          element.image,
                                          width: 65.w,
                                          height: 65.h,
                                        ),
                                        Text(
                                          context.locale.languageCode != "nl"
                                              ? element.englishCategory
                                              : element.category,
                                          style: TextStyles.textViewMedium10
                                              .copyWith(color: gunmetal),
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList()),
                  ),
            Text(
              LocaleKeys.recentSearches.tr(),
              style: TextStyles.textViewMedium20.copyWith(color: gunmetal),
            ),
            Expanded(
              flex: 9,
              child: ListView.separated(
                  separatorBuilder: (ctx, i) => const Divider(),
                  itemCount: suggestions.length,
                  itemBuilder: (ctx, i) {
                    final suggestion = suggestions[i];
                    return ListTile(
                      title: Text(suggestion),
                      leading: Icon(Icons.search),
                      onTap: () {
                        query = suggestion;
                        showResults(context);
                      },
                    );
                  }),
            ),
          ],
        ),
      );
    });
  }
}
