import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

class QuerySuggestion {
  QuerySuggestion(this.query, this.highlighted, this.categories);
  // QuerySuggestion(this.query, this.highlighted);

  String query;
  List categories;
  HighlightedString? highlighted;

  static QuerySuggestion fromJson(Hit hit) {
    final highlighted = hit.getHighlightedString('query', inverted: true);
    // print("RESULTS: ${hit['category']}");
    print("RESULTS: ${hit}");
    return QuerySuggestion(hit["query"], highlighted, hit['category']);
    // return QuerySuggestion(hit["query"], highlighted,);
  }

  @override
  String toString() => query;
}