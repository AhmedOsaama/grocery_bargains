import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swaav/config/themes/app_theme.dart';
import 'package:swaav/view/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWAAV',
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => ScreenUtilInit(
            designSize: const Size(390,
                844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (ctx,child) => SplashScreen()),
      ),
    );
  }
}