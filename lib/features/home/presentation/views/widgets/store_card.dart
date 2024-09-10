import 'package:bargainb/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../search/presentation/views/algolia_search_screen.dart';

class StoreCard extends StatelessWidget {
  final String storeImage;
  final String storeName;
  final double width;
  final double height;
  final double paddingValue;
  const StoreCard({super.key, required this.width, required this.height, required this.paddingValue, required this.storeImage, required this.storeName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        pushNewScreen(context,
            screen: AlgoliaSearchScreen(
              store: storeName,
            ),
            withNavBar: true);
      },
      child: Container(
        padding: EdgeInsets.all(paddingValue),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow:  [
              BoxShadow(
                color: Color(0xff00B207).withOpacity(0.1),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                  color: Color(0xff2C742F).withOpacity(0.1),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: -1
              )
            ]),
        child: Image.asset(
          storeImage,
          width: width,
          height: height,
        ),
      ),
    );
  }

}
