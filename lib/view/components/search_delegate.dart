import 'dart:convert';

import 'package:bargainb/models/product_category.dart';
import 'package:bargainb/services/network_services.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/screens/category_screen.dart';
import 'package:bargainb/view/widgets/discountItem.dart';
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

  List<String> suggestions = [];
  String sortDropdownValue = 'Sort';
  String storeDropdownValue = 'Store';

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
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: grey)),
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
    return FutureBuilder<List<Product?>>(
        future: Provider.of<ProductsProvider>(context, listen: false).searchProducts(query),
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
          // var results = List.from(searchResults);
          var results = [];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: StatefulBuilder(builder: (context, setState) {
              results = filterProducts(results, searchResults, productProvider);
              return Column(
                children: [
                  20.ph,
                  Row(children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(color: orange70, borderRadius: BorderRadius.all(Radius.circular(6.r))),
                      child: DropdownButton<String>(
                        value: sortDropdownValue,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: white,
                        ),
                        iconSize: 24,
                        underline: Container(),
                        dropdownColor: orange70,
                        style: TextStyles.textViewMedium12,
                        borderRadius: BorderRadius.circular(4.r),
                        onChanged: (String? newValue) {
                          setState(() {
                            sortDropdownValue = newValue!;
                          });
                        },
                        items:
                            <String>['Sort', 'Low price', 'High price'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyles.textViewMedium12,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    8.pw,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(color: orange70, borderRadius: BorderRadius.all(Radius.circular(6.r))),
                      child: Center(
                        child: DropdownButton<String>(
                          value: storeDropdownValue,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: white,
                          ),
                          iconSize: 24,
                          dropdownColor: orange70,
                          underline: Container(),
                          style: TextStyles.textViewMedium12,
                          borderRadius: BorderRadius.circular(4.r),
                          onChanged: (String? newValue) {
                            setState(() {
                              storeDropdownValue = newValue!;
                            });
                          },
                          items: <String>['Store', 'Albert Heijn', 'Jumbo', 'Hoogvliet']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyles.textViewMedium12,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    8.pw,
                  ]),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisSpacing: 15.h, childAspectRatio: 0.6),
                      itemCount: results.length,
                      itemBuilder: (ctx, i) {
                        return DiscountItem(
                          inGridView: false,
                          product: results[i],
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }

  List filterProducts(List results, List<Product?> searchResults, ProductsProvider productProvider) {
    if (sortDropdownValue == "Sort" && storeDropdownValue == "Store") {
      results = List.from(searchResults);
    }
    if (sortDropdownValue != "Sort" && storeDropdownValue == "Store") {
      results = productProvider.sortProducts(sortDropdownValue, results);
    }
    if (sortDropdownValue == "Sort" && storeDropdownValue != "Store") {
      if (storeDropdownValue == "Albert Heijn") {
        results =
            searchResults.where((searchResult) => searchResult?.storeName == "Albert").toList();
      }else{
        results =
            searchResults.where((searchResult) => searchResult?.storeName == storeDropdownValue).toList();
      }
    }
    if (sortDropdownValue != "Sort" && storeDropdownValue != "Store") {
      if (storeDropdownValue == "Albert Heijn") {
        results =
            searchResults.where((searchResult) => searchResult?.storeName == "Albert").toList();
      }else{
        results =
            searchResults.where((searchResult) => searchResult?.storeName == storeDropdownValue).toList();
      }
      results = productProvider.sortProducts(sortDropdownValue, results);
    }
    return results;
  }

  void saveRecentSearches() {
    var recentSearches = pref.getStringList('recentSearches') ?? [];
    if (recentSearches.contains(query)) return;
    recentSearches.add(query);
    pref.setStringList('recentSearches', recentSearches);
  }

  void getRecentSearches(String input) {
    suggestions.clear();
    List<String> searchResults = pref.getStringList('recentSearches') ?? [];
    suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      return result.contains(input);
    }).toList();
  }

  Future<List> buildFutureSuggestions() async {
    final input = query.toLowerCase();
    getRecentSearches(input);
    List<String> networkSuggestions = [];
    if (query.isEmpty) return [];
    var resultsResponse = await Future.wait([
      NetworkServices.getSearchSuggestions(input, "products"),
      NetworkServices.getSearchSuggestions(input, "jumbo"),
      NetworkServices.getSearchSuggestions(input, "hoogvliet"),
    ]);
    List decodedResults = [
      ...jsonDecode(resultsResponse[0].body),
      ...jsonDecode(resultsResponse[1].body),
      ...jsonDecode(resultsResponse[2].body)
    ];
    decodedResults.forEach((result) {
      networkSuggestions.add(result['name']);
    });
    return networkSuggestions.where((suggestion) {
      return suggestion.toLowerCase().contains(input);
    }).toList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List>(
        future: buildFutureSuggestions(),
        builder: (context, snapshot) {
          // if(snapshot.connectionState == ConnectionState.waiting){
          //   return Container();
          // }
          var networkSuggestion = snapshot.data ?? [];
          print(networkSuggestion);
          return Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...networkSuggestion
                      .map((suggestion) => ListTile(
                            title: Text(suggestion),
                            leading: Icon(Icons.search),
                            onTap: () {
                              query = suggestion;
                              showResults(context);
                            },
                          ))
                      .toList(),
                  ...suggestions
                      .map((suggestion) => ListTile(
                            title: Text(suggestion),
                            leading: Icon(Icons.history),
                            onTap: () {
                              query = suggestion;
                              showResults(context);
                            },
                          ))
                      .toList(),
                ],
              ),
            ),
          );
        });
  }
}
