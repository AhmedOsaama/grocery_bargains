import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/widgets/chat_search_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';

class ChatSearchDelegate extends SearchDelegate {
  final SharedPreferences pref;

  ChatSearchDelegate(this.pref);

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
    if (query.isNotEmpty) saveRecentSearches();
    // List allProducts =
    //     Provider.of<ProductsProvider>(context, listen: false).allProducts;
    // var searchResults = allProducts
    //     .where((product) => product['Name'].toString().contains(query))
    //     .toList();
    return FutureBuilder<List<ChatList>>(
        future: Provider.of<ChatlistsProvider>(context, listen: false)
            .searchChatLists(query),
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
                return GestureDetector(
                  onTap: () async {
                    pushNewScreen(context,
                        screen: ChatListViewScreen(
                          // updateList: updateList,
                          listId: searchResults[i].id,
                        ),
                        withNavBar: false);
                  },
                  child: ChatSearchItem(
                    list: searchResults[i],
                  ),
                );
              },
            ),
          );
        });
  }

  void saveRecentSearches() {
    var recentSearches = pref.getStringList('recentChatSearches') ?? [];
    if (recentSearches.contains(query)) return;
    recentSearches.add(query);
    pref.setStringList('recentChatSearches', recentSearches);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> searchResults = pref.getStringList('recentChatSearches') ?? [];

    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return Consumer<ProductsProvider>(builder: (c, provider, _) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
