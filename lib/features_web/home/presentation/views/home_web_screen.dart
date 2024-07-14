import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/all_categories_footer.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/customer_services_footer.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/download_app_footer.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/header_icon_button.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/home_footer.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/home_header.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/search_widget_web.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/social_contacts_widget.dart';
import 'package:bargainb/features_web/registration/presentation/views/register_web_screen.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum WebsitePage{
  homePage,
  todayDealsPage,
  assistantPage,
}

class HomeWebScreen extends StatefulWidget {
  const HomeWebScreen({super.key});

  @override
  State<HomeWebScreen> createState() => _HomeWebScreenState();
}

class _HomeWebScreenState extends State<HomeWebScreen> {
  var selectedPage = WebsitePage.homePage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(selectedPage: selectedPage, onChangePage: (page){
              setState(() {
                selectedPage = page;
              });
            }),
            if(selectedPage == WebsitePage.homePage) Center(child: Text("Homepage"),),
            if(selectedPage == WebsitePage.todayDealsPage) Center(child: Text("todayDealsPage"),),
            if(selectedPage == WebsitePage.assistantPage) Center(child: Text("assistantPage"),),
            // Spacer(),
            Container(
              height: 800.h,
            ),
            HomeFooter(),
          ],
        ),
      ),
    );
  }
}
