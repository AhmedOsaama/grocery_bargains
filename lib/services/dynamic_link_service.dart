// import 'package:flutter/material.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:bargainb/config/routes/app_navigator.dart';
// import 'package:bargainb/view/screens/main_screen.dart';
//
// import '../view/screens/chatlist_view_screen.dart';
//
// class DynamicLinkService {
//   Future handleDynamicLinks() async {
//     final data = await FirebaseDynamicLinks.instance.getInitialLink();
//
//     if (data?.link.path != null) {
//       return data?.link.path;
//     } else {
//       return "nothing";
//     }
//   }
//
//   void listenToDynamicLinks(BuildContext context) {
//     FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? data) {
//       handleDeepLink(data!, context);
//     }).onError((error) {
//       print("Dynamic link failed: $error");
//     });
//   }
//
//   void handleDeepLink(PendingDynamicLinkData? data, BuildContext context) {
//     final Uri? deepLink = data?.link;
//     if (deepLink != null) {
//       var parsedPath = deepLink.path.split('/');
//
//       var functionName = parsedPath[1];
//       var listName = parsedPath[2];
//       var listId = parsedPath[3];
//       if (functionName == "add_user") {
//         AppNavigator.push(
//             context: context,
//             screen:
//                 ChatListViewScreen(listId: listId, isUsingDynamicLink: true));
//       }
//     }
//   }
//
//   Widget getStartPage(String dynamicLinkPath) {
//     if (dynamicLinkPath != "nothing") {
//       var parsedPath = dynamicLinkPath.split('/');
//
//       var functionName = parsedPath[1];
//       var listName = parsedPath[2];
//       var listId = parsedPath[3];
//       if (functionName == "add_user") {
//         return ChatListViewScreen(listId: listId, isUsingDynamicLink: true);
//       }
//       return const MainScreen(); //in case functionName wasn't add_user
//     }
//     return const MainScreen();
//   }
// }
