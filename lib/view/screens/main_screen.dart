import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/nav_bar.dart';
import 'package:bargainb/view/screens/home_screen.dart';
import 'package:bargainb/view/screens/chatlists_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/list_type_widget.dart';

import '../../main.dart';
import '../../providers/chatlists_provider.dart';
import '../../services/dynamic_link_service.dart';
import 'chatlist_view_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  // Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  var selectedIndex = 0;
  final _pages = [
    const HomeScreen(),
    const ChatlistsScreen(),
    const ProfileScreen(),
  ];
  final selectedColor = Color.fromRGBO(99, 104, 176, 1);
  final unSelectedColor = Color.fromRGBO(219, 221, 228, 1);

  // @override
  // void initState() {
  //   getUserDataFuture = FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
  //   DynamicLinkService().listenToDynamicLinks(context);               //case 2 the app is open but in background and opened again via deep link
  //   super.initState();
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    FlutterBranchSdk.initSession().listen((data) {
      print(data.entries.toList().toString());
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

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print(message);
        print("onMessageOpenedApp: " + message.data['listId']);
        print("onMessageOpenedApp title: " + message.notification!.title!);
        print("onMessageOpenedApp body: " + message.notification!.body!);
        print('PUSHING A PAGE');
        AppNavigator.push(context: context, screen: ChatListViewScreen(listId: message.data['listId'], listName: message.notification!.title!));
      });
    }
    if(state == AppLifecycleState.paused){
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }
    super.didChangeAppLifecycleState(state);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.home_outlined,
                color: selectedIndex == 0 ? selectedColor : unSelectedColor,
              ),
              onPressed: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.sticky_note_2_outlined,
                color: selectedIndex == 1 ? selectedColor : unSelectedColor,
              ),
              onPressed: () async {
                setState(() {
                  selectedIndex = 1;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle_outlined,
                color: selectedIndex == 2 ? selectedColor : unSelectedColor,
              ),
              onPressed: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
