import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/view/screens/home_screen.dart';
import 'package:bargainb/view/screens/chatlists_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
// class _MainScreenState extends State<MainScreen> {
  var selectedIndex = 0;
  final _pages = [
    const HomeScreen(),
    const ChatlistsScreen(),
    const ProfileScreen(),
  ];
  final selectedColor = Color.fromRGBO(99, 104, 176, 1);
  final unSelectedColor = Color.fromRGBO(219, 221, 228, 1);

  // void initState() {
  //   getUserDataFuture = FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
  //   DynamicLinkService().listenToDynamicLinks(context);               //case 2 the app is open but in background and opened again via deep link
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();

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
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: getAllProductsFuture,
    //   builder: (context, snapshot) {
    //     if(snapshot.connectionState == ConnectionState.waiting) return Stack(
    //       children: [
    //         Container(
    //           width: double.infinity,
    //           height: double.infinity,
    //           decoration: BoxDecoration(
    //             image: DecorationImage(
    //               image: AssetImage(
    //                 splashImage
    //               ),
    //               fit: BoxFit.fill
    //             ),
    //           ),
    //         ),
    //         Container(
    //           margin: EdgeInsets.only(top: 250),
    //           alignment: Alignment.center,
    //         child: CircularProgressIndicator(),)
    //       ],
    //     );
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
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
    // }
    // );
  }
}
