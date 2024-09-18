import 'package:bargainb/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/assets_manager.dart';

class StoreProductCard extends StatelessWidget {
  final String storeName;
  const StoreProductCard({super.key, required this.storeName});

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
        getStoreImage(context),
        width: 24,
        height: 24,
      ),
    );
  }

  String getStoreImage(BuildContext context){
    return Provider.of<ProductsProvider>(context).getStoreLogoPath(storeName);
  }
}
