import 'package:bargainb/providers/subscription_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/purchase_service.dart';
import '../../utils/tracking_utils.dart';
import '../../view/screens/main_screen.dart';
import '../../view/widgets/signin_dialog.dart';
import '../../view/widgets/subscribe_dialog.dart';

class AppNavigator {
  static Future<void> push(
      {required BuildContext context, required Widget screen}) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => screen, settings: RouteSettings(name: screen.toString())));
  }
  static Future<void> pushReplacement(
      {required BuildContext context, required Widget screen}) async {
    await Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  static dynamic pop({required BuildContext context, dynamic object}) {
    return Navigator.of(context).pop<dynamic>(object);
  }

  static dynamic popToFrist({required BuildContext context}) {
    return Navigator.of(context).popUntil((rout) => rout.isFirst);
  }

  static dynamic pushToFrist(
      {required BuildContext context, required Widget screen}) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen), (route) => false);
  }

  static showFeatureBlockedDialog(BuildContext context){
    if (FirebaseAuth.instance.currentUser == null) {
      showSignInDialog(context);
    } else if (!SubscriptionProvider.get(context).isSubscribed) {
      showSubscribeDialog(context);
    }
  }

  static goToChatlistTab(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      showSignInDialog(context);
    } else if (!SubscriptionProvider.get(context).isSubscribed) {
      showSubscribeDialog(context);
    } else {
      NavigatorController.jumpToTab(1);
      trackOpenChatlists();
    }
  }

  static goToProfileTab(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      showSignInDialog(context);
    } else if (!SubscriptionProvider.get(context).isSubscribed) {
      showSubscribeDialog(context);
    } else {
      NavigatorController.jumpToTab(2);
      trackOpenProfile();
    }
  }

  static trackOpenProfile() {
    try {
      TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "open profile screen",
          DateTime.now().toUtc().toString(), "Home screen");
    } catch (e) {
      print(e);
      TrackingUtils()
          .trackButtonClick("Guest", "open profile screen", DateTime.now().toUtc().toString(), "Home screen");
    }
  }

  static showSignInDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => const SigninDialog(
          body: 'You have to be signed in to use this feature.',
          buttonText: 'Sign in',
          title: 'Sign In',
        ));
  }

  static showSubscribeDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => SubscribeDialog(
          body: 'You have to be subscribed to plan to use this premium feature.'.tr(),
          buttonText: 'Upgrade',
          title: 'Subscribe',
        ));
  }

  static trackOpenChatlists() {
    try {
      TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "open Chatlists screen",
          DateTime.now().toUtc().toString(), "Home screen");
    } catch (e) {
      print(e);
      TrackingUtils()
          .trackButtonClick("Guest", "open Chatlists screen", DateTime.now().toUtc().toString(), "Home screen");
    }
  }
}
