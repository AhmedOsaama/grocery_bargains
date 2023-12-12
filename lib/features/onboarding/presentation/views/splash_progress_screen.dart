import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../../../utils/assets_manager.dart';

class SplashWithProgressIndicator extends StatelessWidget {
  const SplashWithProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Image.asset(splash_image),
          20.ph,
          Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}
