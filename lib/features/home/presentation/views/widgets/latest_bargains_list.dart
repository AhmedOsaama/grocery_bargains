import 'package:bargainb/features/home/presentation/views/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/products_provider.dart';
import '../../../../../view/widgets/discountItem.dart';
import '../../../data/models/product.dart';

class LatestBargainsList extends StatelessWidget {
  const LatestBargainsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (ctx, provider, _) {
        var products = provider.products;
        if (products.isEmpty) {
          return const ShimmerList();
        } else {
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.w, mainAxisExtent: 332.h, crossAxisSpacing: 5, mainAxisSpacing: 5),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                Product p = Product(
                  id: products.elementAt(index).id,
                  oldPrice: products.elementAt(index).oldPrice ?? "",
                  storeId: products.elementAt(index).storeId,
                  name: products.elementAt(index).name,
                  brand: products.elementAt(index).brand,
                  link: products.elementAt(index).link,
                  category: products.elementAt(index).category,
                  price: products.elementAt(index).price,
                  unit: products.elementAt(index).unit,
                  image: products.elementAt(index).image,
                  description: products.elementAt(index).description,
                  gtin: products.elementAt(index).gtin,
                  subCategory: products.elementAt(index).subCategory,
                  offer: products.elementAt(index).offer,
                  englishName: products.elementAt(index).englishName,
                  similarId: products.elementAt(index).similarId,
                  similarStId: products.elementAt(index).similarStId,
                  availableNow: products.elementAt(index).availableNow,
                  dateAdded: products.elementAt(index).dateAdded,
                );
                return DiscountItem(
                  product: p,
                  inGridView: false,
                );
              },
              childCount: products.length,
            ),
          );
        }
      },
    );
  }
}
