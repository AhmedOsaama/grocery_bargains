import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../models/query_suggestions.dart';
import '../../../../providers/suggestion_provider.dart';
import '../../../../utils/style_utils.dart';
import 'algolia_search_screen.dart';

class AlgoliaAutoCompleteScreen extends StatefulWidget {
  const AlgoliaAutoCompleteScreen({Key? key}) : super(key: key);

  @override
  State<AlgoliaAutoCompleteScreen> createState() => _AlgoliaAutoCompleteScreenState();
}

class _AlgoliaAutoCompleteScreenState extends State<AlgoliaAutoCompleteScreen> {
  final _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final suggestionRepository = context.read<SuggestionRepository>();
    return Scaffold(
        body: CustomScrollView(
            slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back)),
            backgroundColor: Color(0XFFF4F4F5),
            pinned: true,
            titleSpacing: 0,
            elevation: 0,
            title: SearchHeaderView(
              controller: _searchTextController,
              onSubmitted: (query) => _onSubmitSearch(query, context),
              // onSubmitted: (query) => {print("Submitted query: $query")},
              onChanged: suggestionRepository.query,
            ),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              )),
          _sectionHeader(
            suggestionRepository.history,
            Row(
              children: [
                Text(
                  "Your searches",
                  style: TextStylesInter.textViewBold14,
                ),
                const Spacer(),
                TextButton(
                    onPressed: () => suggestionRepository.clearHistory(),
                    child: const Text("Clear",
                        style: TextStyle(color: Color(0xFF5468FF))))
              ],
            ),
          ),
          _sectionBody(
              context,
              suggestionRepository.history,
                  (String item) => HistoryRowView(
                  suggestion: item,
                  onRemove: (item) =>
                      suggestionRepository.removeFromHistory(item))),
          _sectionHeader(
              suggestionRepository.suggestions,
              Text(
                "Search Suggestions",
                style: TextStylesInter.textViewBold14,
              )),
          _sectionBody(
              context,
              suggestionRepository.suggestions,
                  (QuerySuggestion item) => SuggestionRowView(
                  suggestion: item,
                  onComplete: (suggestion) =>
                  _searchTextController.value = TextEditingValue(
                    text: suggestion,
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: suggestion.length),
                    ),
                  ))),
        ]));
  }

  Widget _sectionHeader<Item>(Stream<List<Item>> itemsStream, Widget title) =>
      StreamBuilder<List<Item>>(
          stream: itemsStream,
          builder: (context, snapshot) {
            final suggestions = snapshot.data ?? [];
            return SliverSafeArea(
                top: false,
                bottom: false,
                sliver: SliverPadding(
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    sliver: SliverToBoxAdapter(
                      child:
                      suggestions.isEmpty ? const SizedBox.shrink() : title,
                    )));
          });

  Widget _sectionBody<Item>(
      BuildContext context,
      Stream<List<Item>> itemsStream,
      Function rowBuilder,
      ) =>
      StreamBuilder<List<Item>>(
          stream: itemsStream,
          builder: (context, snapshot) {
            final suggestions = snapshot.data ?? [];
            if (suggestions.isEmpty) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
            return SliverSafeArea(
                top: false,
                sliver: SliverPadding(
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            final item = suggestions[index];
                            return InkWell(
                                onTap: () {
                                  final query = item.toString();
                                  // print('Submitted query: $query');
                                  _onSubmitSearch(query, context);
                                },
                                child: rowBuilder(item));
                          },
                          childCount: suggestions.length,
                        ))));
          });

  void _onSubmitSearch(String query, BuildContext context) {
    context.read<SuggestionRepository>().addToHistory(query);
    AppNavigator.push(context: context, screen: AlgoliaSearchScreen(query: query,));
  }

}


class SearchHeaderView extends StatelessWidget {
  const SearchHeaderView(
      {Key? key, required this.controller, this.onSubmitted, this.onChanged})
      : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            controller: controller,
            onSubmitted: onSubmitted,
            onChanged: onChanged,
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search products..."),
          ),
        ),
        if (controller.text.isNotEmpty)
          IconButton(
              iconSize: 34,
              onPressed: controller.clear,
              icon: const Icon(Icons.clear),
              color: darkBlue),
        const SizedBox(width: 8)
      ],
    );
  }
}

class HistoryRowView extends StatelessWidget {
  const HistoryRowView({Key? key, required this.suggestion, this.onRemove})
      : super(key: key);

  final String suggestion;
  final Function(String)? onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(Icons.refresh),
      const SizedBox(
        width: 10,
      ),
      Text(suggestion, style: TextStylesInter.textViewRegular16),
      const Spacer(),
      IconButton(
          onPressed: () => onRemove?.call(suggestion),
          icon: const Icon(Icons.close)),
    ]);
  }
}

class SuggestionRowView extends StatelessWidget {
  const SuggestionRowView({Key? key, required this.suggestion, this.onComplete})
      : super(key: key);

  final QuerySuggestion suggestion;
  final Function(String)? onComplete;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      SvgPicture.asset(search),
      const SizedBox(
        width: 10,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
              text: TextSpan(
                  style: TextStylesInter.textViewRegular16.copyWith(color: Colors.black),
                  children: suggestion.highlighted!.toInlineSpans())),
          5.ph,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: suggestion.categories.map((category) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SvgPicture.asset(autocompleteArrow,),
                  ),
                  5.pw,
                  Text.rich(TextSpan(text: "in ",children: [TextSpan(text: category, style: TextStyle(color: Colors.grey))]),),
                ],
              ),
            )).toList(),
          ),
          10.ph,
        ],
      ),
      const Spacer(),
      IconButton(
        onPressed: () => onComplete?.call(suggestion.query),
        icon: const Icon(Icons.north_west),
      )
    ]);
  }
}



