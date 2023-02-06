import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/nav_bar.dart';
import 'package:swaav/view/screens/lists_screen.dart';
import 'package:swaav/view/screens/profile_screen.dart';
import 'package:swaav/view/widgets/list_type_widget.dart';

import '../../services/dynamic_link_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;

  @override
  void initState() {
    getUserDataFuture = FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    DynamicLinkService().listenToDynamicLinks(context);               //case 2 the app is open but in background and opened again via deep link
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
