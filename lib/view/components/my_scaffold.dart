import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swaav/view/components/nav_bar.dart';

class MyScaffold extends StatelessWidget {
  final Widget body;
  const MyScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: body,
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
