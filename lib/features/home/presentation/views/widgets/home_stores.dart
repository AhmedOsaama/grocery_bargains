import 'package:bargainb/features/home/presentation/views/widgets/store_card.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/assets_manager.dart';

class HomeStores extends StatelessWidget {
  const HomeStores({super.key});

  @override
  Widget build(BuildContext context) {
    final Map stores = {
      "Albert Heijn": albert,
      "Jumbo": jumbo,
      "Dirk": dirkLogo,
      "Hoogvliet": hoogLogo,
      "Spar": spar,
      "Coop": coop,
      "Lidl": lidle_store,
      "Aldi": aldi,
    };
    return Center(
      child: Wrap(
        spacing: 10,
        runSpacing: 20,
        children: stores.entries.map((store) {
          return StoreCard(store: store.value, width: 40, height: 40, paddingValue: 16,);
        }).toList(),
      ),
    );
  }
}
