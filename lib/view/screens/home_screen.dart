import 'dart:developer';

import 'package:bargainb/models/bestValue_item.dart';
import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/utils/down_triangle_painter.dart';
import 'package:bargainb/utils/tooltips_keys.dart';
import 'package:bargainb/utils/triangle_painter.dart';
import 'package:bargainb/view/components/chatlist_swiper.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/screens/all_categories_screen.dart';
import 'package:bargainb/view/screens/categories_screen.dart';
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/chatlists_screen.dart';
import 'package:bargainb/view/screens/latest_bargains_screen.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/widgets/store_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/screens/product_detail_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../config/routes/app_navigator.dart';
import '../../services/dynamic_link_service.dart';
import '../../utils/assets_manager.dart';
import '../../utils/icons_manager.dart';
import '../widgets/discountItem.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PagingController<int, ComparisonProduct> _pagingController =
      PagingController(firstPageKey: 0);
  static const _pageSize = 10000000;

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
  bool isHomeFirstTime = false;
  bool dialogOpened = false;
  Future<Null> getFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isHomeFirstTime = prefs.getBool("firstTime") ?? true;
    });
  }

  Future<Null> turnOffFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("firstTime", false);
      isHomeFirstTime = false;
    });
  }

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

    getFirstTime();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      print("PAGE KEY: " + pageKey.toString());
      if (pageKey > 0) {
        // await Provider.of<ProductsProvider>(context, listen: false)
        //     .getLimitedProducts(pageKey);
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
    return ShowCaseWidget(
      builder: Builder(builder: (builder) {
        if (isHomeFirstTime && !dialogOpened) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showWelcomeDialog(context, builder);
          });
          dialogOpened = true;
        }
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: white,
          bottomSheet: Showcase.withWidget(
            key: isHomeFirstTime
                ? TooltipKeys.showCase1
                : new GlobalKey<State<StatefulWidget>>(),
            container: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  //margin: EdgeInsets.symmetric(vertical: 30.w),
                  width: 180.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: purple70,
                  ),
                  child: Column(children: [
                    Text(
                      "UseOurNavigation".tr(),
                      maxLines: 4,
                      style:
                          TextStyles.textViewRegular13.copyWith(color: white),
                    ),
                    GestureDetector(
                      onTap: () {
                        ShowCaseWidget.of(builder).next();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            LocaleKeys.next.tr(),
                            style: TextStyles.textViewSemiBold14
                                .copyWith(color: white),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: white,
                            size: 15.sp,
                          )
                        ],
                      ),
                    )
                  ]),
                ),
                Container(
                  height: 11,
                  width: 13,
                  child: CustomPaint(
                    painter: DownTrianglePainter(
                      strokeColor: purple70,
                      strokeWidth: 1,
                      paintingStyle: PaintingStyle.fill,
                    ),
                  ),
                ),
              ],
            ),
            height: 110.h,
            width: 190.h,
            child: Container(
              height: 0,
              color: Colors.transparent,
            ),
          ),
          body: SafeArea(
            child: Container(
              /*  decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment(0, 0.2),
                end: Alignment.bottomCenter,
                //stops: [0.5, 0.7, 0.9, 1],
                colors: [white, shadowColor, shadowColor],
              )), */
              child: RefreshIndicator(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                                future: getUserDataFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(child: Container());
                                  } else if (snapshot.hasData) {
                                    if (!snapshot.data!
                                        .data()!
                                        .containsKey("privacy")) {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
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
                                      'HelloGuest'.tr(),
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
                                          onTap: () {
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
                        Showcase.withWidget(
                          targetBorderRadius: BorderRadius.circular(999),
                          key: isHomeFirstTime
                              ? TooltipKeys.showCase2
                              : new GlobalKey<State<StatefulWidget>>(),
                          container: Container(
                            child: Column(
                              children: [
                                Container(
                                  height: 11,
                                  width: 13,
                                  child: CustomPaint(
                                    painter: TrianglePainter(
                                      strokeColor: purple70,
                                      strokeWidth: 1,
                                      paintingStyle: PaintingStyle.fill,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(15),
                                  width: 180.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: purple70,
                                  ),
                                  child: Column(children: [
                                    Text(
                                      "ItIsSmartSearch".tr(),
                                      maxLines: 4,
                                      style: TextStyles.textViewRegular13
                                          .copyWith(color: white),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        ShowCaseWidget.of(builder).next();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Next".tr(),
                                            style: TextStyles.textViewSemiBold14
                                                .copyWith(color: white),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: white,
                                            size: 15.sp,
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          height: 50,
                          width: 50,
                          child: GenericField(
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
                            hintStyle: TextStyles.textViewSemiBold14
                                .copyWith(color: gunmetal),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "allCategories".tr(),
                              style: TextStylesDMSans.textViewBold16
                                  .copyWith(color: prussian),
                            ),
                            TextButton(
                                onPressed: () {
                                  pushNewScreen(context,
                                      screen: AllCategoriesScreen(),
                                      withNavBar: true);
                                },
                                child: Text(
                                  'seeAll'.tr(),
                                  style: textButtonStyle,
                                ))
                          ],
                        ),
                        Provider.of<ProductsProvider>(context, listen: true)
                                .categories
                                .isEmpty
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                height: ScreenUtil().screenHeight * 0.14,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: Provider.of<ProductsProvider>(
                                            context,
                                            listen: true)
                                        .categories
                                        .map((element) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: Provider.of<ProductsProvider>(
                                                          context,
                                                          listen: true)
                                                      .categories
                                                      .first ==
                                                  element
                                              ? 0
                                              : 10.0,
                                        ),
                                        child: GestureDetector(
                                          onTap: () => pushNewScreen(context,
                                              screen: CategoriesScreen(
                                                category: element.category,
                                              ),
                                              withNavBar: true),
                                          child: SizedBox(
                                            width: 71.w,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  element.image,
                                                  width: 65.w,
                                                  height: 65.h,
                                                ),
                                                Text(
                                                  context.locale.languageCode !=
                                                          "nl"
                                                      ? element.englishCategory
                                                      : element.category,
                                                  style: TextStyles
                                                      .textViewMedium10
                                                      .copyWith(
                                                          color: gunmetal),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 3,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList()),
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
                                  Provider.of<ChatlistsProvider>(context,
                                          listen: false)
                                      .chatlistsView = ChatlistsView.LISTVIEW;
                                  Provider.of<ChatlistsProvider>(context,
                                          listen: false)
                                      .notifyListeners();
                                  NavigatorController.jumpToTab(1);
                                },
                                child: Text(
                                  'seeAll'.tr(),
                                  style: textButtonStyle,
                                ))
                          ],
                        ),
                        Showcase.withWidget(
                          key: isHomeFirstTime
                              ? TooltipKeys.showCase3
                              : new GlobalKey<State<StatefulWidget>>(),
                          targetBorderRadius: BorderRadius.circular(8.r),
                          tooltipPosition: TooltipPosition.top,
                          onBarrierClick: () async {
                            await addRandomProduct(builder);
                          },
                          onTargetClick: () async {
                            await addRandomProduct(builder);
                          },
                          onTargetDoubleTap: () async {
                            await addRandomProduct(builder);
                          },
                          container: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                width: ScreenUtil().screenWidth * 0.95,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: purple70,
                                ),
                                child: Column(children: [
                                  Text(
                                    "StartHereTo".tr(),
                                    maxLines: 4,
                                    style: TextStyles.textViewRegular13
                                        .copyWith(color: white),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(personAva),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 5),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight:
                                                    const Radius.circular(18),
                                                topLeft:
                                                    const Radius.circular(18),
                                                bottomLeft:
                                                    const Radius.circular(0),
                                                bottomRight:
                                                    const Radius.circular(18),
                                              ),
                                              color: const Color.fromRGBO(
                                                  233, 233, 235, 1),
                                            ),
                                            child: Text(
                                              "Got any ideas for the plan",
                                              style: TextStyles
                                                  .textViewRegular16
                                                  .copyWith(
                                                      color: Colors.black),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          SvgPicture.asset(whiteAdd),
                                          Text(
                                            "  Add to list",
                                            style: TextStyles.textViewRegular10
                                                .copyWith(color: white),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Read 10:02",
                                        style: TextStyles.textViewRegular10
                                            .copyWith(color: white),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await addRandomProduct(builder);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Next",
                                          style: TextStyles.textViewSemiBold14
                                              .copyWith(color: white),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: white,
                                          size: 15.sp,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                              Container(
                                height: 11,
                                width: 13,
                                child: CustomPaint(
                                  painter: DownTrianglePainter(
                                    strokeColor: purple70,
                                    strokeWidth: 1,
                                    paintingStyle: PaintingStyle.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height: 110.h,
                          width: ScreenUtil().screenWidth * 0.95,
                          child: FutureBuilder(
                              future: getAllListsFuture,
                              builder:
                                  (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Shimmer(
                                      duration: Duration(seconds: 2),
                                      colorOpacity: 0.7,
                                      child: Container(
                                        height: 190.h,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: purple10,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Color.fromRGBO(
                                                  222, 222, 222, 1),
                                              width: 0.5),
                                        ),
                                      ));
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
                                            listId:
                                                allLists.elementAt(index).id,
                                            storeImagePath: allLists.elementAt(
                                                index)['storeImageUrl'],
                                            listName: allLists
                                                .elementAt(index)['list_name']),
                                      );
                                    },
                                  ),
                                );
                              }),
                        ),
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
                                onPressed: () {
                                  AppNavigator.push(
                                      context: context,
                                      screen: LatestBargainsScreen());
                                },
                                child: Text(
                                  'seeAll'.tr(),
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
                                    if (comparisonProducts.isEmpty ||
                                        provider.albertProducts.isEmpty ||
                                        provider.jumboProducts.isEmpty ||
                                        provider.hoogvlietProducts.isEmpty) {
                                      return Container(
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: List<Widget>.generate(
                                              20,
                                              (index) => Shimmer(
                                                    duration:
                                                        Duration(seconds: 2),
                                                    colorOpacity: 0.7,
                                                    child: Container(
                                                      height: 253.h,
                                                      width: 174.w,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 5),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.w),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: purple10,
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      );
                                    } else {
                                      return PagedListView<int,
                                          ComparisonProduct>(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        pagingController: _pagingController,
                                        builderDelegate:
                                            PagedChildBuilderDelegate<
                                                    ComparisonProduct>(
                                                itemBuilder:
                                                    (context, item, index) =>
                                                        Row(
                                                          children: [
                                                            DiscountItem(
                                                              inGridView: false,
                                                              comparisonProduct:
                                                                  item,
                                                            ),
                                                            10.pw
                                                          ],
                                                        )),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "latestValueBargains".tr(),
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
                            if (bestValueBargains.isEmpty) {
                              return Container(
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: List<Widget>.generate(
                                      20,
                                      (index) => Shimmer(
                                            duration: Duration(seconds: 2),
                                            colorOpacity: 0.7,
                                            child: Container(
                                              height: 87.h,
                                              width: 172.w,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 5),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: purple10,
                                              ),
                                            ),
                                          )),
                                ),
                              );
                            }
                            return Container(
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: bestValueBargains.map((bargain) {
                                    return GestureDetector(
                                      onTap: () {
                                        AppNavigator.push(
                                            context: context,
                                            screen: ProductDetailScreen(
                                              productId: bargain.itemId,
                                              productBrand: '',
                                              storeName: bargain.store,
                                              productName: bargain.itemName,
                                              imageURL: bargain.itemImage,
                                              description: bargain.description,
                                              price1: double.tryParse(
                                                      bargain.price1) ??
                                                  0,
                                              price2: double.tryParse(
                                                      bargain.price2) ??
                                                  0,
                                              oldPrice: bargain.oldPrice,
                                              size1: bargain.size1,
                                              size2: bargain.size2,
                                            ));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: shadowColor,
                                                blurRadius: 10,
                                                offset: Offset(0, -1),
                                                blurStyle: BlurStyle.solid),
                                            BoxShadow(
                                                color: shadowColor,
                                                blurRadius: 10,
                                                offset: Offset(0, 5),
                                                blurStyle: BlurStyle.solid),
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                  style: TextStyles
                                                      .textViewSemiBold16,
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
                                                  style: TextStyles
                                                      .textViewMedium12
                                                      .copyWith(
                                                          color: const Color
                                                                  .fromRGBO(
                                                              108, 197, 29, 1)),
                                                ),
                                                SizedBox(
                                                  height: 5.w,
                                                ),
                                                Text(
                                                  bargain.subCategory,
                                                  style: TextStyles
                                                      .textViewRegular12
                                                      .copyWith(
                                                          color: Colors.grey),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList()),
                            );
                          }),
                        ),
                        10.ph,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future addRandomProduct(BuildContext builder) async {
    var id = await Provider.of<ChatlistsProvider>(context, listen: false)
        .createChatList([]);
    await Provider.of<ChatlistsProvider>(context, listen: false)
        .shareItemAsMessage(
            itemDescription:
                Provider.of<
                        ProductsProvider>(context, listen: false)
                    .hoogvlietProducts
                    .elementAt(20)
                    .description,
            storeName:
                Provider.of<
                        ProductsProvider>(context, listen: false)
                    .hoogvlietProducts
                    .elementAt(20)
                    .storeName,
            itemId:
                Provider.of<
                        ProductsProvider>(context, listen: false)
                    .hoogvlietProducts
                    .elementAt(20)
                    .id,
            itemName:
                Provider.of<
                        ProductsProvider>(context, listen: false)
                    .hoogvlietProducts
                    .elementAt(20)
                    .name,
            itemImage:
                Provider.of<
                        ProductsProvider>(context, listen: false)
                    .hoogvlietProducts
                    .elementAt(20)
                    .imageURL,
            itemSize:
                Provider.of<
                        ProductsProvider>(context, listen: false)
                    .hoogvlietProducts
                    .elementAt(20)
                    .size,
            itemPrice:
                Provider.of<ProductsProvider>(context, listen: false)
                    .hoogvlietProducts
                    .elementAt(20)
                    .price,
            itemOldPrice: Provider.of<ProductsProvider>(context, listen: false)
                .hoogvlietProducts
                .elementAt(20)
                .oldPrice,
            listId: id);
    setState(() {
      isHomeFirstTime = false;
    });
    await pushNewScreen(context,
        screen: ChatListViewScreen(
          listId: id,
        ),
        withNavBar: false);

    NavigatorController.jumpToTab(1);
    ShowCaseWidget.of(builder).next();
    return Future.value();
  }

  Future<dynamic> showWelcomeDialog(
      BuildContext context, BuildContext builder) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(15),
              width: ScreenUtil().screenWidth * 0.95,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: purple70,
              ),
              child: Column(children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.welcome.tr() + "!",
                        style: TextStyles.textViewSemiBold24
                            .copyWith(color: white),
                      ),
                      GestureDetector(
                          onTap: () {
                            AppNavigator.pop(context: context);
                            turnOffFirstTime();
                          },
                          child: SvgPicture.asset(closeCircle))
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    "QuickTuto".tr(),
                    maxLines: 4,
                    style: TextStyles.textViewRegular13.copyWith(color: white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AppNavigator.pop(context: context);
                    try {
                      ShowCaseWidget.of(builder).startShowCase([
                        TooltipKeys.showCase1,
                        TooltipKeys.showCase2,
                        TooltipKeys.showCase3
                      ]);
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        LocaleKeys.next.tr(),
                        style: TextStyles.textViewSemiBold14
                            .copyWith(color: white),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: white,
                        size: 15.sp,
                      )
                    ],
                  ),
                )
              ]),
            ),
          );
        });
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
