import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features_web/home/presentation/views/home_web_screen.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/header_icon_button.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/search_widget_web.dart';
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

class HomeHeader extends StatelessWidget {
  final WebsitePage selectedPage;
  final Function onChangePage;
  const HomeHeader({super.key, required this.selectedPage, required this.onChangePage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(offset: const Offset(0,10),blurRadius: 10,color: mainPurple.withOpacity(0.1)),
          ]
      ),
      child: Row(
        children: [
          55.pw,
          Image.asset(bargainbLogo,width: 212.w,height: 60.h,),
          90.pw,
          GestureDetector(
            onTap: () => onChangePage(WebsitePage.homePage),
              child: HeaderIconButton(iconPath: homeIcon, text: "Home", pageValue: WebsitePage.homePage,selectedPage: selectedPage,)),
          10.pw,
          GestureDetector(
              onTap: () => onChangePage(WebsitePage.todayDealsPage),
              child: HeaderIconButton(iconPath: todayDealIcon, text: "Today's Deal", pageValue: WebsitePage.todayDealsPage,selectedPage: selectedPage,)),
          10.pw,
          GestureDetector(
              onTap: () => onChangePage(WebsitePage.assistantPage),
              child: HeaderIconButton(iconPath: assistantIcon, text: "Assistant", pageValue: WebsitePage.assistantPage, selectedPage: selectedPage,)),
          20.pw,
          Expanded(child: SearchWidgetWeb()),
          // 90.pw,
          10.pw,
          IconButton(onPressed: (){}, icon: const Icon(Icons.language,color: mainPurple,)),
          20.pw,
          TextButton(onPressed: (){
            AppNavigator.push(context: context, screen: RegisterWebScreen(isLogin: true));
          }, child: Text("Login", style: TextStylesInter.textViewBold20.copyWith(color: mainPurple),)),
          20.pw,
          ElevatedButton(onPressed: (){
            AppNavigator.push(context: context, screen: RegisterWebScreen(isLogin: false));
          }, style: ElevatedButton.styleFrom(
            backgroundColor: mainPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          ), child: Text("Sign up", style: TextStylesInter.textViewBold20,)),
          20.pw,
        ],
      ),
    );
  }
}
