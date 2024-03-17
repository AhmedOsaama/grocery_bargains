import 'dart:convert';
import 'dart:math';

import 'package:bargainb/features/home/presentation/views/home_view.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/providers/tutorial_provider.dart';
import 'package:bargainb/services/purchase_service.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/components/close_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:provider/provider.dart';
import 'package:bargainb/features/chatlists/presentation/views/chatlists_screen.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/routes/app_navigator.dart';
import '../../features/onboarding/presentation/views/widgets/onboarding_stepper.dart';
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

  ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 1));


  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isFirstTime = prefs.getBool("firstTime") ?? true;
    });
  }

  Future<void> saveUserDeviceToken() async {
    var deviceToken = await FirebaseMessaging.instance
        .getToken(); //could produce a problem if permission is not accepted especially on iOS
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'token': deviceToken,
      'timestamp': Timestamp.now(),
    });
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added device token")));
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    PurchaseApi.init();
    NavigatorController.index = 0;
    FlutterBranchSdk.initSession().listen((data) {
      if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) {
        var listId = data["list_id"];
        var productData = data["product_data"];
        var page = data["page"];


        if (page != null) {
          if (page == '/profile-screen') AppNavigator.push(context: context, screen: ProfileScreen());
        }
        if (productData != null) {
          try {
            productData = jsonDecode(productData);
            Provider.of<ProductsProvider>(context, listen: false)
                .goToProductPage(productData['store_name'], context, productData['product_id']);
          } catch (e) {
            Provider.of<ProductsProvider>(context, listen: false).getAllProducts().then((value) {
              Provider.of<ProductsProvider>(context, listen: false)
                  .goToProductPage(productData['store_name'], context, productData['product_id']);
            }).catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
            });
          }
        }
        if (listId != null) {                         //case when a user clicks on a deep link to a chatlist
          var currentUserId = FirebaseAuth.instance.currentUser?.uid;
          if(!PurchaseApi.isSubscribed){
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Sorry you need to be subscribed to use this feature")));
            AppNavigator.goToChatlistTab(context);
            return;
          }
          FirebaseFirestore.instance.collection('/lists').doc(listId).get().then((listSnapshot) async {
            final List userIds = listSnapshot.data()!['userIds'];
            if (!userIds.contains(currentUserId)) {
              userIds.add(currentUserId);
              var userData = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
              await FirebaseFirestore.instance.collection('/lists').doc(listId).update({
                "userIds": userIds,
                "new_participant_username": userData['username'],
              });
              await Provider.of<ChatlistsProvider>(context, listen: false).getAllChatlists();
              var chatList = Provider.of<ChatlistsProvider>(context, listen: false)
                  .chatlists
                  .firstWhere((chatList) => chatList.id == listId);
                AppNavigator.push(context: context, screen: ChatListViewScreen(listId: listId));
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("User added successfully to list ${chatList.name}")));
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("User Already Exists in the list")));
            }
          });
        }
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print('InitSession error: ${platformException.code} - ${platformException.message}');
    });
    if (FirebaseAuth.instance.currentUser != null) {        //case when clicking on a new chat notification
      Provider.of<ChatlistsProvider>(context, listen: false).getAllChatlists().then((value) {
        if (widget.notificationData != null) {
          AppNavigator.push(context: context, screen: ChatListViewScreen(listId: widget.notificationData!));
        }
      });
    }
    try {
      TrackingUtils().trackAppOpen(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString());
      // Purchases.logIn(FirebaseAuth.instance.currentUser!.uid);
      saveUserDeviceToken();
    } catch (e) {
      print(e);
      TrackingUtils().trackAppOpen('Guest', DateTime.now().toUtc().toString());
    }
  }

  @override
  void dispose() {
   _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tutorialProvider = Provider.of<TutorialProvider>(context);
    if(tutorialProvider.canShowConfetti) _confettiController.play();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            PersistentTabView(
              key: tabKey,
              context,
              controller: NavigatorController,
              items: _navBarsItems(),
              screens: _buildScreens(),
              navBarStyle: NavBarStyle.simple,
            ),
            if(tutorialProvider.canShowConfetti) ...[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00181A26), Color(0xFF181A26)],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 200.h,left: 40, right: 40),
                child: Center(
                  child: DottedBorder(
                    strokeCap: StrokeCap.round,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    dashPattern: [3, 3],
                    strokeWidth: 1,
                    color: Color(0xFF7192F2),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: MyCloseButton(width: 25, onPressed: (){
                              tutorialProvider.hideTutorialConfetti();
                            },),
                          ),
                          if(PurchaseApi.isSubscribed) OnboardingStepper(activeStep: 4, stepSize: 10),
                          Text('Grocery shopping just got smarter!'.tr(), style: TextStylesInter.textViewSemiBold20,textAlign: TextAlign.center,),
                          15.ph,
                          if(PurchaseApi.isSubscribed)
                            Text("You've successfully completed BargainB's onboarding process. Now, you're ready to unlock the power of your grocery assistant and start saving big on your groceries".tr(),
                              style: TextStylesInter.textViewRegular13,
                              textAlign: TextAlign.center,),
                          if(!PurchaseApi.isSubscribed)
                          Text("You've successfully completed BargainB's onboarding process. Now, you're ready start saving big on your groceries".tr(),
                            style: TextStylesInter.textViewRegular13,
                            textAlign: TextAlign.center,),
                          10.ph,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  blastDirectionality: BlastDirectionality.explosive,
                  maxBlastForce: 3, // set a lower max blast force
                  minBlastForce: 2, // set a lower min blast force
                  emissionFrequency: 0.01,
                  numberOfParticles: 2, // a lot of particles at once
                  gravity: 0.2,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  blastDirectionality: BlastDirectionality.explosive,
                  maxBlastForce: 3, // set a lower max blast force
                  minBlastForce: 2, // set a lower min blast force
                  emissionFrequency: 0.02,
                  numberOfParticles: 10, // a lot of particles at once
                  gravity: 0.2,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  blastDirectionality: BlastDirectionality.explosive,
                  maxBlastForce: 3, // set a lower max blast force
                  minBlastForce: 2, // set a lower min blast force
                  emissionFrequency: 0.02,
                  numberOfParticles: 10, // a lot of particles at once
                  gravity: 0.2,
                ),
              ),
            ],
          ],
        ));
    // }
    // );
  }

  List<Widget> _buildScreens() {
    return [
      HomeView(),
      ChatlistsScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home_outlined,
          size: 24.sp,
        ),
        title: ("Home".tr()),
        textStyle: TextStyle(fontSize: 12.sp),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unSelectedColor,
      ),
      PersistentBottomNavBarItem(
          icon: SvgPicture.asset(bbIcon, color: selectedColor ,),
          inactiveIcon: SvgPicture.asset(bbIcon, color: unSelectedColor ,),
          title: ("Assistant".tr()),
          textStyle: TextStyle(fontSize: 12.sp),
          activeColorPrimary: selectedColor,
          inactiveColorPrimary: unSelectedColor,
          onPressed: (_) => AppNavigator.goToChatlistTab(context)
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
          onPressed: (_) => AppNavigator.goToProfileTab(context)
    ),
    ];
  }



}
