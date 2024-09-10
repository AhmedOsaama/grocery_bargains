import 'package:bargainb/features/home/presentation/views/widgets/store_card.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/assets_manager.dart';

class HomeStores extends StatelessWidget {
  const HomeStores({super.key});

  @override
  Widget build(BuildContext context) {
    final Map stores = {
      "albert": albert,
      "jumbo": jumbo,
      "Dirk": dirkLogo,
      "hoogvliet": hoogLogo,
      "Spar": spar,
      "Coop": coop,
      // "Plus": ,
      "Aldi": aldi,
      "edeka24": edeka,
      // "Rewe": ,

    };
    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 20,
        children: stores.entries.map((store) {
          return StoreCard(storeImage: store.value, storeName: store.key, width: 40, height: 40, paddingValue: 16,);
        }).toList(),
      ),
    );
  }
}
