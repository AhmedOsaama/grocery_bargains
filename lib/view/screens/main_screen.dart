import 'dart:convert';

import 'package:algolia/algolia.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/screens/insights_screen.dart';
import 'package:bargainb/view/screens/product_detail_screen.dart';
import 'package:bargainb/view/widgets/signin_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:provider/provider.dart';
import 'package:bargainb/view/screens/home_screen.dart';
import 'package:bargainb/features/chatlists/presentation/views/chatlists_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/routes/app_navigator.dart';
import '../../providers/chatlists_provider.dart';
import 'chatlist_view_screen.dart';

Key tabKey = UniqueKey();
PersistentTabController NavigatorController = PersistentTabController();

class MainScreen extends StatefulWidget {
  final String? notificationData;
  const MainScreen({Key? key, this.notificationData}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final selectedColor = mainPurple;
  final unSelectedColor = purple30;
  late bool isFirstTime;


  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isFirstTime = prefs.getBool("firstTime") ?? true;
    });
  }

  Future<void> saveUserDeviceToken() async {
    var deviceToken = await FirebaseMessaging.instance.getToken();              //could produce a problem if permission is not accepted especially on iOS
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'token': deviceToken,
      'timestamp': Timestamp.now(),
    });
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added device token")));
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    NavigatorController.index = 0;
    FlutterBranchSdk.initSession().listen((data) {
      if (data.containsKey("+clicked_branch_link") &&
          data["+clicked_branch_link"] == true) {
        //Link clicked. Add logic to get link data and route user to correct screen
        var listId = data["list_id"];
        var productData = data["product_data"];
        var page = data["page"];

        print('Custom string: ${listId}');
        print('Custom string: ${productData}');
        print('Custom string: ${page}');
        if(page != null){
          if(page == '/profile-screen') AppNavigator.push(context: context, screen: ProfileScreen());
        }
        if(productData != null){
          try {
              productData = jsonDecode(productData);
              Provider.of<ProductsProvider>(context, listen: false).goToProductPage(
                  productData['store_name'], context, productData['product_id']);
          }catch(e){
            Provider.of<ProductsProvider>(context, listen: false).getAllProducts().then((value) {
              Provider.of<ProductsProvider>(context, listen: false).goToProductPage(
                  productData['store_name'], context, productData['product_id']);
            }).catchError((e){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
            });
          }
          }
        if (listId != null) {
          var currentUserId = FirebaseAuth.instance.currentUser?.uid;
          FirebaseFirestore.instance
              .collection('/lists')
              .doc(listId)
              .get()
              .then((listSnapshot) async {
            final List userIds = listSnapshot.data()!['userIds'];
            if (!userIds.contains(currentUserId)) {
              userIds.add(currentUserId);
              var userData = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserId)
                  .get();
              await FirebaseFirestore.instance
                  .collection('/lists')
                  .doc(listId)
                  .update({
                "userIds": userIds,
                // "user_num": FieldValue.increment(1),
                "new_participant_username": userData['username'],
              });
              await Provider.of<ChatlistsProvider>(context, listen: false)
                  .getAllChatlists();
              var chatList =
                  Provider.of<ChatlistsProvider>(context, listen: false)
                      .chatlists
                      .firstWhere((chatList) => chatList.id == listId);
              AppNavigator.push(
                  context: context, screen: ChatListViewScreen(listId: listId));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "User added successfully to list ${chatList.name}")));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("User Already Exists in the list")));
            }
          });
        }
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
    if (FirebaseAuth.instance.currentUser != null)
      Provider.of<ChatlistsProvider>(context, listen: false).getAllChatlists().then((value) {
        if(widget.notificationData != null){
          AppNavigator.push(context: context, screen: ChatListViewScreen(listId: widget.notificationData!));
        }
      });
    try{
      TrackingUtils().trackAppOpen(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString());
      // Purchases.logIn(FirebaseAuth.instance.currentUser!.uid);
      saveUserDeviceToken();
    }catch(e){
      print(e);
      TrackingUtils().trackAppOpen('Guest', DateTime.now().toUtc().toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: PersistentTabView(
          key: tabKey,
          context,
          controller: NavigatorController,
          items: _navBarsItems(),
          screens: _buildScreens(),
          navBarStyle: NavBarStyle.simple,
          stateManagement: true,
        ));
    // }
    // );
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      ChatlistsScreen(),
      // InsightsScreen(),
      FirebaseAuth.instance.currentUser == null ? Container() : ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home_outlined,
          size: 24.sp,
        ),
        title: ("Home"),
        textStyle: TextStyle(fontSize: 12.sp),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unSelectedColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.chat_outlined,
          size: 24.sp,
        ),
        title: ("chatlists".tr()),
        textStyle: TextStyle(fontSize: 12.sp),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unSelectedColor,
        onPressed: (_){
          NavigatorController.jumpToTab(1);
          try{
            TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "open Chatlists screen", DateTime.now().toUtc().toString(), "Home screen");
          }catch(e){
            print(e);
            TrackingUtils().trackButtonClick("Guest", "open Chatlists screen", DateTime.now().toUtc().toString(), "Home screen");
          }
        }
      ),
      // PersistentBottomNavBarItem(
      //     icon: Icon(
      //       Icons.analytics_outlined,
      //       size: 24.sp,
      //     ),
      //     title: ("Insights".tr()),
      //     textStyle: TextStyle(fontSize: 12.sp),
      //     activeColorPrimary: selectedColor,
      //     inactiveColorPrimary: unSelectedColor,
      //     onPressed: (_){
      //       NavigatorController.jumpToTab(2);
      //       try{
      //         TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "open Insights screen", DateTime.now().toUtc().toString(), "Home screen");
      //       }catch(e){
      //         print(e);
      //         TrackingUtils().trackButtonClick("Guest", "open Insights screen", DateTime.now().toUtc().toString(), "Home screen");
      //       }
      //     }
      // ),

      PersistentBottomNavBarItem(
          icon: Icon(
            Icons.account_circle_outlined,
            size: 24.sp,
          ),
          title: ("profile".tr()),
          textStyle: TextStyle(fontSize: 12.sp),
          activeColorPrimary: selectedColor,
          inactiveColorPrimary: unSelectedColor,
          onPressed: (p) {
            if (FirebaseAuth.instance.currentUser == null) {
              showDialog(
                  context: context,
                  builder: (ctx) => SigninDialog(
                        body: 'You have to be signed in to use this feature.',
                        buttonText: 'Sign in',
                        title: 'Sign In',
                      ));
            } else {
              NavigatorController.jumpToTab(2);
              try{
                TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "open profile screen", DateTime.now().toUtc().toString(), "Home screen");
              }catch(e){
                print(e);
                TrackingUtils().trackButtonClick("Guest", "open profile screen", DateTime.now().toUtc().toString(), "Home screen");
              }
            }
          }),
    ];
  }
}
