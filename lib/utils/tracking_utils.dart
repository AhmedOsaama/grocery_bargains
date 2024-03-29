import 'package:bargainb/utils/algolia_tracking_utils.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class TrackingUtils {
  static const userIdKey = 'UserID';
  static const buttonNameKey = 'ButtonName';
  static const pageNameKey = 'PageName';
  static const popUpNameKey = 'PopUpName';
  static const textLinkNameKey = 'TextLinkName';
  static const languageSelectedKey = 'LanguageSelected';
  static const toggleNameKey = 'ToggleName';
  static const valueKey = 'value';
  static const sideMenuNameKey = 'SideMenuName';
  static const sideMenuItemClickedNameKey = 'SideMenuItemClickedName';
  static const cbiNameKey = 'CBIName';
  static const cbiPageNameKey = 'CBIPageName';
  static const timeStampKey = 'Time';
  static const errorMessageKey = 'Error Message';
  static const searchQueryKey = 'SearchQuery';
  static const productNameKey = 'ProductName';
  static const discountedKey = 'Discounted';
  static const chatlistHostIdKey = 'ChatlistHostID';
  static const chatlistHostNameKey = 'ChatlistHostName';
  static const quantityKey = 'Quantity';
  static const actionTypeKey = 'ActionType';
  static const productIdKey = 'ProductID';
  static const productCategoryKey = 'ProductCategory';
  static const statusKey = 'Status';
  static const messageTextKey = 'MessageText';
  static const chatlistIdKey = 'ChatlistID';
  static const chatlistNameKey = 'ChatlistName';
  static const filterTypeKey = 'Filter type';
  static const favouriteStoreKey = 'Favourite store';
  static const subscriptionPlanKey = 'Subscription plan';
  static const subscriptionPriceKey = 'Subscription price';

  static const surveyAgeRangeKey = "Survey Age Range";
  static const surveyGenderKey = "Survey Gender";
  static const surveyGroceryTimeKey = "Survey Grocery Time";

  static const surveyGroceryMethodKey = "Survey Grocery Method";
  static const surveyGroceryChallengesKey = "Survey Grocery Challenge";
  static const surveyDiscountFindingsKey = "Survey Discount Findings";

  static const surveyGroceryAttractionsKey = "Survey Grocery Attractions";
  static const surveyGroceryInterestsKey = "Survey Grocery Interests";
  static const surveyGroceryConcernsKey = "Survey Grocery Concerns";

  static const surveyPremiumAppInterestKey = "Survey Premium App Interest";
  static const surveyMonthlySubscriptionPriceKey = "Survey Monthly subscription Price";
  static const surveyMonthPayPreferenceKey = "Survey Month Pay Preference";

  static const buttonClickEvent = 'ButtonClick';
  static const pageViewEvent = 'PageView';
  static const popPageViewEvent = 'PopPageView';
  static const textLinkClickedEvent = 'TextLink Clicked';
  static const languageSelectedEvent = 'Language Selected';
  static const appStartLanguageEvent = 'App Start Language';
  static const booleanToggleClicksEvent = 'Boolean Toggle Clicks';
  static const sideMenuItemClickedEvent = 'SideMenuItemClicked';
  static const checkboxItemClickedEvent = 'CheckboxItemClicked';
  static const signUpEvent = 'Signup';
  static const loginEvent = 'Login';
  static const appOpenEvent = 'AppOpen';
  static const searchEvent = 'Search';
  static const productActionEvent = 'Product Action';
  static const shareProductEvent = 'ShareProduct';
  static const phoneNumberVerifiedEvent = 'PhoneNumberVerified';
  static const chatlistMessageSentEvent = 'CLMessageSent';
  static const filterUsedEvent = 'FilterUsed';
  static const formSubmittedEvent = 'FormSubmitted';
  static const chooseFavouriteStoreEvent = 'chooseFavouriteStore';
  static const subscriptionEvent = 'subscription_Successful';
  static const firstTimeEvent = 'firstTime_User';
  static const surveyEvent = 'SurveySubmitted';
  static const surveyStartedEvent = 'SurveyStarted';
  static const surveySkippedEvent = 'SurveySkipped';



  Mixpanel mixpanel = Mixpanel('3aa827fb2f1cdf5ff2393b84d9c40bac');

  void trackButtonClick(String userId, String buttonName, String timestamp, String pageName){
    mixpanel.track(buttonClickEvent, properties: {
      userIdKey: userId,
      buttonNameKey: buttonName,
      pageNameKey: pageName,
      timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(buttonClickEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(buttonNameKey, buttonName)
        ..addCustomData(pageNameKey, pageName)
        ..addCustomData(timeStampKey, timestamp)
    );
  }

  void trackPageView(String userId, String timestamp, String pageName){
    mixpanel.track(pageViewEvent, properties: {
      userIdKey: userId,
      pageNameKey: pageName,
      timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(pageViewEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData(pageNameKey, pageName)
      ..addCustomData(timeStampKey, timestamp)
    );
  }

  void trackPopPageView(String userId, String timestamp, String popUpName){
    mixpanel.track(popPageViewEvent, properties: {
      userIdKey: userId,
      popUpNameKey: popUpName,
      timeStampKey: timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(popPageViewEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData(popUpNameKey, popUpName)
      ..addCustomData(timeStampKey, timestamp)
    );
  }

  void trackTextLinkClicked(String userId, String timestamp, String pageName, String textLinkName){
    mixpanel.track(textLinkClickedEvent, properties: {
      userIdKey: userId,
      pageNameKey: pageName,
      timeStampKey: timestamp,
      textLinkNameKey: textLinkName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(textLinkClickedEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData(pageNameKey, pageName)
      ..addCustomData(timeStampKey, timestamp)
      ..addCustomData(textLinkNameKey, textLinkName)
    );
  }

  void trackLanguageSelected(String userId, String timestamp, String languageSelected){
    mixpanel.track(languageSelectedEvent, properties: {
      userIdKey: userId,
      timeStampKey: timestamp,
      languageSelectedKey: languageSelected,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(languageSelectedEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData(timeStampKey, timestamp)
      ..addCustomData(languageSelectedKey, languageSelected)
    );
  }

  void trackAppStartLanguage(String timestamp, String languageSelected){
    mixpanel.track(appStartLanguageEvent, properties: {
      timeStampKey: timestamp,
      languageSelectedKey: languageSelected,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(appStartLanguageEvent)
      ..addCustomData(timeStampKey, timestamp)
      ..addCustomData(languageSelectedKey, languageSelected)
    );
  }

  void trackBooleanToggleClicks(String userId, String timestamp, bool value, String toggleName, String pageName){
    mixpanel.track(booleanToggleClicksEvent, properties: {
      userIdKey: userId,
      timeStampKey: timestamp,
      valueKey: value.toString(),
      toggleNameKey: toggleName,
      pageNameKey: pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(booleanToggleClicksEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData(timeStampKey, timestamp)
      ..addCustomData(valueKey, value.toString())
      ..addCustomData(toggleNameKey, toggleName)
      ..addCustomData(pageNameKey, pageName)
    );
  }

  void trackSideMenuItemClicked(String userId, String timestamp, String sideMenuName, String sideMenuItemClickedName, String pageName){
    mixpanel.track(sideMenuItemClickedEvent, properties: {
      userIdKey: userId,
      timeStampKey: timestamp,
      sideMenuNameKey: sideMenuName,
      sideMenuItemClickedEvent: sideMenuItemClickedName,
      pageNameKey: pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(sideMenuItemClickedEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData(timeStampKey, timestamp)
      ..addCustomData(sideMenuNameKey, sideMenuName)
      ..addCustomData(sideMenuItemClickedEvent, sideMenuItemClickedName)
      ..addCustomData(pageNameKey, pageName)
    );
  }

  void trackCheckBoxItemClicked(String userId, String timestamp, String cbiName, String cbiPageName, bool value){
    mixpanel.track(checkboxItemClickedEvent, properties: {
      userIdKey: userId,
      timeStampKey: timestamp,
      cbiNameKey: cbiName,
      cbiPageNameKey: cbiPageName,
      valueKey: value.toString(),
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(checkboxItemClickedEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData(timeStampKey, timestamp)
      ..addCustomData(cbiNameKey, cbiName)
      ..addCustomData(cbiPageNameKey, cbiPageName)
      ..addCustomData(valueKey, value.toString())
    );
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void trackFirstTimeUser(String timestamp){
    mixpanel.track(firstTimeEvent, properties: {
      timeStampKey : timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(firstTimeEvent)
        ..addCustomData(timeStampKey, timestamp)
    );
  }

  void trackSignup(String userId, String timestamp){
    mixpanel.track(signUpEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(signUpEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
    );
  }

  void trackLogin(String userId, String timestamp){
    mixpanel.track(loginEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(loginEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
    );
  }

  void trackAppOpen(String userId, String timestamp){
    mixpanel.track(appOpenEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(appOpenEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
    );
  }

  void trackSearch(String userId, String timestamp, String searchQuery, {required String queryId, required List<String> objectIDs, required List<int> positions}){
    mixpanel.track(searchEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
      searchQueryKey : searchQuery,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(searchEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
        ..addCustomData(searchQueryKey, searchQuery)
    );
    if(objectIDs.isNotEmpty || positions.isNotEmpty)
    AlgoliaTrackingUtils.trackAlgoliaClickEvent(userId, objectIDs, queryId, positions, searchEvent);
  }


  void trackProductAction(String userId, String timestamp, bool discounted, String chatlistId, String ChatlistName, String quantity, String actionType, {String? productId}){
    mixpanel.track(productActionEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
      discountedKey : discounted.toString(),
      chatlistIdKey : chatlistId,
      chatlistNameKey : ChatlistName,
      quantityKey : quantity,
      actionTypeKey : actionType,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(productActionEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
        ..addCustomData(discountedKey, discounted.toString())
        ..addCustomData(chatlistIdKey, chatlistId)
        ..addCustomData(chatlistNameKey, ChatlistName)
        ..addCustomData(quantityKey, quantity)
        ..addCustomData(actionTypeKey, actionType)
    );
    AlgoliaTrackingUtils.trackAlgoliaConversionEvent(userId, productId, productActionEvent);
  }

  void trackShareProduct(String userId, String timestamp, String productId, String productName, String productCategory){
    mixpanel.track(shareProductEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
      productIdKey : productId,
      productNameKey : productName,
      productCategoryKey : productCategory,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(shareProductEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
        ..addCustomData(productIdKey, productId)
        ..addCustomData(productNameKey, productName)
        ..addCustomData(productCategoryKey, productCategory)
    );
  }

  void trackPhoneNumberVerified(String userId, String timestamp, bool status){
    var verificationStatus =  status ? "success" : "fail";
    mixpanel.track(phoneNumberVerifiedEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
      statusKey : verificationStatus,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(phoneNumberVerifiedEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
        ..addCustomData(statusKey, verificationStatus)
    );
  }

  void trackChatlistMessageSent(String userId, String timestamp, String messageText, String chatlistId, String chatlistName){
    mixpanel.track(chatlistMessageSentEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
      messageTextKey : messageText,
      chatlistIdKey : chatlistId,
      chatlistNameKey : chatlistName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(chatlistMessageSentEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
        ..addCustomData(messageTextKey, messageText)
        ..addCustomData(chatlistIdKey, chatlistId)
        ..addCustomData(chatlistNameKey, chatlistName)
    );
  }

  void trackFilterUsed(String userId, String timestamp, String pageName, String filterType){
    mixpanel.track(filterUsedEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
      pageNameKey : pageName,
      filterTypeKey : filterType,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(filterUsedEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
        ..addCustomData(pageNameKey, pageName)
        ..addCustomData(filterTypeKey, filterType)
    );
  }

  void trackFormSubmitted(String userId, String timestamp, String pageName){
    mixpanel.track(formSubmittedEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
      pageNameKey : pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(formSubmittedEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
        ..addCustomData(pageNameKey, pageName)
    );
  }

  void trackFavouriteStores(String userId, String timestamp, String pageName, String favouriteStore){
    mixpanel.track(chooseFavouriteStoreEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
      pageNameKey : pageName,
      favouriteStoreKey : favouriteStore,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(chooseFavouriteStoreEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
        ..addCustomData(pageNameKey, pageName)
        ..addCustomData(favouriteStoreKey, favouriteStore)
    );
  }

  void trackSubscriptionAction(String userId, String timestamp, String pageName, String plan, String price){
    mixpanel.track(subscriptionEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
      pageNameKey : pageName,
      subscriptionPlanKey : plan,
      subscriptionPriceKey : price,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(subscriptionEvent)
      ..addCustomData(userIdKey, userId)
        ..addCustomData(timeStampKey, timestamp)
        ..addCustomData(pageNameKey, pageName)
        ..addCustomData(subscriptionPlanKey, plan)
        ..addCustomData(subscriptionPriceKey, price)
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
    mixpanel.track(surveyEvent, properties: {
      surveyAgeRangeKey : ageRange,
      surveyGenderKey : gender,
      surveyGroceryTimeKey : groceryTime,
      surveyGroceryMethodKey : groceryMethod,
      surveyGroceryChallengesKey : groceryChallenges,
      surveyDiscountFindingsKey : discountFindings,
      surveyGroceryAttractionsKey : groceryAttractions,
      surveyGroceryInterestsKey : groceryInterests,
      surveyGroceryConcernsKey : groceryConcerns,
      surveyPremiumAppInterestKey : premiumAppInterest,
      surveyMonthlySubscriptionPriceKey : monthlySubscriptionPrice,
      surveyMonthPayPreferenceKey : monthPayPreference,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(surveyEvent)
        ..addCustomData(timeStampKey, timestamp)
        ..addCustomData(pageNameKey, pageName)
        ..addCustomData(surveyAgeRangeKey, ageRange)
        ..addCustomData(surveyGenderKey, gender)
        ..addCustomData(surveyGroceryTimeKey, groceryTime)
        ..addCustomData(surveyGroceryMethodKey, groceryMethod)
        ..addCustomData(surveyGroceryChallengesKey, groceryChallenges)
        ..addCustomData(surveyDiscountFindingsKey, discountFindings)
        ..addCustomData(surveyGroceryInterestsKey, groceryInterests)
        ..addCustomData(surveyGroceryConcernsKey, groceryConcerns)
        ..addCustomData(surveyPremiumAppInterestKey, premiumAppInterest)
        ..addCustomData(surveyMonthlySubscriptionPriceKey, monthlySubscriptionPrice)
        ..addCustomData(surveyMonthPayPreferenceKey, monthPayPreference)
    );
  }

  void trackSurveyStarted(String userId, String timestamp, String pageName){
    mixpanel.track(surveyStartedEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
      pageNameKey : pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(surveyStartedEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData(timeStampKey, timestamp)
      ..addCustomData(pageNameKey, pageName)
    );
  }

  void trackSurveySkipped(String userId, String timestamp, String pageName){
    mixpanel.track(surveySkippedEvent, properties: {
      userIdKey : userId,
      timeStampKey : timestamp,
      pageNameKey : pageName,
    });
    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: BranchEvent.customEvent(surveySkippedEvent)
      ..addCustomData(userIdKey, userId)
      ..addCustomData(timeStampKey, timestamp)
      ..addCustomData(pageNameKey, pageName)
    );
  }
}

