import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:flutter/material.dart';

class SocialContactsWidget extends StatelessWidget {
  const SocialContactsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: (){},
          child: Image.asset(instagram),
        ),
        15.pw,
        GestureDetector(
          onTap: (){},
          child: Image.asset(facebook),
        ),
        15.pw,
        GestureDetector(
          onTap: (){},
          child: Image.asset(twitter),
        ),
        15.pw,
        GestureDetector(
          onTap: (){},
          child: Image.asset(linkedin),
        ),
      ],
    );
  }
}
