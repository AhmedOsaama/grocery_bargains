import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swaav/config/themes/app_theme.dart';
import 'package:swaav/view/screens/home_screen.dart';
import 'package:swaav/view/screens/register_screen.dart';
import 'package:swaav/view/screens/splash_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: ScreenUtilInit(
          designSize: const Size(390,
              844),
          minTextAdapt: true,
          splitScreenMode: true,
        builder: (context,_) {
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                   return Center(child: CircularProgressIndicator(),);
              }
              if (snapshot.hasData) {
                return HomeScreen();
              }
              return RegisterScreen();
            }
          );
        }
      ),
    );
  }
}