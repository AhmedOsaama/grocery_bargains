import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MixpanelUtils {
  static const userIdKey = 'User ID';
  static const timeStampKey = 'Timestamp';
  static const errorMessageKey = 'Error Message';
  Mixpanel mixpanel = Mixpanel('752b3abf782a7347499ccb3ebb504194');

  void trackUserRegistrationSuccess(String userId){
    mixpanel.track('User Registration Success',properties: {
      userIdKey : userId,
    });
  }

  void trackUserRegistrationFailed(String errorMessage){
    mixpanel.track('User Registration Failed',properties: {
      errorMessageKey: errorMessage,
    });
  }

  void trackOnboarding(String userId, String timeStamp, String duration){
    mixpanel.track('Onboarding started/finished', properties: {
      userIdKey: userId,
      timeStampKey: timeStamp,
      "Onboarding duration": duration
    });
  }

  void trackRegisteredUserPlatform(String platform){
    mixpanel.track('Phone Platform registered', properties: {
      "Phone Platform": platform
    });
  }

  void trackSuccessfulLogin(String userId, String loginTime){
    mixpanel.track('Successful login', properties: {
      userIdKey: userId,
      "Login Time": loginTime,
    });
  }

  void trackFailedLogin(String errorMessage){
    mixpanel.track('Failed login', properties: {
      errorMessageKey: errorMessage,
    });
  }

  void trackUserLoggedOut(String logoutTime, String userId){
    mixpanel.track('User Logged Out',properties: {
      "Logout Time": logoutTime,
      userIdKey: userId
    });
  }

  void trackAccountPlanSelected(String plan){
    mixpanel.track('Account Plan Selected', properties: {
      "Account Plan": plan
    });
  }

  void trackUserProfileViewed(String userId){
    mixpanel.track('User Profile Viewed',properties: {
      userIdKey: userId
    });
  }

  void trackUserProfileEdited(String userId){
    mixpanel.track('User Profile Edited',properties: {
      userIdKey: userId
    });
  }

  void trackAccountSettingsUpdated(String userId){
    mixpanel.track('Account Settings Updated',properties: {
      userIdKey: userId
    });
  }

  void trackProductViewed(String productId, String storeName, String userId){
    mixpanel.track('Product Viewed',properties: {
      "Product ID": productId,
      "Store Name": storeName,
      userIdKey: userId
    });
  }

  void trackShare(String userId){
    mixpanel.track('Share', properties: {
      userIdKey: userId
    });
  }

  void trackUserCreateChatlist(String userId, String chatlistName){
    mixpanel.track('User Create Chatlist', properties: {
      userIdKey: userId,
      "Chatlist Name": chatlistName
    });
  }

  void trackChatlistAction(String userId, String actionType, String actionTime){
    mixpanel.track('Chatlist Action', properties: {
      userIdKey: userId,
      "Action Type": actionType,
      "Action Time": actionTime,
    });
  }
  
  void trackSearchPerformed(String filter, String userId, String searchQuery){
    mixpanel.track('Search Performed',properties: {
      userIdKey: userId,
      "Search Filter": filter,
      "Search Query": searchQuery,
    });
  }

  void trackPageVisited(String pageName, String userId){
    mixpanel.track('Page Visited', properties: {
      userIdKey: userId,
      "Page Name": pageName
    });
  }

  void trackAccountDeleted(String userId){
    mixpanel.track('Account Deleted', properties: {
      userIdKey: userId
    });
  }

  void trackUserFeedback(String userId){
    mixpanel.track('User Feedback', properties: {
      userIdKey: userId
    });
  }

}

// Future<void> createUser(
//     {required String userName,
//       required String email,
//       required String id}) async {
//   var distinctId = await mixpanel.getDistinctId();
//   print(distinctId);
//   mixpanel.identify(distinctId);
//   // mixpanel.alias("$email", distinctId);
//   print(await mixpanel.getDistinctId());
//   mixpanel.getPeople().set("\$name", userName);
//   mixpanel.getPeople().set("\$email", email);
//   SharedPreferences.getInstance().then((value) {
//     value.setBool("firstTimeAddedProduct", false);
//   });
//   newUsersPerMonth(email);
// }
//
// newUsersPerMonth(String email) {
//   MixpanelUtils().mixpanel.track('Signup', properties: {
//     'Account Type': 'Free',
//     'Email': email,
//   });
// }
//
// userAction(String action, String userId, String storeName, String productId) {
//   MixpanelUtils().mixpanel.track('User Action', properties: {
//     'Action Type': action,
//     'User ID': userId,
//     'Product ID': productId,
//     'Store Name': storeName,
//   });
// }
//
// productSearch(
//     String searchType,
//     String userId,
//     String searchQuery,
//     ) {
//   MixpanelUtils().mixpanel.track('Product Search', properties: {
//     'Search Type': searchType,
//     'User ID': userId,
//     'Search Query': searchQuery,
//   });
// }
//
// chatlistAction(
//     String actionType,
//     String userId,
//     String productId,
//     String storeName,
//     String shareWith,
//     ) {
//   MixpanelUtils().mixpanel.track('Chatlist Action', properties: {
//     'Action Type': actionType,
//     'User ID': userId,
//     'Product ID': productId,
//     'Store Name': storeName,
//     'Share With': shareWith,
//     'Timestamp': DateTime.now().toUtc().toString(),
//   });
//
//   SharedPreferences.getInstance().then((value) {
//     var firstTimeAddedProduct =
//         value.getBool("firstTimeAddedProduct") ?? true;
//     if (firstTimeAddedProduct) {
//       MixpanelUtils().chatlistAction("First time a user Adds a product",
//           userId, productId, storeName, shareWith);
//       value.setBool("firstTimeAddedProduct", false);
//     }
//   });
//
//   /*  actions :
// Share with ? list name ?
// Last Time a User Adds A product
// Lifetime Product Adds*/
// }