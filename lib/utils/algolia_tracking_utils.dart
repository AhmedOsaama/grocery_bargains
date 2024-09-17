import 'dart:developer';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:bargainb/utils/algolia_utils.dart';
import 'package:bargainb/utils/tracking_utils.dart';

class AlgoliaTrackingUtils{
  // static Algolia algolia = Algolia.init(applicationId: 'DG62X9U03X', apiKey: AlgoliaApp.searchOnlyKey);
  static const algoliaIndexName = AlgoliaApp.hitsIndex;

  static Future<void> trackAlgoliaClickEvent(String objectID, String queryId, int position) async {
    try {
      var value = await TrackingUtils.segment.track('Product Clicked', properties: {
        "search_index": algoliaIndexName,
        "product_id": objectID,
        "position": position,
        "query_id": queryId,
      });
      log("Algolia tracking value: $value");
      // TrackingUtils().segment.track('Product Clicked', {
      //   product_id: '507f1f77bcf86cd799439011',
      //   sku: 'G-32',
      //   category: 'Games',
      //   name: 'Monopoly: 3rd Edition',
      //   brand: 'Hasbro',
      //   variant: '200 pieces',
      //   price: 18.99,
      //   quantity: 1,
      //   coupon: 'MAYDEALS',
      //   position: 3,
      //   url: 'https://www.example.com/product/path',
      //   image_url: 'https://www.example.com/product/path.jpg'
      // });
    } catch(e){
      print("ALGOLIA CLICK EVENT ERROR: $e");
    }
  }

 static void trackAlgoliaProductAddedEvent(String objectId, String queryId) {
   try {
     TrackingUtils.segment.track('Product Added', properties: {
       "search_index": algoliaIndexName,
       "product_id": objectId,
       "query_id": queryId,
     });
    }catch(e){
      print("ALGOLIA Conversion EVENT ERROR: $e");
      print("ITEM ID: ${objectId}");
    }
  }


}

