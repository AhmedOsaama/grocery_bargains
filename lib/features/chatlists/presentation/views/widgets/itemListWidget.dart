import 'dart:developer';

import 'package:bargainb/features/chatlists/presentation/views/widgets/quick_item_text_field.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/products_provider.dart';
import 'chat_view_widget.dart';
import '../../../../../view/widgets/chatlist_item.dart';

class ItemListWidget extends StatelessWidget {
  const ItemListWidget({
    super.key,
    required this.quicklyAddedItems,
    required this.quickItemController,
    required this.widget,
    required this.albertItems,
    required this.jumboItems,
    required this.hoogvlietItems,
    required this.dirkItems,
    required this.edekaItems,
    required this.plusItems,
    required this.reweItems,
    required this.coopItems,
    required this.sparItems,
    required this.aldiItems,
  });

  final List quicklyAddedItems;
  final TextEditingController quickItemController;
  final ChatView widget;
  final List albertItems;
  final List jumboItems;
  final List hoogvlietItems;
  final List dirkItems;
  final List edekaItems;
  final List plusItems;
  final List reweItems;
  final List coopItems;
  final List sparItems;
  final List aldiItems;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            20.ph,
            if (albertItems.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Provider.of<ProductsProvider>(context, listen: false).getStoreLogoPath("albert"),
                  width: 60,
                  height: 30,
                ),
              ),
              5.ph,
              Column(
                children: albertItems.map((item) {
                  return ChatlistItem(item: item);
                }).toList(),
              ),
            ],
            if (jumboItems.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Provider.of<ProductsProvider>(context, listen: false).getStoreLogoPath("jumbo"),
                  width: 60,
                  height: 30,
                ),
              ),
              5.ph,
              Column(
                children: jumboItems.map((item) {
                  return ChatlistItem(item: item);
                }).toList(),
              ),
            ],
            if (hoogvlietItems.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Provider.of<ProductsProvider>(context, listen: false).getStoreLogoPath("hoogvliet"),
                  width: 60,
                  height: 30,
                ),
              ),
              5.ph,
              Column(
                children: hoogvlietItems.map((item) {
                  return ChatlistItem(item: item);
                }).toList(),
              ),
            ],
            if (dirkItems.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Provider.of<ProductsProvider>(context, listen: false).getStoreLogoPath("Dirk"),
                  width: 60,
                  height: 30,
                ),
              ),
              5.ph,
              Column(
                children: dirkItems.map((item) {
                  return ChatlistItem(item: item);
                }).toList(),
              ),
            ],
            if (edekaItems.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Provider.of<ProductsProvider>(context, listen: false).getStoreLogoPath("edeka24"),
                  width: 60,
                  height: 30,
                ),
              ),
              5.ph,
              Column(
                children: edekaItems.map((item) {
                  return ChatlistItem(item: item);
                }).toList(),
              ),
            ],
            if (plusItems.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Provider.of<ProductsProvider>(context, listen: false).getStoreLogoPath("Plus"),
                  width: 60,
                  height: 30,
                ),
              ),
              5.ph,
              Column(
                children: plusItems.map((item) {
                  return ChatlistItem(item: item);
                }).toList(),
              ),
            ],
            if (reweItems.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Provider.of<ProductsProvider>(context, listen: false).getStoreLogoPath("Rewe"),
                  width: 60,
                  height: 30,
                ),
              ),
              5.ph,
              Column(
                children: reweItems.map((item) {
                  return ChatlistItem(item: item);
                }).toList(),
              ),
            ],
            if (coopItems.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Provider.of<ProductsProvider>(context, listen: false).getStoreLogoPath("Coop"),
                  width: 60,
                  height: 30,
                ),
              ),
              5.ph,
              Column(
                children: coopItems.map((item) {
                  return ChatlistItem(item: item);
                }).toList(),
              ),
            ],
            if (sparItems.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Provider.of<ProductsProvider>(context, listen: false).getStoreLogoPath("Spar"),
                  width: 60,
                  height: 30,
                ),
              ),
              5.ph,
              Column(
                children: sparItems.map((item) {
                  return ChatlistItem(item: item);
                }).toList(),
              ),
            ],
            if (aldiItems.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Provider.of<ProductsProvider>(context, listen: false).getStoreLogoPath("Aldi"),
                  width: 60,
                  height: 30,
                ),
              ),
              5.ph,
              Column(
                children: aldiItems.map((item) {
                  return ChatlistItem(item: item);
                }).toList(),
              ),
            ],
            Text("Quick Add Items", style: TextStylesInter.textViewMedium14,),
            10.ph,
            Column(
              children: quicklyAddedItems.map((item) {
                return ChatlistItem(item: item);
              }).toList(),
            ),
            20.ph,
            QuickItemTextField(quickItemController: quickItemController, listId: widget.listId),
          ],
        ),
      ),
    );
  }
}
