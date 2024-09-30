import 'dart:developer';

import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../../../../config/routes/app_navigator.dart';
import '../../../../../models/query_suggestions.dart';
import '../../../../../providers/suggestion_provider.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/icons_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../view/components/generic_field.dart';
import '../algolia_search_screen.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController? searchController;
  const SearchWidget({super.key, this.searchController});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    final suggestionRepository = context.read<SuggestionRepository>();
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Expanded(
            child: TypeAheadField<QuerySuggestion>(
              suggestionsCallback: (search) async {
                log("message");
                try {
                  suggestionRepository.query(search);
                  var suggestions = await suggestionRepository.suggestions.first;
                  return suggestions;
                }catch(e){
                  log("Suggestions error: ${e}");
                }
                return [];
              },
              builder: (context, controller, focusNode) {
                if (widget.searchController != null) {
                  controller = widget.searchController!;
                }
                textController = controller;
                return GenericField(
                    controller: textController,
                    focusNode: focusNode,
                    hintText: "What are you looking for?".tr(),
                    hintStyle: TextStyles.textViewRegular14.copyWith(color: Color(0xff71717A)),
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Color.fromRGBO(0, 178, 7, 0.1),
                      ),
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        spreadRadius: -1,
                        color: Color.fromRGBO(44, 116, 47, 0.1),
                      ),
                    ]);
              },
              itemBuilder: (context, option) {
                return ListTile(
                  title: Text(option.query),
                );
              },
              onSelected: (suggestion) {
                AppNavigator.push(
                    context: context,
                    screen: AlgoliaSearchScreen(
                      query: suggestion.query,
                    ));
              },
            ),
          ),
          10.pw,
          SizedBox(
            width: 40,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                AppNavigator.push(
                    context: context,
                    screen: AlgoliaSearchScreen(
                      query: textController.text.trim(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: EdgeInsets.zero,
                  // fixedSize: Size(40, 40),
                  // maximumSize: ,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
              child: SvgPicture.asset(
                search,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
