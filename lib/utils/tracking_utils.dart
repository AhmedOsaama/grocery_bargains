import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingUtils {
  static const userIdKey = 'User ID';
  static const timeStampKey = 'Timestamp';
  static const errorMessageKey = 'Error Message';

  static const userRegistrationSuccessEvent = 'User Registration Success';
  static const userRegistrationFailedEvent = 'User Registration Failed';
  static const onboardingEvent = 'Onboarding started/finished';
  static const phonePlatformRegisteredEvent = 'Phone Platform registered';
  static const successfulLoginEvent = 'Successful login';
  static const failedLoginEvent = 'Failed login';
  static const userLoggedOutEvent = 'User Logged Out';
  static const accountPlanSelectedEvent = 'Account Plan Selected';
  static const userProfileViewedEvent = 'User Profile Viewed';
  static const userProfileEditedEvent = 'User Profile Edited';
  static const accountSettingsUpdatedEvent = 'Account Settings Updated';
  static const productViewedEvent = 'Product Viewed';
  static const shareEvent = 'Share';
  static const userCreateChatlistEvent = 'User Create Chatlist';
  static const chatlistActionEvent = 'Chatlist Action';
  static const searchPerformedEvent = 'Search Performed';
  static const pageVisitedEvent = 'Page Visited';
  static const accountDeletedEvent = 'Account Deleted';
  static const userFeedbackEvent = 'User Feedback';

  Mixpanel mixpanel = Mixpanel('752b3abf782a7347499ccb3ebb504194');

  void trackUserRegistrationSuccess(String userId){
    mixpanel.track(userRegistrationSuccessEvent, properties: {
      userIdKey : userId,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(userRegistrationSuccessEvent)..addCustomData(userIdKey, userId));
  }

  void trackUserRegistrationFailed(String errorMessage){
    mixpanel.track(userRegistrationFailedEvent, properties: {
      errorMessageKey: errorMessage,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(userRegistrationFailedEvent)..addCustomData(errorMessageKey, errorMessage));
  }

  void trackOnboarding(String userId, String timeStamp, String duration){
    mixpanel.track(onboardingEvent, properties: {
      userIdKey: userId,
      timeStampKey: timeStamp,
      "Onboarding duration": duration
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(onboardingEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timeStamp)
        ..addCustomData("Onboarding duration", duration)
    );

  }

  void trackRegisteredUserPlatform(String platform){
    mixpanel.track(phonePlatformRegisteredEvent, properties: {
      "Phone Platform": platform
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(phonePlatformRegisteredEvent)
      ..addCustomData("Phone Platform", platform)
    );
  }

  void trackSuccessfulLogin(String userId, String loginTime){
    mixpanel.track(successfulLoginEvent, properties: {
      userIdKey: userId,
      "Login Time": loginTime,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(successfulLoginEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData("Login Time", loginTime)
    );
  }

  void trackFailedLogin(String errorMessage){
    mixpanel.track(failedLoginEvent, properties: {
      errorMessageKey: errorMessage,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(failedLoginEvent)
      ..addCustomData(errorMessageKey, errorMessage)
    );
  }

  void trackUserLoggedOut(String logoutTime, String userId){
    mixpanel.track(userLoggedOutEvent, properties: {
      "Logout Time": logoutTime,
      userIdKey: userId
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(userLoggedOutEvent)
      ..addCustomData("Logout Time", logoutTime)
      ..addCustomData(userIdKey, userId)
    );
  }

  void trackAccountPlanSelected(String plan){
    mixpanel.track(accountPlanSelectedEvent, properties: {
      "Account Plan": plan
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(accountPlanSelectedEvent)
      ..addCustomData("Account Plan", plan)
    );
  }

  void trackUserProfileViewed(String userId){
    mixpanel.track(userProfileViewedEvent, properties: {
      userIdKey: userId
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(userProfileViewedEvent)
      ..addCustomData(userIdKey, userId)
    );
  }

  void trackUserProfileEdited(String userId){
    mixpanel.track(userProfileEditedEvent, properties: {
      userIdKey: userId
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(userProfileEditedEvent)
      ..addCustomData(userIdKey, userId)
    );
  }

  void trackAccountSettingsUpdated(String userId){
    mixpanel.track(accountSettingsUpdatedEvent, properties: {
      userIdKey: userId
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(accountSettingsUpdatedEvent)
      ..addCustomData(userIdKey, userId)
    );
  }

  void trackProductViewed(String productId, String storeName, String userId){
    mixpanel.track(productViewedEvent, properties: {
      "Product ID": productId,
      "Store Name": storeName,
      userIdKey: userId
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(productViewedEvent)
      ..addCustomData("Product ID", productId)
      ..addCustomData("Store Name", storeName)
      ..addCustomData(userIdKey, userId)
    );
  }

  void trackShare(String userId){
    mixpanel.track(shareEvent, properties: {
      userIdKey: userId
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(shareEvent)
      ..addCustomData(userIdKey, userId)
    );
  }

  void trackUserCreateChatlist(String userId, String chatlistName){
    mixpanel.track(userCreateChatlistEvent, properties: {
      userIdKey: userId,
      "Chatlist Name": chatlistName
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(userCreateChatlistEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData("Chatlist Name", chatlistName)
    );
  }

  void trackChatlistAction(String userId, String actionType, String actionTime){
    mixpanel.track(chatlistActionEvent, properties: {
      userIdKey: userId,
      "Action Type": actionType,
      "Action Time": actionTime,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(chatlistActionEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData("Action Type", actionType)
      ..addCustomData("Action Time", actionTime)
    );
  }
  
  void trackSearchPerformed(String filter, String userId, String searchQuery){
    mixpanel.track(searchPerformedEvent, properties: {
      userIdKey: userId,
      "Search Filter": filter,
      "Search Query": searchQuery,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(searchPerformedEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData("Search Filter", filter)
      ..addCustomData("Search Query", searchQuery)
    );
  }

  void trackPageVisited(String pageName, String userId){
    mixpanel.track(pageVisitedEvent, properties: {
      userIdKey: userId,
      "Page Name": pageName
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(pageVisitedEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData("Page Name", pageName)
    );
  }

  void trackAccountDeleted(String userId){
    mixpanel.track(accountDeletedEvent, properties: {
      userIdKey: userId
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(accountDeletedEvent)
      ..addCustomData(userIdKey, userId)
    );
  }

  void trackUserFeedback(String userId){
    mixpanel.track(userFeedbackEvent, properties: {
      userIdKey: userId
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(userFeedbackEvent)
      ..addCustomData(userIdKey, userId)
    );
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