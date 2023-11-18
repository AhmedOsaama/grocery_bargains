import 'package:algolia/algolia.dart';

class AlgoliaApp {
  static final Algolia algolia = Algolia.init(
    applicationId: 'DG62X9U03X',
    apiKey: '326e0cc4392c4393f22d2a6b08f9c0db',
  );
  static const applicationID = "DG62X9U03X";
  // static const searchOnlyKey = "927c3fe76d4b52c5a2912973f35a3077";
  static const searchOnlyKey = "e862c47c6741eef540abe9fb5f68eef6";
  // static const hitsIndex = "STAGING_native_ecom_demo_products";
  static const hitsIndex = "dev_PRODUCTS";
  // static const suggestionsIndex = "STAGING_native_ecom_demo_products_query_suggestions";
  static const suggestionsIndex = "query_suggestions";
}