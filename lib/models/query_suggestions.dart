import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

class QuerySuggestion {
  QuerySuggestion(this.query, this.highlighted, this.categories);

  String query;
  List categories;
  HighlightedString? highlighted;

  static QuerySuggestion fromJson(Hit hit) {
    final highlighted = hit.getHighlightedString('query', inverted: true);
    return QuerySuggestion(hit["query"], highlighted, hit['category']);
  }

  @override
  String toString() => query;
}