import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';
import 'all_categories_footer.dart';
import 'customer_services_footer.dart';
import 'download_app_footer.dart';
import 'social_contacts_widget.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 160, vertical: 30),
      color: const Color(0xffEBEFFD),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(bargainbLogo, width: 201.w, height: 60.h,),
                  100.ph,
                  const SocialContactsWidget(),
                ],
              ),
              const Spacer(),
              const AllCategoriesFooter(),
              const CustomerServicesFooter(),
              const DownloadAppFooter()
            ],
          ),
          const Divider(),
          Text("© 2024 RCCP Inc.  All Rights Reserved.", style: TextStylesInter.textViewMedium20.copyWith(color: const Color(0xff7C7C7C)),)
        ],
      ),
    );
  }
}
