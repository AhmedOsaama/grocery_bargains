// import 'dart:developer';
//
// import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
// import 'package:bargainb/utils/algolia_utils.dart';
//
// class AlgoliaTrackingUtils{
//   static Algolia algolia = Algolia.init(applicationId: 'DG62X9U03X', apiKey: AlgoliaApp.searchOnlyKey);
//   static const algoliaIndexName = AlgoliaApp.hitsIndex;
//
//   static void trackAlgoliaClickEvent(String userId, List<String> objectIDs, String queryId, List<int> positions, String eventName) {
//     try {
//       AlgoliaEvent event = AlgoliaEvent(
//           eventType: AlgoliaEventType.click,
//           eventName: eventName,
//           index: algoliaIndexName,
//           userToken: userId,
//           objectIDs: objectIDs,
//           queryID: queryId,
//           positions: positions
//       );
//       algolia.pushEvents([
//         event
//       ]);
//     } on AlgoliaException catch(e){
//       print("ALGOLIA CLICK EVENT ERROR: $e");
//     }
//   }
//
//  static void trackAlgoliaConversionEvent(String userId, String? productId, String eventName) {
//    try {
//       AlgoliaEvent event = AlgoliaEvent(
//           eventType: AlgoliaEventType.click,
//           eventName: eventName,
//           index: algoliaIndexName,
//           userToken: userId,
//           objectIDs: [productId!]
//       );
//       AlgoliaEvent event2 = AlgoliaEvent(
//           eventType: AlgoliaEventType.conversion,
//           eventName: eventName,
//           index: algoliaIndexName,
//           userToken: userId,
//           objectIDs: [productId]
//       );
//       algolia.pushEvents([
//         event,
//         event2
//       ]);
//     }catch(e){
//       print("ALGOLIA Conversion EVENT ERROR: $e");
//       print("ITEM ID: ${productId}");
//     }
//   }
//
//
// }
//
