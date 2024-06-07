import 'dart:developer';

import 'package:bargainb/utils/algolia_tracking_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import '../core/utils/tracking_constants.dart';

class TrackingUtils {
  Mixpanel mixpanel = Mixpanel('3aa827fb2f1cdf5ff2393b84d9c40bac');

  void trackButtonClick(String userId, String buttonName, String timestamp, String pageName){
    mixpanel.track(TrackingConstants.buttonClickEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.buttonNameKey: buttonName,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.buttonClickEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData(TrackingConstants.buttonNameKey, buttonName)
        ..addCustomData( TrackingConstants.pageNameKey, pageName)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
    );
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.buttonClickEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.buttonNameKey: buttonName,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.timeStampKey: timestamp,
    });
  }

  void trackPageView(String userId, String timestamp, String pageName){
    mixpanel.track(TrackingConstants.pageViewEvent, properties: {
      TrackingConstants.userIdKey: userId,
       TrackingConstants.pageNameKey: pageName,
       TrackingConstants.timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.pageViewEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
      ..addCustomData(TrackingConstants.pageNameKey, pageName)
      ..addCustomData(TrackingConstants.timeStampKey, timestamp)
    );
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.pageViewEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.pageNameKey: pageName,
      TrackingConstants.timeStampKey: timestamp,
    });
  }

  void trackPopPageView(String userId, String timestamp, String popUpName){
    mixpanel.track(TrackingConstants.popPageViewEvent, properties: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.popUpNameKey: popUpName,
       TrackingConstants.timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.popPageViewEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
      ..addCustomData(TrackingConstants.popUpNameKey, popUpName)
      ..addCustomData( TrackingConstants.timeStampKey, timestamp)
    );
    FirebaseAnalytics.instance.logEvent(name: TrackingConstants.popPageViewEvent, parameters: {
      TrackingConstants.userIdKey: userId,
      TrackingConstants.popUpNameKey: popUpName,
      TrackingConstants.timeStampKey: timestamp,
    });
  }

  void trackTextLinkClicked(String userId, String timestamp, String pageName, String textLinkName){
    mixpanel.track(TrackingConstants.textLinkClickedEvent, properties: {
      TrackingConstants.userIdKey: userId,
       TrackingConstants.pageNameKey: pageName,
       TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.textLinkNameKey: textLinkName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.textLinkClickedEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
      ..addCustomData( TrackingConstants.pageNameKey, pageName)
      ..addCustomData( TrackingConstants.timeStampKey, timestamp)
      ..addCustomData(TrackingConstants.textLinkNameKey, textLinkName)
    );
  }

  void trackLanguageSelected(String userId, String timestamp, String languageSelected){
    mixpanel.track(TrackingConstants.languageSelectedEvent, properties: {
      TrackingConstants.userIdKey: userId,
       TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.languageSelectedKey: languageSelected,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.languageSelectedEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
      ..addCustomData( TrackingConstants.timeStampKey, timestamp)
      ..addCustomData(TrackingConstants.languageSelectedKey, languageSelected)
    );
  }

  void trackAppStartLanguage(String timestamp, String languageSelected){
    mixpanel.track(TrackingConstants.appStartLanguageEvent, properties: {
       TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.languageSelectedKey: languageSelected,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.appStartLanguageEvent)
      ..addCustomData( TrackingConstants.timeStampKey, timestamp)
      ..addCustomData(TrackingConstants.languageSelectedKey, languageSelected)
    );
  }

  void trackBooleanToggleClicks(String userId, String timestamp, bool value, String toggleName, String pageName){
    mixpanel.track(TrackingConstants.booleanToggleClicksEvent, properties: {
      TrackingConstants.userIdKey: userId,
       TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.valueKey: value.toString(),
      TrackingConstants.toggleNameKey: toggleName,
       TrackingConstants.pageNameKey: pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.booleanToggleClicksEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
      ..addCustomData( TrackingConstants.timeStampKey, timestamp)
      ..addCustomData(TrackingConstants.valueKey, value.toString())
      ..addCustomData(TrackingConstants.toggleNameKey, toggleName)
      ..addCustomData( TrackingConstants.pageNameKey, pageName)
    );
  }

  void trackSideMenuItemClicked(String userId, String timestamp, String sideMenuName, String sideMenuItemClickedName, String pageName){
    mixpanel.track(TrackingConstants.sideMenuItemClickedEvent, properties: {
      TrackingConstants.userIdKey: userId,
       TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.sideMenuNameKey: sideMenuName,
      TrackingConstants.sideMenuItemClickedEvent: sideMenuItemClickedName,
       TrackingConstants.pageNameKey: pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.sideMenuItemClickedEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
      ..addCustomData( TrackingConstants.timeStampKey, timestamp)
      ..addCustomData(TrackingConstants.sideMenuNameKey, sideMenuName)
      ..addCustomData(TrackingConstants.sideMenuItemClickedEvent, sideMenuItemClickedName)
      ..addCustomData( TrackingConstants.pageNameKey, pageName)
    );
  }

  void trackCheckBoxItemClicked(String userId, String timestamp, String cbiName, String cbiPageName, bool value){
    mixpanel.track(TrackingConstants.checkboxItemClickedEvent, properties: {
      TrackingConstants.userIdKey: userId,
       TrackingConstants.timeStampKey: timestamp,
      TrackingConstants.cbiNameKey: cbiName,
       TrackingConstants.pageNameKey: cbiPageName,
      TrackingConstants.valueKey: value.toString(),
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.checkboxItemClickedEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
      ..addCustomData( TrackingConstants.timeStampKey, timestamp)
      ..addCustomData(TrackingConstants.cbiNameKey, cbiName)
      ..addCustomData(TrackingConstants.pageNameKey, cbiPageName)
      ..addCustomData(TrackingConstants.valueKey, value.toString())
    );
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void trackFirstTimeUser(String timestamp){
    mixpanel.track(TrackingConstants.firstTimeEvent, properties: {
       TrackingConstants.timeStampKey : timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.firstTimeEvent)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
    );
  }

  void trackSignup(String userId, String timestamp){
    mixpanel.track(TrackingConstants.signUpEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.signUpEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
    );
  }

  void trackLogin(String userId, String timestamp){
    mixpanel.track(TrackingConstants.loginEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.loginEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
    );
  }

  void trackAppOpen(String userId, String timestamp){
    mixpanel.track(TrackingConstants.appOpenEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.appOpenEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
    );
  }

  void trackSearch(String userId, String timestamp, String searchQuery, {required String queryId, required List<String> objectIDs, required List<int> positions}){
    mixpanel.track(TrackingConstants.searchEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
      TrackingConstants.searchQueryKey : searchQuery,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.searchEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
        ..addCustomData(TrackingConstants.searchQueryKey, searchQuery)
    );
    if(objectIDs.isNotEmpty || positions.isNotEmpty) {
      AlgoliaTrackingUtils.trackAlgoliaClickEvent(userId, objectIDs, queryId, positions, TrackingConstants.searchEvent);
    }
  }


  void trackProductAction(String userId, String timestamp, bool discounted, String chatlistId, String ChatlistName, String quantity, String actionType, {String? productId}){
    mixpanel.track(TrackingConstants.productActionEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
      TrackingConstants.discountedKey : discounted.toString(),
      TrackingConstants.chatlistIdKey : chatlistId,
      TrackingConstants.chatlistNameKey : ChatlistName,
      TrackingConstants.quantityKey : quantity,
      TrackingConstants.actionTypeKey : actionType,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.productActionEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
        ..addCustomData(TrackingConstants.discountedKey, discounted.toString())
        ..addCustomData(TrackingConstants.chatlistIdKey, chatlistId)
        ..addCustomData(TrackingConstants.chatlistNameKey, ChatlistName)
        ..addCustomData(TrackingConstants.quantityKey, quantity)
        ..addCustomData(TrackingConstants.actionTypeKey, actionType)
    );
    AlgoliaTrackingUtils.trackAlgoliaConversionEvent(userId, productId, TrackingConstants.productActionEvent);
  }

  void trackShareProduct(String userId, String timestamp, String productId, String productName, String productCategory){
    mixpanel.track(TrackingConstants.shareProductEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
      TrackingConstants.productIdKey : productId,
      TrackingConstants.productNameKey : productName,
      TrackingConstants. productCategoryKey : productCategory,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.shareProductEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
        ..addCustomData(TrackingConstants.productIdKey, productId)
        ..addCustomData(TrackingConstants.productNameKey, productName)
        ..addCustomData(TrackingConstants.productCategoryKey, productCategory)
    );
  }

  void trackPhoneNumberVerified(String userId, String timestamp, bool status){
    var verificationStatus =  status ? "success" : "fail";
    mixpanel.track(TrackingConstants.phoneNumberVerifiedEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
      TrackingConstants.statusKey : verificationStatus,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.phoneNumberVerifiedEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
        ..addCustomData(TrackingConstants.statusKey, verificationStatus)
    );
  }

  void trackChatlistMessageSent(String userId, String timestamp, String messageText, String chatlistId, String chatlistName){
    mixpanel.track(TrackingConstants.chatlistMessageSentEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
      TrackingConstants.messageTextKey : messageText,
      TrackingConstants.chatlistIdKey : chatlistId,
      TrackingConstants. chatlistNameKey : chatlistName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.chatlistMessageSentEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
        ..addCustomData(TrackingConstants.messageTextKey, messageText)
        ..addCustomData(TrackingConstants.chatlistIdKey, chatlistId)
        ..addCustomData(TrackingConstants.chatlistNameKey, chatlistName)
    );
  }

  void trackFilterUsed(String userId, String timestamp, String pageName, String filterType){
    mixpanel.track(TrackingConstants.filterUsedEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
       TrackingConstants.pageNameKey : pageName,
      TrackingConstants.filterTypeKey : filterType,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.filterUsedEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
        ..addCustomData( TrackingConstants.pageNameKey, pageName)
        ..addCustomData(TrackingConstants.filterTypeKey, filterType)
    );
  }

  void trackFormSubmitted(String userId, String timestamp, String pageName){
    mixpanel.track(TrackingConstants.formSubmittedEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
       TrackingConstants.pageNameKey : pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.formSubmittedEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
        ..addCustomData( TrackingConstants.pageNameKey, pageName)
    );
  }

  void trackFavouriteStores(String userId, String timestamp, String pageName, String favouriteStore){
    mixpanel.track(TrackingConstants.chooseFavouriteStoreEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
       TrackingConstants.pageNameKey : pageName,
      TrackingConstants.favouriteStoreKey : favouriteStore,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.chooseFavouriteStoreEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
        ..addCustomData( TrackingConstants.pageNameKey, pageName)
        ..addCustomData(TrackingConstants.favouriteStoreKey, favouriteStore)
    );
  }

  void trackSubscriptionAction(String userId, String timestamp, String pageName, String plan, String price){
    mixpanel.track(TrackingConstants.subscriptionEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
       TrackingConstants.pageNameKey : pageName,
      TrackingConstants.subscriptionPlanKey : plan,
      TrackingConstants. subscriptionPriceKey : price,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.subscriptionEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
        ..addCustomData( TrackingConstants.pageNameKey, pageName)
        ..addCustomData(TrackingConstants.subscriptionPlanKey, plan)
        ..addCustomData(TrackingConstants.subscriptionPriceKey, price)
    );
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
      ){
    mixpanel.track(TrackingConstants.surveyEvent, properties: {
      TrackingConstants.surveyAgeRangeKey : ageRange,
      TrackingConstants.surveyGenderKey : gender,
       TrackingConstants.surveyGroceryTimeKey : groceryTime,
      TrackingConstants.surveyGroceryMethodKey : groceryMethod,
      TrackingConstants.surveyGroceryChallengesKey : groceryChallenges,
      TrackingConstants.surveyDiscountFindingsKey : discountFindings,
      TrackingConstants.surveyGroceryAttractionsKey : groceryAttractions,
      TrackingConstants.surveyGroceryInterestsKey : groceryInterests,
      TrackingConstants.      surveyGroceryConcernsKey : groceryConcerns,
      TrackingConstants.surveyPremiumAppInterestKey : premiumAppInterest,
      TrackingConstants.surveyMonthlySubscriptionPriceKey : monthlySubscriptionPrice,
      TrackingConstants.surveyMonthPayPreferenceKey : monthPayPreference,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.surveyEvent)
        ..addCustomData( TrackingConstants.timeStampKey, timestamp)
        ..addCustomData( TrackingConstants.pageNameKey, pageName)
        ..addCustomData(TrackingConstants.surveyAgeRangeKey, ageRange)
        ..addCustomData(TrackingConstants.surveyGenderKey, gender)
        ..addCustomData( TrackingConstants.surveyGroceryTimeKey, groceryTime)
        ..addCustomData(TrackingConstants.surveyGroceryMethodKey, groceryMethod)
        ..addCustomData(TrackingConstants.surveyGroceryChallengesKey, groceryChallenges)
        ..addCustomData(TrackingConstants.surveyDiscountFindingsKey, discountFindings)
        ..addCustomData(TrackingConstants.surveyGroceryInterestsKey, groceryInterests)
        ..addCustomData(TrackingConstants.surveyGroceryConcernsKey, groceryConcerns)
        ..addCustomData(TrackingConstants.surveyPremiumAppInterestKey, premiumAppInterest)
        ..addCustomData(TrackingConstants.surveyMonthlySubscriptionPriceKey, monthlySubscriptionPrice)
        ..addCustomData(TrackingConstants.surveyMonthPayPreferenceKey, monthPayPreference)
    );
  }

  void trackSurveyStarted(String userId, String timestamp, String pageName){
    mixpanel.track(TrackingConstants.surveyStartedEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
       TrackingConstants.pageNameKey : pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.surveyStartedEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
      ..addCustomData( TrackingConstants.timeStampKey, timestamp)
      ..addCustomData( TrackingConstants.pageNameKey, pageName)
    );
  }

  void trackSurveySkipped(String userId, String timestamp, String pageName){
    mixpanel.track(TrackingConstants.surveySkippedEvent, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
       TrackingConstants.pageNameKey : pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(TrackingConstants.surveySkippedEvent)
      ..addCustomData(TrackingConstants.userIdKey, userId)
      ..addCustomData( TrackingConstants.timeStampKey, timestamp)
      ..addCustomData( TrackingConstants.pageNameKey, pageName)
    );
  }


  void trackSurveyAction(String eventName, String userId, String timestamp, String pageName, String buttonName, String questionText){
    mixpanel.track(eventName, properties: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
       TrackingConstants.pageNameKey : pageName,
      TrackingConstants.buttonNameKey : buttonName,
      TrackingConstants.questionKey : questionText,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(eventName)
      ..addCustomData(TrackingConstants.userIdKey, userId)
      ..addCustomData( TrackingConstants.timeStampKey, timestamp)
      ..addCustomData( TrackingConstants.pageNameKey, pageName)
      ..addCustomData(TrackingConstants.buttonNameKey, buttonName)
      ..addCustomData(TrackingConstants.questionKey, questionText)
    );
    FirebaseAnalytics.instance.isSupported().then((value) => log("IS FIREBASE SUPPROTED: $value"));
    FirebaseAnalytics.instance.logLevelStart(levelName: "TEST LEVEL");
    eventName = "survey_action";
    FirebaseAnalytics.instance.logEvent(name: eventName, parameters: {
      TrackingConstants.userIdKey : userId,
       TrackingConstants.timeStampKey : timestamp,
       TrackingConstants.pageNameKey : pageName,
      TrackingConstants.buttonNameKey : buttonName,
      TrackingConstants.questionKey : questionText,
    }).then((value) {
      log("FIREBASE EVENT: track survey action logged");
    });
  }
}

