import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/providers/products_provider.dart';
import 'package:swaav/services/network_services.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/generic_field.dart';
import 'package:swaav/view/screens/choose_store_screen.dart';
import 'package:swaav/view/screens/chatlists_screen.dart';
import 'package:swaav/view/widgets/chat_view_widget.dart';
import 'package:swaav/view/screens/product_detail_screen.dart';
import 'package:swaav/view/screens/register_screen.dart';
import 'package:swaav/view/widgets/category_widget.dart';
import 'package:swaav/view/widgets/discountItem.dart';
import 'package:swaav/view/widgets/product_item.dart';
import 'package:swaav/view/widgets/search_item.dart';

import '../../config/routes/app_navigator.dart';
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
  late Future<int> getAllProductsFuture;
  late Future<QuerySnapshot> getAllListsFuture;
  List allProducts = [];

  var isLoading = false;
  TextStyle textButtonStyle =
      TextStylesInter.textViewRegular16.copyWith(color: mainPurple);
  @override
  void initState() {
    super.initState();
    getAllListsFuture = FirebaseFirestore.instance
        .collection('/lists')
        .where("userIds", arrayContains: FirebaseAuth.instance.currentUser?.uid)
        .get();
    getUserDataFuture = FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    DynamicLinkService().listenToDynamicLinks(
        context); //case 2 the app is open but in background and opened again via deep link
  }

  @override
  void didChangeDependencies() {
    getAllProductsFuture =
        Provider.of<ProductsProvider>(context, listen: false).getProducts(0);
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
                        return snapshot.data!['imageURL'] != ""
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(snapshot.data!['imageURL']),
                                radius: 30,
                              )
                            : SvgPicture.asset(personIcon);
                      }),
                  // GenericButton(
                  //     onPressed: () async {
                  //       var pref = await SharedPreferences.getInstance();
                  //       pref.setBool("rememberMe", false);
                  //       var isGoogleSignedIn =
                  //           await Provider.of<GoogleSignInProvider>(context,
                  //                   listen: false)
                  //               .googleSignIn
                  //               .isSignedIn();
                  //       if (isGoogleSignedIn) {
                  //         await Provider.of<GoogleSignInProvider>(context,
                  //                 listen: false)
                  //             .logout();
                  //       } else {
                  //         FirebaseAuth.instance.signOut();
                  //       }
                  //       AppNavigator.pushReplacement(
                  //           context: context, screen: RegisterScreen());
                  //       print("SIGNED OUT...................");
                  //     },
                  //     borderRadius: BorderRadius.circular(10),
                  //     height: 31.h,
                  //     width: 100.w,
                  //     child: Text(
                  //       "Log out",
                  //       style: TextStyles.textViewBold12,
                  //     )),
                ],
              ),
              SizedBox(
                height: 24.h,
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
                height: 15.h,
              ),
              // SizedBox(
              //   height: 30.h,
              // ),
              // Text(
              //   LocaleKeys.recentSearches.tr(),
              //   style:
              //       TextStylesDMSans.textViewBold16.copyWith(color: prussian),
              // ),
              // SizedBox(
              //   height: 10.h,
              // ),
              // Container(
              //   height: 260.h,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       ProductItemWidget(
              //         price: "8.00",
              //         fullPrice: "1.55",
              //         name: "Fresh Peach",
              //         description: "dozen",
              //         imagePath: peach,
              //         onTap: () {},
              //       ),
              //       ProductItemWidget(
              //           onTap: () {},
              //           price: "8.00",
              //           fullPrice: "1.55",
              //           name: "Fresh Peach",
              //           description: "dozen",
              //           imagePath: peach),
              //       ProductItemWidget(
              //           onTap: () {},
              //           price: "8.00",
              //           fullPrice: "1.55",
              //           name: "Fresh Peach",
              //           description: "dozen",
              //           imagePath: peach),
              //     ],
              //   ),
              // ),
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
                        onTap: (){
                          AppNavigator.push(context: context, screen: ChatlistsScreen());
                        },
                        child: Image.asset(
                          newChatList,
                          // width: 358.w,
                          // height: 154.h,
                        ),
                      );
                    }
                    return SizedBox(
                      height: 260.h,
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
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.latestBargains.tr(),
                    style:
                        TextStylesDMSans.textViewBold16.copyWith(color: prussian),
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
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 250.h,
                child: FutureBuilder<int>(
                    future: getAllProductsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data != 200) {
                        return const Center(
                          child: Text(
                              "Something went wrong. Please try again later"),
                        );
                      }
                      allProducts =
                          Provider.of<ProductsProvider>(context, listen: false)
                              .allProducts;
                      print("\n RESPONSE: ${allProducts.length}");
                      return ListView.builder(
                        itemCount: allProducts.length + 1,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          if (i >= allProducts.length) {
                            var productId = allProducts[i - 1]['id'];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: verdigris,
                                    ))
                                  : Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            print(productId);
                                            await fetch(productId + 1);
                                            setState(() {
                                              isLoading = false;
                                            });
                                          },
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "See more",
                                                  style: TextStyles
                                                      .textViewMedium10
                                                      .copyWith(
                                                          color: prussian),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 18,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            );
                          }
                          var productName = allProducts[i]['Name'];
                          var imageURL = allProducts[i]['Image_url'];
                          var storeName = allProducts[i]['Store'];
                          var description = allProducts[i]['Description'];
                          var price = allProducts[i]['Current_price'];
                          var oldPrice = allProducts[i]['Old_price'];
                          var size = allProducts[i]['Size'];
                          return GestureDetector(
                            onTap: () => AppNavigator.push(
                                context: context,
                                screen: ProductDetailScreen(
                                  storeName: storeName,
                                  productName: productName,
                                  imageURL: imageURL,
                                  description: description,
                                  price: price.runtimeType == int ? price.toDouble() : price,
                                  size: size,
                                    oldPrice: oldPrice
                                )),
                            child: DiscountItem(
                              onShare: (){},
                                name: allProducts[i]['Name'],
                                imageURL: allProducts[i]['Image_url'],
                                albertPriceBefore: allProducts[i]['Old_price'].toString().isEmpty ? null : allProducts[i]['Old_price'],
                                albertPriceAfter:
                                    allProducts[i]['Current_price'].toString(),
                                measurement: allProducts[i]['Size'], sparPriceAfter: '0.0', jumboPriceAfter: '0.0',),
                          );
                        },
                      );
                    }),
              ),
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
    return FutureBuilder<Response>(
        future: NetworkServices.searchProducts(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.data?.statusCode != 200)
            return const Center(
              child: Text("Something went wrong please try again"),
            );
          var searchResults = jsonDecode(snapshot.data?.body as String);
          if (searchResults.isEmpty)
            return const Center(
              child: Text("No matches found :("),
            );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (ctx, i) {
                var productName = searchResults[i]['Name'];
                var imageURL = searchResults[i]['Image_url'];
                var storeName = searchResults[i]['Store'];
                var description = searchResults[i]['Description'];
                var price = searchResults[i]['Current_price'];
                var oldPrice = searchResults[i]['Old_price'];
                var size = searchResults[i]['Size'];
                return GestureDetector(
                  onTap: () => AppNavigator.push(
                      context: context,
                      screen: ProductDetailScreen(
                        oldPrice: oldPrice,
                        storeName: storeName,
                        productName: productName,
                        imageURL: imageURL,
                        description: description,
                        price: price,
                        size: size,
                      )),
                  child: SearchItem(
                    name: searchResults[i]['Name'],
                    imageURL: searchResults[i]['Image_url'],
                    currentPrice: searchResults[i]['Current_price'].toString(),
                    size: searchResults[i]['Size'],
                    store: searchResults[i]['Store'],
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
