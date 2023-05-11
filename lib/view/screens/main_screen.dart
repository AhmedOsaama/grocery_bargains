import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/view/widgets/signin_dialog.dart';
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

import '../../providers/chatlists_provider.dart';

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
        print('Custom string: ${data["custom_string"]}');
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
    return Scaffold(
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
