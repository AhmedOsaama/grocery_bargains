import 'dart:developer';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/utils/algolia_utils.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final FacetList storeFilter;
  final FacetList categoryFilter;
  final FacetList subCategoryFilter;
  final FilterState filterState;
  final HitsSearcher productSearcher;
  const FilterBottomSheet({super.key, required this.storeFilter, required this.categoryFilter, required this.subCategoryFilter, required this.filterState, required this.productSearcher});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  var sortBySelection = "Relevance";
  var categorySelection = "";
  var subCategorySelection = "";
  var isAlbertSelected = false;
  var isJumboSelected = false;
  var isHoogvlietSelected = false;
  var isDirkSelected = false;
  var isAllStoresSelected = false;
  List<String> selectedStoreFilter = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Sort and Filter", style: TextStylesPaytoneOne.textViewRegular24.copyWith(fontSize: 18),),
                Spacer(),
                TextButton(onPressed: (){
                  setState(() {
                  widget.filterState.clear();
                  selectedStoreFilter.clear();
                  categorySelection = "";
                  subCategorySelection = "";
                  });
                }, child: Text("Clear All", style: TextStylesInter.textViewRegular14.copyWith(decoration: TextDecoration.underline),),),
                IconButton(onPressed: (){
                  AppNavigator.pop(context: context, object: {
                    "store": selectedStoreFilter,
                    "category": categorySelection
                  });
                }, icon: Icon(Icons.close))
              ],
            ),
            Divider(),
            20.ph,
            Text("Selected Filters:", style: TextStylesInter.textViewBold14,),
            10.ph,
            Text("Store: ${selectedStoreFilter}"),
            Text("Category: ${categorySelection}"),
            Text("Subcategory: ${subCategorySelection}"),
            20.ph,
            ExpansionTile(
                title: Text("Sort by", style: TextStylesInter.textViewMedium20,),
                subtitle: Text(sortBySelection),
                children: [
                  RadioListTile(
                      title: Text("Relevance", style: TextStylesInter.textViewMedium14,),
                      value: "Relevance", groupValue: sortBySelection, onChanged: selectSortByOption),
                  RadioListTile(
                      title: Text("Price Low to High", style: TextStylesInter.textViewMedium14,),
                      value: "Price Low to High", groupValue: sortBySelection, onChanged: selectSortByOption
                  ),
                  RadioListTile(
                      title: Text("Price High to Low", style: TextStylesInter.textViewMedium14,),
                      value: "Price High to Low", groupValue: sortBySelection, onChanged: selectSortByOption
                  ),
                ]),
            CategoryFilterTile(context),
            SubcategoryFilterTile(context),
            StoreFilterTile(context),
          ],
        ),
      ),
    );
  }

  Widget StoreFilterTile(BuildContext context) => StreamBuilder<List<SelectableItem<Facet>>>(
      stream: widget.storeFilter.facets,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final selectableFacets = snapshot.data ?? [];
        // if (selectableFacets.length != storeList.length - 1) return SizedBox.shrink();
        return ExpansionTile(
            title: Text("All stores", style: TextStylesInter.textViewMedium20,),
            // subtitle: Text(selectedS),
            children: List.generate(selectableFacets.length, (index) => CheckboxListTile(
                title: Text(selectableFacets[index].item.value, style: TextStylesInter.textViewMedium14,),
                value: selectableFacets[index].isSelected, onChanged: (value){
              setState(() {
                widget.storeFilter.toggle(selectableFacets[index].item.value);
                selectedStoreFilter.add(selectableFacets[index].item.value);
              });
            }),)
        );
        // return Row(
        //   children: [
        //     15.pw,
        //     Container(
        //       margin: EdgeInsets.symmetric(horizontal: 10),
        //       padding: EdgeInsets.symmetric(horizontal: 15.w),
        //       decoration: BoxDecoration(
        //           color: orange70, borderRadius: BorderRadius.all(Radius.circular(6.r)), border: Border.all(color: grey)),
        //       child: DropdownButton<String>(
        //         value: storeDropdownValue,
        //         icon: Icon(
        //           Icons.keyboard_arrow_down,
        //           color: Colors.white,
        //         ),
        //         dropdownColor: orange70,
        //         iconSize: 24,
        //         underline: Container(),
        //         style: TextStylesInter.textViewRegular14.copyWith(color: Colors.white),
        //         borderRadius: BorderRadius.circular(4.r),
        //         onChanged: changeFilter,
        //         items: storeList.map<DropdownMenuItem<String>>((String value) {
        //           var index = storeList.indexOf(value) - 1;
        //           if (value == 'Store' || selectableFacets.isEmpty) {
        //             return DropdownMenuItem<String>(
        //               value: value,
        //               child: Text(
        //                 value.tr(),
        //                 style: TextStyles.textViewMedium12,
        //               ),
        //             );
        //           }
        //           var selectableFacet = selectableFacets[index];
        //           return DropdownMenuItem<String>(
        //             value: value,
        //             child: Text(
        //               "$value (${selectableFacet.item.count})",
        //               style: TextStyles.textViewMedium12,
        //             ),
        //           );
        //         }).toList(),
        //       ),
        //     ),
        //   ],
        // );
      });

  Widget CategoryFilterTile(BuildContext context) => StreamBuilder<List<SelectableItem<Facet>>>(
      stream: widget.categoryFilter.facets,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final selectableFacets = snapshot.data ?? [];
        // if (selectableFacets.length != storeList.length - 1) return SizedBox.shrink();
       return ExpansionTile(
            title: Text("All Categories", style: TextStylesInter.textViewMedium20,),
            subtitle: Text(categorySelection),
            children: List.generate(selectableFacets.length, (index) => RadioListTile(
                title: Text(selectableFacets[index].item.value, style: TextStylesInter.textViewMedium14,),
                value: selectableFacets[index].item.value, groupValue: categorySelection, onChanged: selectCategoryOption)
            )
        );
      });

  Widget SubcategoryFilterTile(BuildContext context) => StreamBuilder<List<SelectableItem<Facet>>>(
      stream: widget.subCategoryFilter.facets,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final selectableFacets = snapshot.data ?? [];
        // if (selectableFacets.length != storeList.length - 1) return SizedBox.shrink();
       return ExpansionTile(
            title: Text("All Subcategories", style: TextStylesInter.textViewMedium20,),
            subtitle: Text(subCategorySelection),
            children: List.generate(selectableFacets.length, (index) => RadioListTile(
                title: Text(selectableFacets[index].item.value, style: TextStylesInter.textViewMedium14,),
                value: selectableFacets[index].item.value, groupValue: subCategorySelection, onChanged: selectSubcategoryOption)
            )
        );
      });

  void selectSortByOption(String? value){
      setState(() {
        sortBySelection = value!;
        if(sortBySelection == "Relevance") {
          widget.productSearcher.applyState((state) =>  state.copyWith(
            indexName: AlgoliaApp.hitsIndex,
        ),);
        }
        if(sortBySelection == "Price High to Low") {
          widget.productSearcher.applyState((state) =>
              state.copyWith(
                indexName: AlgoliaApp.priceHighToLowIndex,
              ),);
          if (sortBySelection == "Price Low to High") {
            widget.productSearcher.applyState((state) =>
                state.copyWith(
                  indexName: AlgoliaApp.priceLowToHighIndex,
                ),);
          }
        }
      });
    }
  void selectCategoryOption(String? value){
      setState(() {
        categorySelection = value!;
        widget.categoryFilter.toggle(categorySelection);
      });
    }

    void selectSubcategoryOption(String? value){
      setState(() {
        subCategorySelection = value!;
        widget.subCategoryFilter.toggle(subCategorySelection);
      });
    }
}
