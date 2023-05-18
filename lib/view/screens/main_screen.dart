import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/view/widgets/signin_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:provider/provider.dart';
import 'package:bargainb/view/screens/home_screen.dart';
import 'package:bargainb/view/screens/chatlists_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';

import '../../config/routes/app_navigator.dart';
import '../../providers/chatlists_provider.dart';
import 'chatlist_view_screen.dart';

Key tabKey = UniqueKey();
PersistentTabController NavigatorController = PersistentTabController();

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final selectedColor = mainPurple;
  final unSelectedColor = purple30;

  // void initState() {
  //   getUserDataFuture = FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
  //   DynamicLinkService().listenToDynamicLinks(context);               //case 2 the app is open but in background and opened again via deep link
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
    NavigatorController.index = 0;
    FlutterBranchSdk.initSession().listen((data) {
      print("branch data: " + data.entries.toList().toString());
      if (data.containsKey("+clicked_branch_link") &&
          data["+clicked_branch_link"] == true) {
        //Link clicked. Add logic to get link data and route user to correct screen
        var listId = data["list_id"];
        // var listId = data["route"];
        // if(route == '/home_screen')
        print('Custom string: ${listId}');
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
    // FlutterBranchSdk.validateSDKIntegration();
    if (FirebaseAuth.instance.currentUser != null)
      Provider.of<ChatlistsProvider>(context, listen: false).getAllChatlists();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: PersistentTabView(
            key: tabKey,
            context,
            controller: NavigatorController,
            items: _navBarsItems(),
            screens: _buildScreens(),
            navBarStyle: NavBarStyle.simple,
            stateManagement: true,
          )),
    );
    // }
    // );
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      ChatlistsScreen(),
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
      ),
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
            }
          }),
    ];
  }
}
