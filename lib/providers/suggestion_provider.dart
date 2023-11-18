import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../models/query_suggestions.dart';
import '../utils/algolia_utils.dart';

/// Query suggestions data repository.
class SuggestionRepository with ChangeNotifier {
  /// Hits Searcher for suggestions index
  final _suggestionsSearcher = HitsSearcher(
    applicationID: AlgoliaApp.applicationID,
    apiKey: AlgoliaApp.searchOnlyKey,
    indexName: AlgoliaApp.suggestionsIndex,
  );

  /// Get query suggestions for a given query string.
  void query(String query) {
    _suggestionsSearcher.query(query);
  }

  /// Get query suggestions stream
  late final Stream<List<QuerySuggestion>> suggestions = _suggestionsSearcher
      .responses
      .map((response) => response.hits.map(QuerySuggestion.fromJson).toList());

  /// In-memory store of submitted queries.
  final BehaviorSubject<List<String>> _history =
  BehaviorSubject.seeded(['jackets']);

  /// Stream of previously submitted queries.
  Stream<List<String>> get history => _history;

  /// Add a query to queries history store.
  void addToHistory(String query) {
    if (query.isEmpty) return;
    final _current = _history.value;
    _current.removeWhere((element) => element == query);
    _current.add(query);
    _history.sink.add(_current);
  }

  /// Remove a query from queries history store.
  void removeFromHistory(String query) {
    final _current = _history.value;
    _current.removeWhere((element) => element == query);
    _history.sink.add(_current);
  }

  /// Clear everything from queries history store.
  void clearHistory() {
    _history.sink.add([]);
  }

  /// Dispose of underlying resources.
  void dispose() {
    super.dispose();
    _suggestionsSearcher.dispose();
  }
}