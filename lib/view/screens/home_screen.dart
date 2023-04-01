import 'dart:convert';

import 'package:bargainb/models/bestValue_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/services/network_services.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/utils/utils.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/screens/choose_store_screen.dart';
import 'package:bargainb/view/screens/chatlists_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/chat_view_widget.dart';
import 'package:bargainb/view/screens/product_detail_screen.dart';
import 'package:bargainb/view/screens/register_screen.dart';
import 'package:bargainb/view/widgets/category_widget.dart';
import 'package:bargainb/view/widgets/discountItem.dart';
import 'package:bargainb/view/widgets/product_item.dart';
import 'package:bargainb/view/widgets/search_item.dart';

import '../../config/routes/app_navigator.dart';
import '../../models/list_item.dart';
import '../../models/product.dart';
import '../../providers/google_sign_in_provider.dart';
import '../../services/dynamic_link_service.dart';
import '../../utils/assets_manager.dart';
import '../../utils/icons_manager.dart';
import '../components/button.dart';
import '../widgets/store_list_widget.dart';
import 'chatlist_view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  // late Future<int> getAllProductsFuture;
  late Future<QuerySnapshot> getAllListsFuture;
  // late Future<List<BestValueItem>> getAllValueBargainsFuture;
  List allProducts = [];

  var isLoading = false;
  TextStyle textButtonStyle =
      TextStylesInter.textViewRegular16.copyWith(color: mainPurple);

  List<BestValueItem> bestValueBargains = [];

  @override
  void initState() {
    super.initState();
    getAllListsFuture = Provider.of<ChatlistsProvider>(context, listen: false)
        .getAllChatlistsFuture();
    // getAllValueBargainsFuture =
    //     Provider.of<ProductsProvider>(context, listen: false)
    //         .populateBestValueBargains();
    getUserDataFuture = FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    DynamicLinkService().listenToDynamicLinks(
        context); //case 2 the app is open but in background and opened again via deep link
  }

  @override
  void didChangeDependencies() {
    // getAllProductsFuture =
    //     Provider.of<ProductsProvider>(context, listen: false).getProducts(0);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                      future: getUserDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        // if(googleProvider.isGoogleSignedIn){
                        //   return Text(
                        //     style: TextStylesInter.textViewSemiBold24
                        //         .copyWith(color: mainPurple),
                        //     '${'Hello, ' + (googleProvider.user.displayName ?? "Google user")}!',
                        //   );
                        // }
                        return Text(
                          style: TextStylesInter.textViewSemiBold24
                              .copyWith(color: mainPurple),
                          '${'Hello, ' + snapshot.data!['username']}!',
                        );
                      }),
                  FutureBuilder(
                      future: getUserDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        // if(googleProvider.isGoogleSignedIn){
                        //   return googleProvider.user.photoUrl != "" && googleProvider.user.photoUrl != null
                        //       ? CircleAvatar(
                        //     backgroundImage:
                        //     NetworkImage(googleProvider.user.photoUrl!),
                        //     radius: 30,
                        //   )
                        //       : SvgPicture.asset(personIcon);
                        // }
                        return snapshot.data!['imageURL'] != ""
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(snapshot.data!['imageURL']),
                                radius: 30,
                              )
                            : SvgPicture.asset(bee);
                      }),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              GenericField(
                isFilled: true,
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  return showSearch(
                      context: context, delegate: MySearchDelegate(pref));
                },
                prefixIcon: Icon(Icons.search),
                borderRaduis: 999,
                hintText: LocaleKeys.whatAreYouLookingFor.tr(),
                hintStyle:
                    TextStyles.textViewSemiBold14.copyWith(color: gunmetal),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.chatlists.tr(),
                    style: TextStylesInter.textViewSemiBold16
                        .copyWith(color: black2),
                  ),
                  TextButton(
                      onPressed: () => AppNavigator.push(
                          context: context, screen: ChatlistsScreen()),
                      child: Text(
                        'See all',
                        style: textButtonStyle,
                      ))
                ],
              ),
              // Consumer<ChatlistsProvider>(builder: (ctx, provider, _) {
              //   var chatlists = provider.chatlists;
              //   if (chatlists.isEmpty) {
              //           return GestureDetector(
              //             onTap: (){
              //               AppNavigator.push(context: context, screen: ChatlistsScreen());
              //             },
              //             child: Image.asset(
              //               newChatList,
              //             ),
              //           );
              //         }
              //   return SizedBox(
              //     height: 260.h,
              //     child: Stack(
              //         alignment: Alignment.topCenter,
              //         children: chatlists.map(
              //           (list) {
              //             return Positioned(
              //               right: chatlists.indexOf(list) * 90.w,
              //               child: Container(
              //                 width: 170.w,
              //                 child: StoreListWidget(
              //                     listId: list.id,
              //                     storeImagePath: list['storeImageUrl'],
              //                     listName: list['list_name']),
              //               ),
              //             );
              //           },
              //         ).toList()),
              //   );
              // }),

              FutureBuilder(
                  future: getAllListsFuture,
                  builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var allLists = snapshot.data?.docs ?? [];
                    if (!snapshot.hasData || allLists.isEmpty) {
                      return GestureDetector(
                        onTap: () {
                          AppNavigator.push(
                              context: context, screen: ChatlistsScreen());
                        },
                        child: Image.asset(
                          newChatList,
                          // width: 358.w,
                          // height: 154.h,
                        ),
                      );
                    }
                    return SizedBox(
                      height: 170.h,
                      child: Stack(
                          alignment: Alignment.topCenter,
                          children: allLists.map(
                            (list) {
                              return Positioned(
                                right: allLists.indexOf(list) * 90.w,
                                child: Container(
                                  width: 170.w,
                                  child: StoreListWidget(
                                      listId: list.id,
                                      storeImagePath: list['storeImageUrl'],
                                      listName: list['list_name']),
                                ),
                              );
                            },
                          ).toList()),
                    );
                  }),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.latestBargains.tr(),
                    style: TextStylesDMSans.textViewBold16
                        .copyWith(color: prussian),
                  ),
                  // TextButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       'See all',
                  //       style: textButtonStyle,
                  //     ))
                ],
              ),
              // Container(
              //   height: 200.h,
              //   child: FutureBuilder<int>(
              //       future: getAllProductsFuture,
              //       builder: (context, snapshot) {
              //         if (snapshot.connectionState == ConnectionState.waiting) {
              //           return const Center(
              //             child: CircularProgressIndicator(),
              //           );
              //         }
              //         if (snapshot.data != 200) {
              //           return const Center(
              //             child: Text(
              //                 "Something went wrong. Please try again later"),
              //           );
              //         }
              //         allProducts =
              //             Provider.of<ProductsProvider>(context, listen: false)
              //                 .allProducts;
              //         print("\n RESPONSE: ${allProducts.length}");
              //         return ListView.builder(
              //           itemCount: allProducts.length + 1,
              //           scrollDirection: Axis.horizontal,
              //           itemBuilder: (ctx, i) {
              //             if (i >= allProducts.length) {
              //               var productId = allProducts[i - 1]['id'];
              //               return Padding(
              //                 padding: EdgeInsets.symmetric(horizontal: 32),
              //                 child: isLoading
              //                     ? Center(
              //                         child: CircularProgressIndicator(
              //                         color: verdigris,
              //                       ))
              //                     : Center(
              //                         child: Container(
              //                           decoration: BoxDecoration(
              //                             border:
              //                                 Border.all(color: Colors.grey),
              //                             borderRadius:
              //                                 BorderRadius.circular(12),
              //                           ),
              //                           child: InkWell(
              //                             onTap: () async {
              //                               setState(() {
              //                                 isLoading = true;
              //                               });
              //                               print(productId);
              //                               await fetch(productId + 1);
              //                               setState(() {
              //                                 isLoading = false;
              //                               });
              //                             },
              //                             borderRadius:
              //                                 BorderRadius.circular(12),
              //                             child: Padding(
              //                               padding: const EdgeInsets.all(5),
              //                               child: Row(
              //                                 mainAxisSize: MainAxisSize.min,
              //                                 children: [
              //                                   Text(
              //                                     "See more",
              //                                     style: TextStyles
              //                                         .textViewMedium10
              //                                         .copyWith(
              //                                             color: prussian),
              //                                   ),
              //                                   Icon(
              //                                     Icons.arrow_forward_ios,
              //                                     size: 18,
              //                                     color: Colors.grey,
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //               );
              //             } // see more case
              //             var id = allProducts[i]['id'];
              //             var productName = allProducts[i]['name'];
              //             var imageURL = allProducts[i]['image_url'];
              //             var storeName = allProducts[i]['product_brand'];
              //             var description =
              //                 allProducts[i]['product_description'];
              //             var price1 = allProducts[i]['price_1'];
              //             var price2 = allProducts[i]['price_2'];
              //             var oldPrice = allProducts[i]['befor_offer'];
              //             var size1 = allProducts[i]['unit_size_1'] ?? "";
              //             var size2 = allProducts[i]['unit_size_2'];
              //             return DiscountItem(
              //               onAdd: () => addDiscountItem(context, productName,
              //                   oldPrice, price1, price2, imageURL, size1),
              //               onShare: () => shareDiscountItem(
              //                   context,
              //                   productName,
              //                   oldPrice,
              //                   price1,
              //                   price2,
              //                   imageURL,
              //                   size1),
              //               name: productName,
              //               imageURL: imageURL,
              //               albertPriceAfter: price1 ?? price2,
              //               measurement: size1 ?? size2,
              //               jumboPriceAfter: '0.0',
              //             );
              //           },
              //         );
              //       }),
              // ),
              Container(
                height: 220.h,
                child: Consumer<ProductsProvider>(
                  builder: (ctx,provider,_){
                    var comparisonProducts = provider.comparisonProducts;
                    if(comparisonProducts.isEmpty) return Center(child: CircularProgressIndicator(),);
                    return ListView.builder(
                      itemCount: comparisonProducts.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        // if (i >= comparisonProducts.length) {
                        //   var productId = comparisonProducts[i-1].id;
                        //   return Padding(
                        //     padding: EdgeInsets.symmetric(horizontal: 32),
                        //     child: isLoading
                        //         ? Center(
                        //         child: CircularProgressIndicator(
                        //           color: verdigris,
                        //         ))
                        //         : Center(
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //           border:
                        //           Border.all(color: Colors.grey),
                        //           borderRadius:
                        //           BorderRadius.circular(12),
                        //         ),
                        //         child: InkWell(
                        //           onTap: () async {
                        //             setState(() {
                        //               isLoading = true;
                        //             });
                        //             print(productId);
                        //             await fetch(productId + 1);
                        //             setState(() {
                        //               isLoading = false;
                        //             });
                        //           },
                        //           borderRadius:
                        //           BorderRadius.circular(12),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(5),
                        //             child: Row(
                        //               mainAxisSize: MainAxisSize.min,
                        //               children: [
                        //                 Text(
                        //                   "See more",
                        //                   style: TextStyles
                        //                       .textViewMedium10
                        //                       .copyWith(
                        //                       color: prussian),
                        //                 ),
                        //                 Icon(
                        //                   Icons.arrow_forward_ios,
                        //                   size: 18,
                        //                   color: Colors.grey,
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // } // see more case
                        return DiscountItem(
                          comparisonProduct: comparisonProducts[i],
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Latest Value Bargains",
                    style: TextStylesDMSans.textViewBold16
                        .copyWith(color: prussian),
                  ),
                  // TextButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       'See all',
                  //       style: textButtonStyle,
                  //     ))
                ],
              ),
              Container(
                height: 150.h,
                child: Consumer<ProductsProvider>(
                    builder: (context, provider,_) {
                      bestValueBargains = provider.bestValueBargains;
                      print(bestValueBargains.length);
                      // print(bestValueBargains.length);
                      return ListView(
                          scrollDirection: Axis.horizontal,
                          children: bestValueBargains.map((bargain) {
                            return GestureDetector(
                              onTap: () {
                                AppNavigator.push(
                                    context: context,
                                    screen: ProductDetailScreen(
                                      comparisonId: -1,
                                      productId: bargain.itemId,
                                      storeName: bargain.store,
                                      productName: bargain.itemName,
                                      imageURL: bargain.itemImage,
                                      description: bargain.description,
                                      price1:
                                          double.tryParse(bargain.price1) ?? 0,
                                      price2:
                                          double.tryParse(bargain.price2) ?? 0,
                                      oldPrice: bargain.oldPrice,
                                      size1: bargain.size1,
                                      size2: bargain.size2,
                                    ));
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  boxShadow: Utils.boxShadow,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Image.network(
                                      bargain.itemImage,
                                      width: 50,
                                      height: 50,
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bargain.bestValueSize,
                                          style: TextStyles.textViewSemiBold16,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          "\€" +
                                              (bargain.bestValueSize ==
                                                      bargain.size1
                                                  ? bargain.price1
                                                  : bargain
                                                      .price2), //should be the best price
                                          style: TextStyles.textViewMedium12
                                              .copyWith(
                                                  color: const Color.fromRGBO(
                                                      108, 197, 29, 1)),
                                        ),
                                        SizedBox(
                                          height: 5.w,
                                        ),
                                        Text(
                                          bargain.subCategory,
                                          style: TextStyles.textViewRegular12
                                              .copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList());
                    }),
              ),
              10.ph,
            ],
          ),
        ),
      ),
    );
  }


  Future fetch(int startingIndex) {
    return Provider.of<ProductsProvider>(context, listen: false)
        .getProducts(startingIndex);
  }
}

class MySearchDelegate extends SearchDelegate {
  final SharedPreferences pref;

  MySearchDelegate(this.pref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      GestureDetector(
        onTap: () {
          query = '';
        },
        child: Container(
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: grey)),
            child: Icon(
              Icons.close,
              color: Colors.black,
            )),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) saveRecentSearches();
    // List allProducts =
    //     Provider.of<ProductsProvider>(context, listen: false).allProducts;
    // var searchResults = allProducts
    //     .where((product) => product['Name'].toString().contains(query))
    //     .toList();
    return FutureBuilder<List<Product>>(
        future: Provider.of<ProductsProvider>(context,listen: false).searchProducts(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(
              child: CircularProgressIndicator(),
            );
          if (!snapshot.hasData || snapshot.hasError)
            return const Center(
              child: Text("Something went wrong please try again"),
            );
          var searchResults = snapshot.data ?? [];
          if (searchResults.isEmpty)
            return const Center(
              child: Text("No matches found :("),
            );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (ctx, i) {
                var id = searchResults[i].id;
                var productName = searchResults[i].name;
                var imageURL = searchResults[i].imageURL;
                var storeName = searchResults[i].storeName;
                var description = searchResults[i].description;
                var price1 = searchResults[i].price;
                var price2 = searchResults[i].price2 ?? '';
                var oldPrice = searchResults[i].oldPrice;
                var size1 = searchResults[i].size ?? "";
                var size2 = searchResults[i].size2 ?? "";
                return GestureDetector(
                  onTap: () => AppNavigator.push(
                      context: context,
                      screen: ProductDetailScreen(
                        comparisonId: -1,
                        productId: id,
                        oldPrice: oldPrice,
                        storeName: storeName,
                        productName: productName,
                        imageURL: imageURL,
                        description: description,
                        size1: size1,
                        size2: size2,
                        price1: double.tryParse(price1) ?? 0.0,
                        price2: double.tryParse(price2) ?? 0.0,
                      )),
                  child: SearchItem(
                    name: productName,
                    imageURL: imageURL,
                    currentPrice: price1,
                    size: size1,
                    store: storeName,
                  ),
                );
              },
            ),
          );
        });
  }

  void saveRecentSearches() {
    var recentSearches = pref.getStringList('recentSearches') ?? [];
    if (recentSearches.contains(query)) return;
    recentSearches.add(query);
    pref.setStringList('recentSearches', recentSearches);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> searchResults = pref.getStringList('recentSearches') ?? [];

    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.recentSearches.tr(),
            style: TextStyles.textViewMedium20.copyWith(color: gunmetal),
          ),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (ctx, i) => const Divider(),
                itemCount: suggestions.length,
                itemBuilder: (ctx, i) {
                  final suggestion = suggestions[i];
                  return ListTile(
                    title: Text(suggestion),
                    leading: Icon(Icons.search),
                    onTap: () {
                      query = suggestion;
                      showResults(context);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

// Container(
//   height: 100.h,
//   child: ListView(
//     scrollDirection: Axis.horizontal,
//     children: [
//       CategoryWidget(
//         categoryImagePath: vegetables,
//         categoryName: LocaleKeys.vegetables.tr(),
//         color: Colors.green,
//       ),
//       CategoryWidget(
//         categoryImagePath: fruits,
//         categoryName: LocaleKeys.fruits.tr(),
//         color: Colors.red,
//       ),
//       CategoryWidget(
//         categoryImagePath: beverages,
//         categoryName: LocaleKeys.beverages.tr(),
//         color: Colors.yellow,
//       ),
//       CategoryWidget(
//         categoryImagePath: grocery,
//         categoryName: LocaleKeys.grocery.tr(),
//         color: Colors.deepPurpleAccent,
//       ),
//       CategoryWidget(
//         categoryImagePath: edibleOil,
//         categoryName: LocaleKeys.edibleOil.tr(),
//         color: Colors.cyan,
//       ),
//     ],
//   ),
// ),
