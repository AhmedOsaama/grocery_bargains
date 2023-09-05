// import 'package:bargainb/utils/empty_padding.dart';
// import 'package:bargainb/view/components/search_widget.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import '../../models/product.dart';
// import '../../providers/products_provider.dart';
// import '../../utils/app_colors.dart';
// import '../../utils/style_utils.dart';
// import '../../utils/tracking_utils.dart';
// import '../widgets/discountItem.dart';
//
// class SearchScreen extends StatefulWidget {
//   String searchQuery;
//   SearchScreen({Key? key, required this.searchQuery}) : super(key: key);
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   String sortDropdownValue = 'Sort';
//   String storeDropdownValue = 'Store';
//
//   @override
//   Widget build(BuildContext context) {
//     var productProvider = Provider.of<ProductsProvider>(context, listen: false);
//     return Scaffold(
//       body: Column(
//         children: [
//           70.ph,
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: SearchWidget(isBackButton: true),
//           ),
//           Expanded(
//             child: FutureBuilder(
//                 future: Provider.of<ProductsProvider>(context, listen: false).searchProducts(widget.searchQuery),
//                 builder: (ctx, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting)
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   if (!snapshot.hasData || snapshot.hasError)
//                     return Center(
//                       child: Text("tryAgain".tr()),
//                     );
//                   var searchResults = snapshot.data ?? [];
//                   if (searchResults.isEmpty)
//                     return Center(
//                       child: Text("noMatchesFound".tr()),
//                     );
//                   // var results = List.from(searchResults);
//                   var results = [];
//                   resetFilter();
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                     child: StatefulBuilder(builder: (ctx, setState) {
//                       results = filterProducts(results, searchResults, productProvider);
//                       if (widget.searchQuery.contains("Relevance")) sortDropdownValue = "Relevance";
//                       print(sortDropdownValue);
//                       return Column(
//                         children: [
//                           20.ph,
//                           Row(children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 15.w),
//                               decoration: BoxDecoration(
//                                   color: white,
//                                   borderRadius: BorderRadius.all(Radius.circular(6.r)),
//                                   border: Border.all(color: grey)),
//                               child: DropdownButton<String>(
//                                 value: sortDropdownValue,
//                                 icon: Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: greyDropdownText,
//                                 ),
//                                 iconSize: 24,
//                                 underline: Container(),
//                                 // dropdownColor: Colors.white,
//                                 style: TextStylesInter.textViewRegular14.copyWith(color: greyDropdownText),
//                                 borderRadius: BorderRadius.circular(4.r),
//                                 onChanged: (String? newValue) {
//                                   if (newValue != "Relevance") {
//                                     if (widget.searchQuery.contains("Relevance")) {
//                                       this.setState(() {
//                                       widget.searchQuery = widget.searchQuery.split('-')[0];
//                                       });
//                                     }
//                                     setState(() {
//                                       sortDropdownValue = newValue!;
//                                     });
//                                     return;
//                                   }
//                                   if (newValue == "Relevance" && !widget.searchQuery.contains("Relevance")) {
//                                     this.setState(() {
//                                       widget.searchQuery = widget.searchQuery + " - Relevance";
//                                     });
//                                   }
//                                   // else widget.searchQuery = widget.searchQuery.split('-')[0];
//                                 },
//                                 items: <String>['Sort', "Relevance", 'Low price', 'High price']
//                                     .map<DropdownMenuItem<String>>((String value) {
//                                   // <String>['Sort', 'Low price', 'High price'].map<DropdownMenuItem<String>>((String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Text(
//                                       value,
//                                       style: TextStyles.textViewMedium12,
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                             8.pw,
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 15.w),
//                               decoration: BoxDecoration(
//                                   color: white,
//                                   borderRadius: BorderRadius.all(Radius.circular(6.r)),
//                                   border: Border.all(color: grey)),
//                               child: Center(
//                                 child: DropdownButton<String>(
//                                   value: storeDropdownValue,
//                                   icon: Icon(
//                                     Icons.keyboard_arrow_down,
//                                     color: greyDropdownText,
//                                   ),
//                                   iconSize: 24,
//                                   // dropdownColor: orange70,
//                                   underline: Container(),
//                                   style: TextStylesInter.textViewRegular14.copyWith(color: greyDropdownText),
//                                   borderRadius: BorderRadius.circular(4.r),
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       storeDropdownValue = newValue!;
//                                     });
//                                   },
//                                   items: <String>['Store', 'Albert Heijn', 'Jumbo', 'Hoogvliet']
//                                       .map<DropdownMenuItem<String>>((String value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(
//                                         value,
//                                         style: TextStyles.textViewMedium12,
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ),
//                             8.pw,
//                           ]),
//                           Expanded(
//                             child: GridView.builder(
//                               padding: EdgeInsets.zero,
//                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 2, mainAxisSpacing: 15.h, childAspectRatio: 0.6),
//                               itemCount: results.length,
//                               itemBuilder: (ctx, i) {
//                                 // return Text(results[i].id.toString());
//                                 return DiscountItem(
//                                   inGridView: false,
//                                   product: results[i],
//                                 );
//                               },
//                             ),
//                           ),
//                           // isFetching ? Center(child: CircularProgressIndicator()) :
//                           // GenericButton(
//                           //     borderRadius: BorderRadius.circular(10),
//                           //     borderColor: mainPurple,
//                           //     color: Colors.white,
//                           //     onPressed: () async {
//                           //       var productsProvider = Provider.of<ProductsProvider>(context, listen: false);
//                           //       setState(() {
//                           //         isFetching = true;
//                           //       });
//                           //       try {
//                           //         var startingIndex = allProducts.last.id + 1;
//                           //         print("StartingIndex: " + startingIndex.toString());
//                           //         await productsProvider.getProducts(startingIndex);
//                           //         // all.addAll(newProducts);
//                           //       }catch(e){
//                           //         print(e);
//                           //       }
//                           //       setState(() {
//                           //         isFetching = false;
//                           //       });
//                           //     },
//                           //     child: Row(
//                           //       mainAxisAlignment: MainAxisAlignment.center,
//                           //       children: [
//                           //         Text("SEE MORE",style: TextStyles.textViewMedium12.copyWith(color: blackSecondary),),
//                           //         10.pw,
//                           //         Icon(Icons.keyboard_arrow_down,color: Colors.black,),
//                           //       ],
//                           //     )),
//                         ],
//                       );
//                     }),
//                   );
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void resetFilter() {
//     sortDropdownValue = 'Sort';
//     storeDropdownValue = 'Store';
//   }
//
//   List filterProducts(List results, List<Product?> searchResults, ProductsProvider productProvider) {
//     if (sortDropdownValue == "Sort" && storeDropdownValue == "Store") {
//       results = List.from(searchResults);
//     }
//     if (sortDropdownValue != "Sort" && storeDropdownValue == "Store") {
//       if (sortDropdownValue == "Relevance") {
//       } else
//         results = productProvider.sortProducts(sortDropdownValue, results);
//     }
//     if (sortDropdownValue == "Sort" && storeDropdownValue != "Store") {
//       if (storeDropdownValue == "Albert Heijn") {
//         results = searchResults
//             .where((searchResult) => productProvider.getStoreName(searchResult?.storeId ?? 0) == "Albert")
//             .toList();
//       } else {
//         results = searchResults
//             .where((searchResult) => productProvider.getStoreName(searchResult?.storeId ?? 0) == storeDropdownValue)
//             .toList();
//       }
//     }
//     if (sortDropdownValue != "Sort" && storeDropdownValue != "Store") {
//       if (storeDropdownValue == "Albert Heijn") {
//         results = searchResults
//             .where((searchResult) => productProvider.getStoreName(searchResult?.storeId ?? 0) == "Albert")
//             .toList();
//       } else {
//         results = searchResults
//             .where((searchResult) => productProvider.getStoreName(searchResult?.storeId ?? 0) == storeDropdownValue)
//             .toList();
//       }
//       if (sortDropdownValue == "Relevance") {
//       } else
//         results = productProvider.sortProducts(sortDropdownValue, results);
//     }
//     try {
//       TrackingUtils()
//           .trackSearchPerformed("$sortDropdownValue, $storeDropdownValue", FirebaseAuth.instance.currentUser!.uid, "");
//     } catch (e) {
//       print(e);
//     }
//     return results;
//   }
// }
