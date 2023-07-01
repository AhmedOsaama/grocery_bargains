import 'dart:convert';

import 'package:bargainb/models/product_category.dart';
import 'package:bargainb/services/network_services.dart';
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
    return FutureBuilder<List<Product?>>(
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
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15.h,
                  childAspectRatio: 0.6
              ),
              itemCount: searchResults.length,
              itemBuilder: (ctx, i) {
                // var id = searchResults[i].id;
                // var productName = searchResults[i].name;
                // var productBrand = searchResults[i].brand;
                // var productLink = searchResults[i].url;
                // var imageURL = searchResults[i].imageURL;
                // var storeName = searchResults[i].storeName;
                // var description = searchResults[i].description;
                // var price1 = searchResults[i].price ?? '';
                // var price2 = searchResults[i].price2 ?? '';
                // var oldPrice = searchResults[i].oldPrice ?? "";
                // var size1 = searchResults[i].size;
                // var size2 = searchResults[i].size2 ?? "";
                return DiscountItem(inGridView: false, product: searchResults[i],);
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

  void getRecentSearches(String input){
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
    if(query.isEmpty) return [];
    var resultsResponse = await Future.wait([
    NetworkServices.getSearchSuggestions(input, "products"),
    NetworkServices.getSearchSuggestions(input, "jumbo"),
    NetworkServices.getSearchSuggestions(input, "hoogvliet"),
    ]);
    List decodedResults = [...jsonDecode(resultsResponse[0].body), ...jsonDecode(resultsResponse[1].body), ...jsonDecode(resultsResponse[2].body)];
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
                  ...networkSuggestion.map((suggestion) => ListTile(
                    title: Text(suggestion),
                    leading: Icon(Icons.search),
                    onTap: () {
                      query = suggestion;
                      showResults(context);
                    },
                  )
                  ).toList(),
                  ...suggestions.map((suggestion) => ListTile(
                    title: Text(suggestion),
                    leading: Icon(Icons.history),
                    onTap: () {
                      query = suggestion;
                      showResults(context);
                    },
                  )
                  ).toList(),
                ],
              ),
            ),
          );
        }
      );
}}
