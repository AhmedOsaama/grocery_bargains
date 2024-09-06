import 'package:bargainb/utils/assets_manager.dart';
import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  final String store;
  final double width;
  final double height;
  final double paddingValue;
  const StoreCard({super.key, required this.store, required this.width, required this.height, required this.paddingValue});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        store,
        width: width,
        height: height,
      ),
    );
  }

}
