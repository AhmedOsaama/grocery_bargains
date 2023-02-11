import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/view/screens/main_screen.dart';

import '../view/screens/list_view_screen.dart';


class DynamicLinkService {
  Future handleDynamicLinks() async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();

    if (data?.link.path != null) {
      return data?.link.path;
    } else {
      return "nothing";
    }
  }

  void listenToDynamicLinks(BuildContext context) {
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? data) {
      handleDeepLink(data!, context);
    }
    ).onError((error) {
      print("Dynamic link failed: $error");
    });
  }

  void handleDeepLink(PendingDynamicLinkData? data, BuildContext context) {
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      print("deeplink: ${deepLink.path}");
      var parsedPath = deepLink.path.split('/');
      print("PARSED PATH: $parsedPath");
      var functionName = parsedPath[1];
      var listName = parsedPath[2];
      var listId = parsedPath[3];
      if (functionName == "add_user") {
        AppNavigator.push(context: context, screen: ListViewScreen(items: [],listId: listId, listName: listName, isUsingDynamicLink: true));
      }

    }
  }

  Widget getStartPage(String dynamicLinkPath) {
    if (dynamicLinkPath != "nothing") {
      var parsedPath = dynamicLinkPath.split('/');
      print("PARSED PATH: $parsedPath");
      var functionName = parsedPath[1];
      var listName = parsedPath[2];
      var listId = parsedPath[3];
      if (functionName == "add_user") {
        return ListViewScreen(items: [],listId: listId, listName: listName,isUsingDynamicLink: true);
      }
      return const MainScreen();                                //in case functionName wasn't add_user
    }
    return const MainScreen();
  }
}

