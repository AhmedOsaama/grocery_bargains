import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MixpanelUtils {
  Mixpanel mixpanel = Mixpanel('752b3abf782a7347499ccb3ebb504194');

  void trackSocialLogin({required String providerName}) {
    mixpanel.track('social_login', properties: {"provider_name": providerName});
  }

  // void trackAppStart({required String providerName}){
  //   mixpanel.track('social_login',properties: {
  //     "provider_name": providerName
  //   });
  // }

  Future<void> createUser(
      {required String userName,
        required String email,
        required String id}) async {
    var distinctId = await mixpanel.getDistinctId();
    print(distinctId);
    mixpanel.identify(distinctId);
    // mixpanel.alias("$email", distinctId);
    print(await mixpanel.getDistinctId());
    mixpanel.getPeople().set("\$name", userName);
    mixpanel.getPeople().set("\$email", email);
    SharedPreferences.getInstance().then((value) {
      value.setBool("firstTimeAddedProduct", false);
    });
    newUsersPerMonth(email);
  }

  newUsersPerMonth(String email) {
    MixpanelUtils().mixpanel.track('Signup', properties: {
      'Account Type': 'Free',
      'Email': email,
    });
  }

  userAction(String action, String userId, String storeName, String productId) {
    MixpanelUtils().mixpanel.track('User Action', properties: {
      'Action Type': action,
      'User ID': userId,
      'Product ID': productId,
      'Store Name': storeName,
    });
  }

  productSearch(
      String searchType,
      String userId,
      String searchQuery,
      ) {
    MixpanelUtils().mixpanel.track('Product Search', properties: {
      'Search Type': searchType,
      'User ID': userId,
      'Search Query': searchQuery,
    });
  }

  chatlistAction(
      String actionType,
      String userId,
      String productId,
      String storeName,
      String shareWith,
      ) {
    MixpanelUtils().mixpanel.track('Chatlist Action', properties: {
      'Action Type': actionType,
      'User ID': userId,
      'Product ID': productId,
      'Store Name': storeName,
      'Share With': shareWith,
      'Timestamp': DateTime.now().toUtc().toString(),
    });

    SharedPreferences.getInstance().then((value) {
      var firstTimeAddedProduct =
          value.getBool("firstTimeAddedProduct") ?? true;
      if (firstTimeAddedProduct) {
        MixpanelUtils().chatlistAction("First time a user Adds a product",
            userId, productId, storeName, shareWith);
        value.setBool("firstTimeAddedProduct", false);
      }
    });

    /*  actions :
Share with ? list name ?
Last Time a User Adds A product
Lifetime Product Adds*/
  }
}
