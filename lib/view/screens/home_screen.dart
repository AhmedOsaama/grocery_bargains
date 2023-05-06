import 'dart:developer';

import 'package:bargainb/models/bestValue_item.dart';
import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/view/components/chatlist_swiper.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/screens/chatlists_screen.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/widgets/store_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/utils/utils.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/screens/product_detail_screen.dart';

import '../../config/routes/app_navigator.dart';
import '../../services/dynamic_link_service.dart';
import '../../utils/assets_manager.dart';
import '../../utils/icons_manager.dart';
import '../widgets/discountItem.dart';
import 'latest_bargains_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PagingController<int, ComparisonProduct> _pagingController =
      PagingController(firstPageKey: 0);
  static const _pageSize = 5;

  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  // late Future<int> getAllProductsFuture;
  late Future<QuerySnapshot> getAllListsFuture;
  // late Future<List<BestValueItem>> getAllValueBargainsFuture;
  List allProducts = [];

  var isLoading = false;
  TextStyle textButtonStyle =
      TextStylesInter.textViewRegular16.copyWith(color: mainPurple);

  List<BestValueItem> bestValueBargains = [];
  int startingIndex = 0;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
    getAllListsFuture = Provider.of<ChatlistsProvider>(context, listen: false)
        .getAllChatlistsFuture();
    // getAllValueBargainsFuture =
    //     Provider.of<ProductsProvider>(context, listen: false)
    //         .populateBestValueBargains();
    if (FirebaseAuth.instance.currentUser != null) {
      getUserDataFuture = FirebaseFirestore.instance
          .collection('/users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
    }
    DynamicLinkService().listenToDynamicLinks(
        context); //case 2 the app is open but in background and opened again via deep link
    // WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      print("PAGE KEY: " + pageKey.toString());
      if (pageKey > 0) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .getLimitedPriceComparisons(pageKey);
      }
      final newProducts = Provider.of<ProductsProvider>(context, listen: false)
          .comparisonProducts;

      final isLastPage = newProducts.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newProducts);
      } else {
        int nextPageKey = pageKey + newProducts.length;
        _pagingController.appendPage(newProducts, nextPageKey);
      }
      startingIndex++;
    } catch (error) {
      _pagingController.error = "Something wrong ! Please try again";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            getAllListsFuture =
                Provider.of<ChatlistsProvider>(context, listen: false)
                    .getAllChatlistsFuture();
            if (FirebaseAuth.instance.currentUser != null) {
              getUserDataFuture = FirebaseFirestore.instance
                  .collection('/users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get();
            }
          });
          return Future.value();
        },
        child: SingleChildScrollView(
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
                          } else if (snapshot.hasData) {
                            if (!snapshot.data!
                                .data()!
                                .containsKey("privacy")) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                'language': 'en',
                                'status':
                                    "Hello! I'm using BargainB. Join the app",
                                'privacy': {
                                  'connectContacts': true,
                                  'locationServices': false,
                                },
                                'preferences': {
                                  'emailMarketing': true,
                                  'weekly': true,
                                  'daily': false,
                                },
                              });
                            }
                            return Text(
                              style: TextStylesInter.textViewSemiBold24
                                  .copyWith(color: mainPurple),
                              '${'Hello, ' + snapshot.data!['username']}!',
                            );
                          } else {
                            return Text(
                              style: TextStylesInter.textViewSemiBold24
                                  .copyWith(color: mainPurple),
                              'Hello, Guest!',
                            );
                          }
                        }),
                    FutureBuilder(
                        future: getUserDataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return Container();
                          }

                          return snapshot.data!['imageURL'] != ""
                              ? GestureDetector(
                                  onTap: () async {
                                    NavigatorController.jumpToTab(2);
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        snapshot.data!['imageURL']),
                                    radius: 30,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    NavigatorController.jumpToTab(2);
                                  },
                                  child: SvgPicture.asset(bee));
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
                        context: context,
                        delegate: MySearchDelegate(pref, true));
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
                        onPressed: () {
                          Provider.of<ChatlistsProvider>(context, listen: false)
                              .chatlistsView = ChatlistsView.LISTVIEW;
                          Provider.of<ChatlistsProvider>(context, listen: false)
                              .notifyListeners();
                          NavigatorController.jumpToTab(1);
                        },
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
                      if (!snapshot.hasData ||
                          allLists.isEmpty ||
                          FirebaseAuth.instance.currentUser == null) {
                        return GestureDetector(
                          onTap: () {
                            NavigatorController.jumpToTab(1);
                          },
                          child: Image.asset(
                            newChatList,
                            // width: 358.w,
                            // height: 154.h,
                          ),
                        );
                      }

                      List<String> ids = [];
                      allLists.forEach(
                        (element) {
                          log(element.data().toString());
                          ids.add(element.id);
                        },
                      );
                      return SizedBox(
                        height: 190.h,
                        width: double.infinity,
                        child: ChatlistSwiper.builder(
                          itemCount: allLists.length,
                          ids: ids,
                          aspectRatio: 1,
                          depthFactor: 0.7,
                          dx: 130,
                          dy: 0,
                          paddingStart: 0,
                          verticalPadding: 0,
                          visiblePageCount: allLists.length,
                          widgetBuilder: (index) {
                            return Container(
                              child: StoreListWidget(
                                  listId: allLists.elementAt(index).id,
                                  storeImagePath: allLists
                                      .elementAt(index)['storeImageUrl'],
                                  listName:
                                      allLists.elementAt(index)['list_name']),
                            );
                          },
                        ),
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
                    TextButton(
                        onPressed: () => AppNavigator.push(
                            context: context, screen: LatestBargainsScreen()),
                        child: Text(
                          'See all',
                          style: textButtonStyle,
                        ))
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 250.h,
                  child: Row(
                    children: [
                      5.pw,
                      Flexible(
                        child: Consumer<ProductsProvider>(
                          builder: (ctx, provider, _) {
                            var comparisonProducts =
                                provider.comparisonProducts;
                            if (comparisonProducts.isEmpty) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return PagedListView<int, ComparisonProduct>(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                pagingController: _pagingController,
                                builderDelegate: PagedChildBuilderDelegate<
                                        ComparisonProduct>(
                                    itemBuilder: (context, item, index) => Row(
                                          children: [
                                            DiscountItem(
                                              inGridView: false,
                                              comparisonProduct: item,
                                            ),
                                            10.pw
                                          ],
                                        )),
                              );
                            }

                            /*    return ListView.builder(
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
                            ); */
                          },
                        ),
                      ),
                    ],
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
                      builder: (context, provider, _) {
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
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

/*   Future fetch(int startingIndex) {
    return Provider.of<ProductsProvider>(context, listen: false)
        .getProducts(startingIndex);
  } */
}
