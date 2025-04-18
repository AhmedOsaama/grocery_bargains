import 'dart:developer';

import 'package:bargainb/utils/algolia_tracking_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:segment_analytics/analytics.dart';
import 'package:segment_analytics/client.dart';
import 'package:segment_analytics/state.dart';

import '../core/utils/tracking_constants.dart';

class TrackingUtils {
  // Mixpanel segment = Mixpanel('3aa827fb2f1cdf5ff2393b84d9c40bac');
  static Analytics segment = createClient(Configuration("ju4vP6Xnyc1tRoh6O1NAtTxFhyyMkX4Y"));

  void trackButtonClick(String userId, String buttonName, String timestamp, String pageName) {
    segment.track(TrackingConstants.buttonClickEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.buttonNameKey: buttonName,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.buttonClickEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.buttonNameKey, buttonName)
          ..addCustomData(TrackingConstants.pageNameKey, pageName)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.buttonClickEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.buttonNameKey: buttonName,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.timeStampKey: timestamp,
    });
  }

  void trackPageView(String userId, String timestamp, String pageName) {
    segment.track(TrackingConstants.pageViewEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.pageViewEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.pageNameKey, pageName)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.pageViewEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.timeStampKey: timestamp,
    });
  }

  void trackPopPageView(String userId, String timestamp, String popUpName) {
    segment.track(TrackingConstants.popPageViewEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.popUpNameKey: popUpName,
      TrackingConstants.timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.popPageViewEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.popUpNameKey, popUpName)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.popPageViewEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.popUpNameKey: popUpName,
      TrackingConstants.timeStampKey: timestamp,
    });
  }

  void trackTextLinkClicked(String userId, String timestamp, String pageName, String textLinkName) {
    segment.track(TrackingConstants.textLinkClickedEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.textLinkNameKey: textLinkName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.textLinkClickedEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.pageNameKey, pageName)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.textLinkNameKey, textLinkName));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.textLinkClickedEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.textLinkNameKey: textLinkName,
    });
  }

  void trackLanguageSelected(String userId, String timestamp, String languageSelected) {
    segment.track(TrackingConstants.languageSelectedEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.languageSelectedKey: languageSelected,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.languageSelectedEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.languageSelectedKey, languageSelected));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.languageSelectedEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.languageSelectedKey: languageSelected,
    });
  }

  void trackAppStartLanguage(String timestamp, String languageSelected) {
    segment.track(TrackingConstants.appStartLanguageEvent, properties: {
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.languageSelectedKey: languageSelected,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.appStartLanguageEvent)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.languageSelectedKey, languageSelected));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.appStartLanguageEvent, parameters: {
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.languageSelectedKey: languageSelected,
    });
  }

  void trackBooleanToggleClicks(String userId, String timestamp, bool value, String toggleName, String pageName) {
    segment.track(TrackingConstants.booleanToggleClicksEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.valueKey: value.toString(),
      TrackingConstants.toggleNameKey: toggleName,
      TrackingConstants.pageNameKey: pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.booleanToggleClicksEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.valueKey, value.toString())
          ..addCustomData(TrackingConstants.toggleNameKey, toggleName)
          ..addCustomData(TrackingConstants.pageNameKey, pageName));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.booleanToggleClicksEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.valueKey: value.toString(),
      TrackingConstants.toggleNameKey: toggleName,
      TrackingConstants.pageNameKey: pageName,
    });
  }

  void trackSideMenuItemClicked(
      String userId, String timestamp, String sideMenuName, String sideMenuItemClickedName, String pageName) {
    segment.track(TrackingConstants.sideMenuItemClickedEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.sideMenuNameKey: sideMenuName,
      TrackingConstants.sideMenuItemClickedNameKey: sideMenuItemClickedName,
      TrackingConstants.pageNameKey: pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.sideMenuItemClickedEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.sideMenuNameKey, sideMenuName)
          ..addCustomData(TrackingConstants.sideMenuItemClickedNameKey, sideMenuItemClickedName)
          ..addCustomData(TrackingConstants.pageNameKey, pageName));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.sideMenuItemClickedEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.sideMenuNameKey: sideMenuName,
      TrackingConstants.sideMenuItemClickedNameKey: sideMenuItemClickedName,
      TrackingConstants.pageNameKey: pageName,
    });
  }

  void trackCheckBoxItemClicked(String userId, String timestamp, String cbiName, String cbiPageName, bool value) {
    segment.track(TrackingConstants.checkboxItemClickedEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.cbiNameKey: cbiName,
      TrackingConstants.pageNameKey: cbiPageName,
      TrackingConstants.valueKey: value.toString(),
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.checkboxItemClickedEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.cbiNameKey, cbiName)
          ..addCustomData(TrackingConstants.pageNameKey, cbiPageName)
          ..addCustomData(TrackingConstants.valueKey, value.toString()));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.checkboxItemClickedEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.cbiNameKey: cbiName,
      TrackingConstants.pageNameKey: cbiPageName,
      TrackingConstants.valueKey: value.toString(),
    });
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void trackFirstTimeUser(String timestamp) {
    segment.track(TrackingConstants.firstTimeEvent, properties: {
      TrackingConstants.timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.firstTimeEvent)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.firstTimeEvent, parameters: {
      TrackingConstants.timeStampKey: timestamp,
    });
  }

  void trackSignup(String userId, String timestamp) {
    segment.track(TrackingConstants.signUpEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.signUpEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.signUpEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
    });
  }

  void trackLogin(String userId, String timestamp) {
    segment.track(TrackingConstants.loginEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.loginEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.loginEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
    });
  }

  void trackAppOpen(String userId, String timestamp) {
    segment.track(TrackingConstants.appOpenEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.appOpenEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.appOpenEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
    });
  }

  void trackSearch(String userId, String timestamp, String searchQuery,
      {required String queryId, required List<String> objectIDs, required List<int> positions}) {
    segment.track(TrackingConstants.searchEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.searchQueryKey: searchQuery,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.searchEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.searchQueryKey, searchQuery));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.searchEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.searchQueryKey: searchQuery,
    });
    // if (objectIDs.isNotEmpty || positions.isNotEmpty) {
    //   AlgoliaTrackingUtils.trackAlgoliaClickEvent(userId, objectIDs, queryId, positions, TrackingConstants.searchEvent);
    // }
  }

  void trackProductAction(String userId, String timestamp, bool discounted, String chatlistId, String ChatlistName,
      String quantity, String actionType,
      {String? productId}) {
    segment.track(TrackingConstants.productActionEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.discountedKey: discounted.toString(),
      TrackingConstants.chatlistIdKey: chatlistId,
      TrackingConstants.chatlistNameKey: ChatlistName,
      TrackingConstants.quantityKey: quantity,
      TrackingConstants.actionTypeKey: actionType,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.productActionEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.discountedKey, discounted.toString())
          ..addCustomData(TrackingConstants.chatlistIdKey, chatlistId)
          ..addCustomData(TrackingConstants.chatlistNameKey, ChatlistName)
          ..addCustomData(TrackingConstants.quantityKey, quantity)
          ..addCustomData(TrackingConstants.actionTypeKey, actionType));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.productActionEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.discountedKey: discounted.toString(),
      TrackingConstants.chatlistIdKey: chatlistId,
      TrackingConstants.chatlistNameKey: ChatlistName,
      TrackingConstants.quantityKey: quantity,
      TrackingConstants.actionTypeKey: actionType,
    });
    // AlgoliaTrackingUtils.trackAlgoliaConversionEvent(userId, productId, TrackingConstants.productActionEvent);
  }

  void trackShareProduct(
      String userId, String timestamp, String productId, String productName, String productCategory) {
    segment.track(TrackingConstants.shareProductEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.productIdKey: productId,
      TrackingConstants.productNameKey: productName,
      TrackingConstants.productCategoryKey: productCategory,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.shareProductEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.productIdKey, productId)
          ..addCustomData(TrackingConstants.productNameKey, productName)
          ..addCustomData(TrackingConstants.productCategoryKey, productCategory));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.shareProductEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.productIdKey: productId,
      TrackingConstants.productNameKey: productName,
      TrackingConstants.productCategoryKey: productCategory,
    });
  }

  void trackPhoneNumberVerified(String userId, String timestamp, bool status) {
    var verificationStatus = status ? "success" : "fail";
    segment.track(TrackingConstants.phoneNumberVerifiedEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.statusKey: verificationStatus,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.phoneNumberVerifiedEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.statusKey, verificationStatus));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.phoneNumberVerifiedEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.statusKey: verificationStatus,
    });
  }

  void trackChatlistMessageSent(
      String userId, String timestamp, String messageText, String chatlistId, String chatlistName) {
    segment.track(TrackingConstants.chatlistMessageSentEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.messageTextKey: messageText,
      TrackingConstants.chatlistIdKey: chatlistId,
      TrackingConstants.chatlistNameKey: chatlistName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.chatlistMessageSentEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.messageTextKey, messageText)
          ..addCustomData(TrackingConstants.chatlistIdKey, chatlistId)
          ..addCustomData(TrackingConstants.chatlistNameKey, chatlistName));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.chatlistMessageSentEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.messageTextKey: messageText,
      TrackingConstants.chatlistIdKey: chatlistId,
      TrackingConstants.chatlistNameKey: chatlistName,
    });
  }

  void trackFilterUsed(String userId, String timestamp, String pageName, String filterType) {
    segment.track(TrackingConstants.filterUsedEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.filterTypeKey: filterType,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.filterUsedEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.pageNameKey, pageName)
          ..addCustomData(TrackingConstants.filterTypeKey, filterType));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.filterUsedEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.filterTypeKey: filterType,
    });
  }

  void trackFormSubmitted(String userId, String timestamp, String pageName) {
    segment.track(TrackingConstants.formSubmittedEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.formSubmittedEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.pageNameKey, pageName));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.formSubmittedEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
    });
  }

  void trackFavouriteStores(String userId, String timestamp, String pageName, String favouriteStore) {
    segment.track(TrackingConstants.chooseFavouriteStoreEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.favouriteStoreKey: favouriteStore,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.chooseFavouriteStoreEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.pageNameKey, pageName)
          ..addCustomData(TrackingConstants.favouriteStoreKey, favouriteStore));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.chooseFavouriteStoreEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.favouriteStoreKey: favouriteStore,
    });
  }

  void trackSubscriptionAction(String userId, String timestamp, String pageName, String plan, String price) {
    segment.track(TrackingConstants.subscriptionEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.subscriptionPlanKey: plan,
      TrackingConstants.subscriptionPriceKey: price,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.subscriptionEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.pageNameKey, pageName)
          ..addCustomData(TrackingConstants.subscriptionPlanKey, plan)
          ..addCustomData(TrackingConstants.subscriptionPriceKey, price));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.subscriptionEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.subscriptionPlanKey: plan,
      TrackingConstants.subscriptionPriceKey: price,
    });
  }

  void trackSurveySubmitted(
    String timestamp,
    String pageName,
    String ageRange,
    String gender,
    String groceryTime,
    String groceryMethod,
    String groceryChallenges,
    String discountFindings,
    String groceryAttractions,
    String groceryInterests,
    String groceryConcerns,
    String premiumAppInterest,
    String monthlySubscriptionPrice,
    String monthPayPreference,
  ) {
    segment.track(TrackingConstants.surveyEvent, properties: {
      TrackingConstants.surveyAgeRangeKey: ageRange,
      TrackingConstants.surveyGenderKey: gender,
      TrackingConstants.surveyGroceryTimeKey: groceryTime,
      TrackingConstants.surveyGroceryMethodKey: groceryMethod,
      TrackingConstants.surveyGroceryChallengesKey: groceryChallenges,
      TrackingConstants.surveyDiscountFindingsKey: discountFindings,
      TrackingConstants.surveyGroceryAttractionsKey: groceryAttractions,
      TrackingConstants.surveyGroceryInterestsKey: groceryInterests,
      TrackingConstants.surveyGroceryConcernsKey: groceryConcerns,
      TrackingConstants.surveyPremiumAppInterestKey: premiumAppInterest,
      TrackingConstants.surveyMonthlySubscriptionPriceKey: monthlySubscriptionPrice,
      TrackingConstants.surveyMonthPayPreferenceKey: monthPayPreference,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.surveyEvent)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.pageNameKey, pageName)
          ..addCustomData(TrackingConstants.surveyAgeRangeKey, ageRange)
          ..addCustomData(TrackingConstants.surveyGenderKey, gender)
          ..addCustomData(TrackingConstants.surveyGroceryTimeKey, groceryTime)
          ..addCustomData(TrackingConstants.surveyGroceryMethodKey, groceryMethod)
          ..addCustomData(TrackingConstants.surveyGroceryChallengesKey, groceryChallenges)
          ..addCustomData(TrackingConstants.surveyDiscountFindingsKey, discountFindings)
          ..addCustomData(TrackingConstants.surveyGroceryInterestsKey, groceryInterests)
          ..addCustomData(TrackingConstants.surveyGroceryConcernsKey, groceryConcerns)
          ..addCustomData(TrackingConstants.surveyPremiumAppInterestKey, premiumAppInterest)
          ..addCustomData(TrackingConstants.surveyMonthlySubscriptionPriceKey, monthlySubscriptionPrice)
          ..addCustomData(TrackingConstants.surveyMonthPayPreferenceKey, monthPayPreference));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.surveyEvent, parameters: {
      TrackingConstants.surveyAgeRangeKey: ageRange,
      TrackingConstants.surveyGenderKey: gender,
      TrackingConstants.surveyGroceryTimeKey: groceryTime,
      TrackingConstants.surveyGroceryMethodKey: groceryMethod,
      TrackingConstants.surveyGroceryChallengesKey: groceryChallenges,
      TrackingConstants.surveyDiscountFindingsKey: discountFindings,
      TrackingConstants.surveyGroceryAttractionsKey: groceryAttractions,
      TrackingConstants.surveyGroceryInterestsKey: groceryInterests,
      TrackingConstants.surveyGroceryConcernsKey: groceryConcerns,
      TrackingConstants.surveyPremiumAppInterestKey: premiumAppInterest,
      TrackingConstants.surveyMonthlySubscriptionPriceKey: monthlySubscriptionPrice,
      TrackingConstants.surveyMonthPayPreferenceKey: monthPayPreference,
    });
  }

  void trackSurveyStarted(String userId, String timestamp, String pageName) {
    segment.track(TrackingConstants.surveyStartedEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.surveyStartedEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.pageNameKey, pageName));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.surveyStartedEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
    });
  }

  void trackSurveySkipped(String userId, String timestamp, String pageName) {
    segment.track(TrackingConstants.surveySkippedEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(TrackingConstants.surveySkippedEvent)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.pageNameKey, pageName));
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.surveySkippedEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
    });
  }

  void trackSurveyAction(
      String eventName, String userId, String timestamp, String pageName, String buttonName, String questionText) {
    segment.track(eventName, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.buttonNameKey: buttonName,
      TrackingConstants.questionKey: questionText,
    });
    FlutterBranchSdk.trackContentWithoutBuo(
        branchEvent: BranchEvent.customEvent(eventName)
          ..addCustomData(TrackingConstants.userIdKey, userId)
          ..addCustomData(TrackingConstants.timeStampKey, timestamp)
          ..addCustomData(TrackingConstants.pageNameKey, pageName)
          ..addCustomData(TrackingConstants.buttonNameKey, buttonName)
          ..addCustomData(TrackingConstants.questionKey, questionText));
    eventName = eventName.replaceAll(" ", "_");
    questionText = questionText.replaceAll(" ", "_");
    buttonName = buttonName.replaceAll(" ", "_");
    pageName = pageName.replaceAll(" ", "_");
    timestamp = timestamp.replaceAll(" ", "_");
    log("EVENT NAME: $eventName");
    log("Question Text: $questionText");
    log("Button name: $buttonName");
    log("page name: $pageName");
    log("timestamp: $timestamp");

    FirebaseAnalytics.instance.logEvent(name: "survey_action", parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.buttonNameKey: buttonName,
      TrackingConstants.questionKey: questionText,
    }).then((value) {
      log("FIREBASE EVENT: track survey action logged");
    });
  }
}
