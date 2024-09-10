import 'package:flutter/material.dart';

import '../../../../../utils/assets_manager.dart';

class StoreProductCard extends StatelessWidget {
  final int storeId;
  const StoreProductCard({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
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
        getStoreImage(),
        width: 24,
        height: 24,
      ),
    );
  }

  String getStoreImage(){
    if(storeId == 1){
      return albert;
    }
    if(storeId == 2){
      return jumbo;
    }
    if(storeId == 3){
      return hoogLogo;
    }
    if(storeId == 4){
      return dirkLogo;
    }
    if(storeId == 5){
      return edeka;
    }
    return bargainbLogo;
    // if(storeId == 5){
    //   return e;
    // }

  }
}
