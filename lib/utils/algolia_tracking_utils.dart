import 'package:algolia/algolia.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

class AlgoliaTrackingUtils{
  static Algolia algolia = Algolia.init(applicationId: 'DG62X9U03X', apiKey: 'e862c47c6741eef540abe9fb5f68eef6');
  static const algoliaIndexName = 'dev_PRODUCTS';

  static void trackAlgoliaClickEvent(String userId, List<String> objectIDs, String queryId, List<int> positions, String eventName) {
    try {
      AlgoliaEvent event = AlgoliaEvent(
          eventType: AlgoliaEventType.click,
          eventName: eventName,
          index: algoliaIndexName,
          userToken: userId,
          objectIDs: objectIDs,
          queryID: queryId,
          positions: positions
      );
      algolia.pushEvents([
        event
      ]);
    } on AlgoliaException catch(e){
      print(e);
    }
  }

 static void trackAlgoliaConversionEvent(String userId, String? productId, String eventName) {
    try {
      AlgoliaEvent event = AlgoliaEvent(
          eventType: AlgoliaEventType.click,
          eventName: eventName,
          index: algoliaIndexName,
          userToken: userId,
          objectIDs: [productId!]
      );
      AlgoliaEvent event2 = AlgoliaEvent(
          eventType: AlgoliaEventType.conversion,
          eventName: eventName,
          index: algoliaIndexName,
          userToken: userId,
          objectIDs: [productId]
      );
      algolia.pushEvents([
        event,
        event2
      ]);
    }catch(e){
      print(e);
      print("ITEM ID: ${productId}");
    }
  }


}

