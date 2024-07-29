import 'package:bargainb/features_web/home/presentation/views/widgets/home_body_web.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/home_footer.dart';
import 'package:bargainb/features_web/home/presentation/views/widgets/home_header.dart';
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
            if(selectedPage == WebsitePage.homePage) Center(child: HomeBodyWeb(),),
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
