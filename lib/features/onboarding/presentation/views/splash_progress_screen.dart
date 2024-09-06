import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/assets_manager.dart';

class SplashWithProgressIndicator extends StatelessWidget {
  const SplashWithProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(splash, width: ScreenUtil().screenWidth, fit: BoxFit.cover,),
    );
  }
}
