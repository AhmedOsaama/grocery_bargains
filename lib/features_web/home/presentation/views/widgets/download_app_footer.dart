import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/style_utils.dart';

class DownloadAppFooter extends StatelessWidget {
  const DownloadAppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Download App",
          style: TextStylesInter.textViewMedium25,
        ),
        50.ph,
        InkWell(
          onTap: (){},
            child: Image.asset(downloadAppStore, width: 147.w, height: 44.h,)),
        20.ph,
        InkWell(
            onTap:(){},
            child: Image.asset(downloadPlayStore,width: 147.w, height: 44.h)),
      ],
    );
  }
}
