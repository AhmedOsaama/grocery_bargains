import 'package:algolia/algolia.dart';

class AlgoliaApp {
  static final Algolia algolia = Algolia.init(
    applicationId: 'DG62X9U03X',
    apiKey: '326e0cc4392c4393f22d2a6b08f9c0db',
  );
  static const applicationID = "DG62X9U03X";
  static const searchOnlyKey = "e862c47c6741eef540abe9fb5f68eef6";
  static const hitsIndex = "new_db";
  static const priceLowToHighIndex = "new_db_price_asc";
  static const priceHighToLowIndex = "new_db_price_desc";
  static const suggestionsIndex = "query_suggestions";
}