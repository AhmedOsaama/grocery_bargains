import 'dart:async';
import 'dart:developer';

import 'package:bargainb/models/bestValue_item.dart';
import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/providers/tutorial_provider.dart';
import 'package:bargainb/providers/user_provider.dart';
import 'package:bargainb/utils/down_triangle_painter.dart';
import 'package:bargainb/utils/tooltips_keys.dart';
import 'package:bargainb/utils/triangle_painter.dart';
import 'package:bargainb/view/components/chatlist_swiper.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/components/search_widget.dart';
import 'package:bargainb/view/screens/all_categories_screen.dart';
import 'package:bargainb/view/screens/category_screen.dart';
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
import 'package:translator/translator.dart';

import '../../config/routes/app_navigator.dart';
import '../../models/product.dart';
import '../../services/dynamic_link_service.dart';
import '../../utils/assets_manager.dart';
import '../../utils/icons_manager.dart';
import '../../utils/tracking_utils.dart';
import '../components/button.dart';
import '../widgets/discountItem.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 0);
  static const _pageSize = 100;
  var _pageNumber = 1;

  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  // late Future<int> getAllProductsFuture;
  late Future<QuerySnapshot> getAllListsFuture;
  // late Future<List<BestValueItem>> getAllValueBargainsFuture;
  List allProducts = [];

  var isLoading = false;
  TextStyle textButtonStyle = TextStylesInter.textViewRegular16.copyWith(color: mainPurple);

  List<BestValueItem> bestValueBargains = [];
  // int startingIndex = 0;
  bool dialogOpened = false;

  var isFetching = false;

  late Future getProductsFuture;

  @override
  void initState() {
    super.initState();
    getProductsFuture = Provider.of<ProductsProvider>(context, listen: false).getProducts(_pageNumber);
    getAllListsFuture = Provider.of<ChatlistsProvider>(context, listen: false).getAllChatlistsFuture();
    if (FirebaseAuth.instance.currentUser != null) {
      getUserDataFuture =
          FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      TrackingUtils()
          .trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Home Screen");
    }

    // Provider.of<UserProvider>(context, listen: false).getFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    var chatlistProvider = Provider.of<ChatlistsProvider>(context, listen: false);
    var tutorialProvider = Provider.of<TutorialProvider>(context);
    // var userProvider = Provider.of<UserProvider>(context);
    return ShowCaseWidget(
      onStart: (_, i) {},
      builder: Builder(builder: (builder) {
        print("IS TUTORIAL RUNNING: ${tutorialProvider.isTutorialRunning}");
        print("CAN SHOW WELCOME: ${tutorialProvider.canShowWelcomeDialog}");
        print("Dialog: ${dialogOpened}");
        if (tutorialProvider.canShowWelcomeDialog) {
          print("INSIDE");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print("INSIDE CALLBACK");
            showWelcomeDialog(context, builder);
            tutorialProvider.deactivateWelcomeTutorial();
            startTutorialStopwatch(chatlistProvider);
          });
        }
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: white,
          bottomSheet: Showcase.withWidget(
            key: tutorialProvider.isTutorialRunning ? TooltipKeys.showCase1 : new GlobalKey<State<StatefulWidget>>(),
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
                      style: TextStyles.textViewRegular13.copyWith(color: white),
                    ),
                    GestureDetector(
                      onTap: () {
                        ShowCaseWidget.of(builder).next();
                        // ShowCaseWidget.of(builder).dismiss();
                      },
                      child: Row(
                        children: [
                          SkipTutorialButton(tutorialProvider: tutorialProvider, context: builder),
                          Spacer(),
                          Text(
                            LocaleKeys.next.tr(),
                            style: TextStyles.textViewSemiBold14.copyWith(color: white),
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
            child: RefreshIndicator(
              onRefresh: () {
                setState(() {
                  getAllListsFuture = Provider.of<ChatlistsProvider>(context, listen: false).getAllChatlistsFuture();
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
                        height: 15.h,
                      ),
                      Showcase.withWidget(
                          targetBorderRadius: BorderRadius.circular(10),
                          key:
                          tutorialProvider.isTutorialRunning ? TooltipKeys.showCase2 : new GlobalKey<State<StatefulWidget>>(),
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
                                      style: TextStyles.textViewRegular13.copyWith(color: white),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        ShowCaseWidget.of(builder).next();
                                      },
                                      child: Row(
                                        children: [
                                          SkipTutorialButton(tutorialProvider: tutorialProvider, context: builder),
                                          Spacer(),
                                          Text(
                                            "Next".tr(),
                                            style: TextStyles.textViewSemiBold14.copyWith(color: white),
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
                          child: SearchWidget(isBackButton: false)),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "allCategories".tr(),
                            style: TextStylesDMSans.textViewBold16.copyWith(color: prussian),
                          ),
                          TextButton(
                              onPressed: () {
                                AppNavigator.push(context: context, screen: AllCategoriesScreen());
                                try {
                                  TrackingUtils().trackTextLinkClicked(FirebaseAuth.instance.currentUser!.uid,
                                      DateTime.now().toUtc().toString(), "Home screen", "See all categories");
                                } catch (e) {
                                  print(e);
                                  TrackingUtils().trackTextLinkClicked(
                                      'Guest', DateTime.now().toUtc().toString(), "Home screen", "See all categories");
                                }
                                // pushNewScreen(context, screen: AllCategoriesScreen(), withNavBar: true);
                              },
                              child: Text(
                                'seeAll'.tr(),
                                style: textButtonStyle,
                              ))
                        ],
                      ),
                      Provider.of<ProductsProvider>(context, listen: true).categories.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              height: ScreenUtil().screenHeight * 0.16,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children:
                                      Provider.of<ProductsProvider>(context, listen: true).categories.map((element) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: Provider.of<ProductsProvider>(context, listen: true).categories.first ==
                                                element
                                            ? 0
                                            : 10.0,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          pushNewScreen(context,
                                              screen: CategoryScreen(
                                                category: element.category,
                                              ),
                                              withNavBar: true);
                                          try {
                                            TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid,
                                                "Open category page", DateTime.now().toUtc().toString(), "Home screen");
                                          } catch (e) {
                                            print(e);
                                            TrackingUtils().trackButtonClick("Guest", "Open category page",
                                                DateTime.now().toUtc().toString(), "Home screen");
                                          }
                                        },
                                        child: Container(
                                          // width: 71.w,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                element.image,
                                                width: 90,
                                                height: 60,
                                                errorBuilder: (_, p, ctx) {
                                                  return SvgPicture.asset(imageError);
                                                },
                                              ),
                                              FutureBuilder(
                                                  future: GoogleTranslator().translate(element.category, to: "nl"),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting)
                                                      return Container();
                                                    var translatedCategory = 'N/A';
                                                    if (snapshot.data != null) translatedCategory = snapshot.data!.text;
                                                    if (context.locale.languageCode == "nl") {
                                                      return Flexible(
                                                        child: Text(
                                                          translatedCategory,
                                                          maxLines: 3,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyles.textViewMedium10.copyWith(color: gunmetal),
                                                        ),
                                                      );
                                                    }
                                                    return Text(
                                                      element.category,
                                                      style: TextStyles.textViewMedium10.copyWith(color: gunmetal),
                                                      textAlign: TextAlign.center,
                                                      maxLines: 3,
                                                    );
                                                  })
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList()),
                            ),
                      Showcase.withWidget(
                        key: tutorialProvider.isTutorialRunning ? TooltipKeys.showCase3 : new GlobalKey<State<StatefulWidget>>(),
                        targetBorderRadius: BorderRadius.circular(8.r),
                        tooltipPosition: TooltipPosition.top,
                        onBarrierClick: () async {
                          await goToProductPageTutorial(context, builder);
                        },
                        container: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              width: ScreenUtil().screenWidth * 0.95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: purple70,
                              ),
                              child: Column(children: [
                                Text(
                                  "StartHereTo".tr(),
                                  maxLines: 4,
                                  style: TextStyles.textViewRegular13.copyWith(color: white),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(personAva),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: const Radius.circular(18),
                                              topLeft: const Radius.circular(18),
                                              bottomLeft: const Radius.circular(0),
                                              bottomRight: const Radius.circular(18),
                                            ),
                                            color: const Color.fromRGBO(233, 233, 235, 1),
                                          ),
                                          child: Text(
                                            "Got any ideas for the plan",
                                            style: TextStyles.textViewRegular16.copyWith(color: Colors.black),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        SvgPicture.asset(whiteAdd),
                                        Text(
                                          "  Add to list",
                                          style: TextStyles.textViewRegular10.copyWith(color: white),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Read 10:02",
                                      style: TextStyles.textViewRegular10.copyWith(color: white),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await goToProductPageTutorial(context, builder);
                                  },
                                  child: Row(
                                    children: [
                                      SkipTutorialButton(tutorialProvider: tutorialProvider, context: builder),
                                      Spacer(),
                                      Text(
                                        "Next",
                                        style: TextStyles.textViewSemiBold14.copyWith(color: white),
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
                            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container();
                              }
                              var allLists = snapshot.data?.docs ?? [];
                              if (!snapshot.hasData || allLists.isEmpty || FirebaseAuth.instance.currentUser == null) {
                                return GestureDetector(
                                  onTap: () {
                                    NavigatorController.jumpToTab(1);
                                  },
                                  child: Image.asset(
                                    newChatList,
                                  ),
                                );
                              }
                              return Container();
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
                            style: TextStylesDMSans.textViewBold16.copyWith(color: prussian),
                          ),
                          TextButton(
                              onPressed: () {
                                AppNavigator.push(context: context, screen: LatestBargainsScreen());
                                try {
                                  TrackingUtils().trackTextLinkClicked(FirebaseAuth.instance.currentUser!.uid,
                                      DateTime.now().toUtc().toString(), "Home screen", "See all latest bargains");
                                } catch (e) {
                                  print(e);
                                  TrackingUtils().trackTextLinkClicked('Guest', DateTime.now().toUtc().toString(),
                                      "Home screen", "See all latest bargains");
                                }
                              },
                              child: Text(
                                'seeAll'.tr(),
                                style: textButtonStyle,
                              ))
                        ],
                      ),
                      Consumer<ProductsProvider>(
                        builder: (ctx, provider, _) {
                          var products = provider.products;
                          allProducts = products;
                          if (products.isEmpty) {
                            return ListView(
                              shrinkWrap: true,
                              children: List<Widget>.generate(
                                  20,
                                  (index) => Shimmer(
                                        duration: Duration(seconds: 2),
                                        colorOpacity: 0.7,
                                        child: Container(
                                          height: 253.h,
                                          width: 174.w,
                                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: purple10,
                                          ),
                                        ),
                                      )),
                            );
                          } else {
                            return GridView.builder(
                                physics: ScrollPhysics(), // to disable GridView's scrolling
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    mainAxisExtent: 275,
                                    childAspectRatio: 0.67,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                                itemCount: products.length,
                                itemBuilder: (BuildContext ctx, index) {
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
                                });
                          }
                        },
                      ),
                      isFetching
                          ? Center(child: CircularProgressIndicator())
                          : GenericButton(
                              borderRadius: BorderRadius.circular(10),
                              borderColor: mainPurple,
                              color: Colors.white,
                              onPressed: () async {
                                var productsProvider = Provider.of<ProductsProvider>(context, listen: false);
                                setState(() {
                                  isFetching = true;
                                });
                                try {
                                  _pageNumber = _pageNumber + 1;
                                  print("Page Number: " + _pageNumber.toString());
                                  await productsProvider.getProducts(_pageNumber);
                                } catch (e) {
                                  print(e);
                                }
                                setState(() {
                                  isFetching = false;
                                });
                                try {
                                  TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "See more",
                                      DateTime.now().toUtc().toString(), "Home screen");
                                } catch (e) {
                                  print(e);
                                  TrackingUtils().trackButtonClick(
                                      "Guest", "See more", DateTime.now().toUtc().toString(), "Home screen");
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "SEE MORE",
                                    style: TextStyles.textViewMedium12.copyWith(color: blackSecondary),
                                  ),
                                  10.pw,
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.black,
                                  ),
                                ],
                              )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void startTutorialStopwatch(ChatlistsProvider chatlistProvider) {
    chatlistProvider.stopwatch.start();
    chatlistProvider.stopwatch.reset();
    var onboardingDuration = chatlistProvider.stopwatch.elapsed.inSeconds.toString();
    print("Onboarding duration start: " + onboardingDuration);
  }

  Future<void> goToProductPageTutorial(BuildContext context, BuildContext builder) async {
    var productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    ShowCaseWidget.of(builder).dismiss();

    // setState(() {
    //   isHomeFirstTime = false;
    // });
    try {
      Product product = Provider.of<ProductsProvider>(context, listen: false).products.first;
      await pushNewScreen(context,
          screen: ProductDetailScreen(
            productId: product.id,
            productBrand: product.brand,
            storeName: productsProvider.getStoreName(product.storeId),
            productName: product.name,
            imageURL: product.image,
            description: product.description,
            oldPrice: product.oldPrice,
            productCategory: product.category,
            price1: double.tryParse(product.price ?? "") ?? 0.0,
            size1: product.unit,
            gtin: product.gtin,
          ));

      // NavigatorController.jumpToTab(1);
      ShowCaseWidget.of(builder).next();
      try {
        TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open product page",
            DateTime.now().toUtc().toString(), "Home screen");
      } catch (e) {
        print(e);
        TrackingUtils()
            .trackButtonClick("Guest", "Open product page", DateTime.now().toUtc().toString(), "Home screen");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> showWelcomeDialog(BuildContext context, BuildContext builder) {
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
                        style: TextStyles.textViewSemiBold24.copyWith(color: white),
                      ),
                      GestureDetector(
                          onTap: () {
                            skipTutorial(context, builder);
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
                    startHomeTutorial(context, builder);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        LocaleKeys.next.tr(),
                        style: TextStyles.textViewSemiBold14.copyWith(color: white),
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

  void skipTutorial(BuildContext context, BuildContext builder) {
    AppNavigator.pop(context: context);
    Provider.of<TutorialProvider>(context, listen: false).stopTutorial(builder);
  }

  void startHomeTutorial(BuildContext context, BuildContext builder) {
    AppNavigator.pop(context: context);
    try {
      // setState(() {
        ShowCaseWidget.of(builder)
            .startShowCase([TooltipKeys.showCase1, TooltipKeys.showCase2, TooltipKeys.showCase3]);
      // });
    } catch (e) {
      log(e.toString());
    }
    Provider.of<TutorialProvider>(context, listen: false).startTutorial();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class SkipTutorialButton extends StatelessWidget {
  const SkipTutorialButton({
    super.key,
    required this.tutorialProvider,
    required this.context,
  });

  final TutorialProvider tutorialProvider;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: TextButton(
        onPressed: () {
          tutorialProvider.stopTutorial(this.context);
        },
        child: Text(LocaleKeys.skip.tr(), style: TextStylesInter.textViewRegular14.copyWith(color: Colors.white),),
      ),
    );
  }
}
