import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/view/screens/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),(){
      if(mounted) AppNavigator.pushReplacement(context: context, screen: RegisterScreen());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: SvgPicture.asset(forgotPassword,width: 256,height: 60,))
    );
  }
}
