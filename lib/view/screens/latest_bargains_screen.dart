import 'package:bargainb/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../widgets/discountItem.dart';

class LatestBargainsScreen extends StatelessWidget {
  const LatestBargainsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var comparisonProducts = Provider.of<ProductsProvider>(context,listen: false).comparisonProducts;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: white,
        foregroundColor: Colors.black,
        title: Text(
          "Latest Bargains",
          style: TextStylesInter.textViewSemiBold17.copyWith(color: black2),
        ),
      ),
      body: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // mainAxisSpacing: 12,
        // crossAxisSpacing: 10,
      ), itemCount: comparisonProducts.length,itemBuilder: (ctx,i) => DiscountItem(
        comparisonProduct: comparisonProducts[i],
      ),)
      );
  }
}
