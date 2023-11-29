import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/widgets/quantity_counter.dart';
import 'package:bargainb/view/widgets/signin_dialog.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/view/widgets/price_comparison_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../models/list_item.dart';
import '../../models/product.dart';
import '../../providers/tutorial_provider.dart';
import '../../utils/tooltips_keys.dart';
import '../../utils/triangle_painter.dart';
import '../components/search_appBar.dart';
import '../widgets/choose_list_dialog.dart';
import 'chatlist_view_screen.dart';
import 'home_screen.dart';
import 'main_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String storeName;
  final String productBrand;
  final int productId;
  final String productName;
  final String gtin;
  final String imageURL;
  final String description;
  final double? price1;
  final String? oldPrice;
  final String size1;
  final String productCategory;
  const ProductDetailScreen({
    Key? key,
    required this.storeName,
    required this.productName,
    required this.imageURL,
    required this.description,
    required this.price1,
    required this.size1,
    required this.productId,
    this.oldPrice,
    required this.productBrand,
    required this.gtin,
    required this.productCategory,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<ItemSize> productSizes = [];
  var defaultPrice = 0.0;
  bool isLoading = false;
  // bool isFirstTime = false;
  final comparisonItems = [];
  var selectedIndex = 0;
  var bestValueSize = "";
  var cheapest = "";
  int quantity = 1;
  List<Map> allLists = [];
  late Future getComparisonsFuture;
  late ListItem listItem;

  bool canUpdateQuantity = false;

  @override
  void initState() {
    super.initState();
    initializeListItem();
    addProductSizes();
    getComparisonsFuture = getComparisons();
    trackPageView();
  }

  void initializeListItem() {
    listItem = ListItem(
        id: widget.productId,
        storeName: widget.storeName,
        name: widget.productName,
        brand: widget.productBrand,
        oldPrice: widget.oldPrice,
        price: widget.price1.toString(),
        isChecked: false,
        quantity: quantity,
        imageURL: widget.imageURL,
        size: widget.size1,
        category: widget.productCategory,
        text: '');
  }

  void trackPageView() {
    try {
      TrackingUtils()
          .trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Product Screen");
    } catch (e) {}
  }

  void addProductSizes() {
    productSizes.addAll([
      ItemSize(price: widget.price1.toString(), size: widget.size1),
    ]);
  }

  Future<void> getComparisons() async {
    try {
      var productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      var chatlistsProvider = Provider.of<ChatlistsProvider>(context, listen: false);

      if (widget.gtin == null || widget.gtin == "N/A") {
        var product = await productsProvider.getProductById(widget.productId);
        var storeName = productsProvider.getStoreName(product.storeId);
        if (product.availableNow == 1) {
          addComparisonItem(storeName, chatlistsProvider, product, productsProvider);
        }
      }else {
        List<Product> similarProducts = await productsProvider.getSimilarProducts(widget.gtin);
        for (var product in similarProducts) {
          var storeName = productsProvider.getStoreName(product.storeId);
          if (product.availableNow == 1) {
            addComparisonItem(storeName, chatlistsProvider, product, productsProvider);
          }
        }
      }
    } catch (e) {
      print("Failed to get price comparisons in product detail");
      print(e);
    }
  }

  void addComparisonItem(String storeName, ChatlistsProvider chatlistsProvider, Product product, ProductsProvider productsProvider) {
     comparisonItems.add(GestureDetector(
          onTap: widget.storeName == storeName
              ? () => chatlistsProvider.addProductToList(context, listItem)
              : () => goToStoreProductPage(context, storeName, product),
          child: PriceComparisonItem(
              isSameStore: widget.storeName == storeName,
              price: product.price ?? "N/A",
              size: product.unit,
              storeImagePath: productsProvider.getStoreLogoPath(storeName)),
        ));
     setState(() {
       canUpdateQuantity = true;
     });
  }

  void goToStoreProductPage(BuildContext context, String selectedStore, Product product) {
    AppNavigator.push(
        context: context,
        screen: ProductDetailScreen(
          productId: product.id,
          storeName: selectedStore,
          productBrand: product.brand,
          productName: product.name,
          imageURL: product.image,
          description: product.description,
          productCategory: product.category,
          price1: double.tryParse(product.price ?? "") ?? 0.0,
          size1: product.unit,
          gtin: product.gtin,
        ));
  }

  @override
  Widget build(BuildContext context) {
    var tutorialProvider = Provider.of<TutorialProvider>(context);
    return Scaffold(
      appBar: SearchAppBar(
        isBackButton: true,
      ),
      body: ShowCaseWidget(
        builder: Builder(
          builder: (ctx) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (tutorialProvider.isTutorialRunning && FirebaseAuth.instance.currentUser != null) {
                getComparisonsFuture.whenComplete(() {
                  ShowCaseWidget.of(ctx).startShowCase([TooltipKeys.showCase4]);
                });
              }
            });
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productBrand.isEmpty ? widget.storeName : widget.productBrand,
                      style: TextStyles.textViewSemiBold30.copyWith(color: blackSecondary),
                    ),
                    Text(
                      widget.productName,
                      style: TextStylesInter.textViewRegular14,
                    ),
                    5.ph,
                    SizeContainer(itemSize: widget.size1),
                    10.ph,
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 200.h,
                            width: 200.w,
                            child: Image.network(
                              widget.imageURL,
                              errorBuilder: (ctx, i, _) => SvgPicture.asset(imageError),
                              width: 214.w,
                              height: 214.h,
                            )),
                        Spacer(),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: comparisonItems.isEmpty ? 30 : 0),
                              child: GestureDetector(
                                onTap: () {
                                  Provider.of<ProductsProvider>(context, listen: false).shareProductViaDeepLink(
                                      widget.productName, widget.productId, widget.storeName, context);
                                  try {
                                    TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid,
                                        "Share product", DateTime.now().toUtc().toString(), "Product screen");
                                  } catch (e) {
                                    print(e);
                                    TrackingUtils().trackButtonClick("Guest", "Share categories",
                                        DateTime.now().toUtc().toString(), "Product screen");
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                        // margin: EdgeInsets.symmetric(horizontal: 10),
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: purple30,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: SvgPicture.asset(
                                          shareIcon,
                                          width: 20,
                                          height: 20,
                                        )),
                                    10.ph,
                                    Text(
                                      "share".tr(),
                                      style: TextStyles.textViewMedium12.copyWith(color: blackSecondary),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            20.ph,
                            if (canUpdateQuantity)
                              QuantityCounter(
                                quantity: quantity,
                                increaseQuantity: increaseQuantity,
                                decreaseQuantity: decreaseQuantity,
                              ),
                          ],
                        )
                      ],
                    ),
                    30.ph,
                    Text(
                      "whereToBuy".tr(),
                      style: TextStylesInter.textViewSemiBold16.copyWith(color: blackSecondary),
                    ),
                    FutureBuilder(
                        future: getComparisonsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: comparisonItems.length,
                            itemBuilder: (context, index) {
                              return Showcase.withWidget(
                                targetBorderRadius: BorderRadius.circular(10),
                                key: tutorialProvider.isTutorialRunning && index == 0
                                    ? TooltipKeys.showCase4
                                    : new GlobalKey<State<StatefulWidget>>(),
                                tooltipPosition: TooltipPosition.bottom,
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
                                            "toAddItemsInChat".tr(),
                                            maxLines: 4,
                                            style: TextStyles.textViewRegular13.copyWith(color: white),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              var id = await Provider.of<ChatlistsProvider>(context, listen: false)
                                                  .createChatList([]);
                                              await pushNewScreen(context,
                                                  screen: ChatListViewScreen(
                                                    listId: id,
                                                  ),
                                                  withNavBar: false);
                                              NavigatorController.jumpToTab(1);
                                              // setState(() {
                                              //   isFirstTime = false;
                                              // });
                                              ShowCaseWidget.of(ctx).next();
                                            },
                                            child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SkipTutorialButton(tutorialProvider: tutorialProvider, context: ctx),
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
                                child: comparisonItems[index],
                              );
                            },
                          );
                        }),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border.all(color: purple30, width: 2), borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.report_gmailerrorred,
                            color: mainPurple,
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Flexible(
                              child: Text(
                            "ThePricesShown".tr(),
                            style: TextStyles.textViewLight12.copyWith(color: const Color.fromRGBO(62, 62, 62, 1)),
                          )),
                        ],
                      ),
                    ),
                    30.ph,
                    if (widget.description.isNotEmpty) ...[
                      Text("Description".tr(), style: TextStyles.textViewSemiBold18.copyWith(color: blackSecondary)),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        widget.description,
                        style: TextStylesInter.textViewMedium14.copyWith(color: Color.fromRGBO(134, 136, 137, 1)),
                      ),
                    ],
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Sizes".tr(),
                      style: TextStyles.textViewSemiBold18,
                    ),
                    ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: productSizes.map((size) {
                          if (size.size.isEmpty || size.size == "None" || size.price == '0.0') {
                            return Container();
                          }
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: bestValueSize == size.size ? mainPurple : Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Image.network(
                                    widget.imageURL,
                                    errorBuilder: (ctx, _, s) => SvgPicture.asset(imageError),
                                    width: 64,
                                    height: 64,
                                  ),
                                  5.pw,
                                  Image.asset(
                                    Provider.of<ProductsProvider>(context, listen: false).getImage(widget.storeName),
                                    width: 20,
                                    height: 20,
                                  ),
                                  34.pw,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        size.size,
                                        style: TextStylesInter.textViewSemiBold16.copyWith(color: blackSecondary),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "\€${size.price}", //to type euro: ALT + 0128
                                            style: TextStyles.textViewMedium12.copyWith(color: mainPurple),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      if (bestValueSize.isNotEmpty && bestValueSize == size.size)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                          decoration:
                                              BoxDecoration(borderRadius: BorderRadius.circular(10), color: mainPurple),
                                          child: Text(
                                            "BESTVALUE".tr(),
                                            style: TextStyles.textViewRegular12.copyWith(color: Colors.white),
                                          ),
                                        ),
                                      10.ph,
                                      if (cheapest.isNotEmpty && cheapest == size.price)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                          decoration:
                                              BoxDecoration(borderRadius: BorderRadius.circular(10), color: mainPurple),
                                          child: Text(
                                            "cheapest".tr(),
                                            style: TextStyles.textViewRegular12.copyWith(color: Colors.white),
                                          ),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  decreaseQuantity() {
    setState(() {
      quantity--;
    });
    listItem.quantity--;
    trackQuantityDecrease();
  }

  increaseQuantity() {
    setState(() {
      ++quantity;
    });
    listItem.quantity++;
    trackQuantityIncrease();
  }

  void trackQuantityDecrease() {
    try {
      TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "decrease quantity",
          DateTime.now().toUtc().toString(), "Product screen");
    } catch (e) {
      print(e);
      TrackingUtils()
          .trackButtonClick("Guest", "decrease quantity", DateTime.now().toUtc().toString(), "Product screen");
    }
  }

  void trackQuantityIncrease() {
    try {
      TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "increase quantity",
          DateTime.now().toUtc().toString(), "Product screen");
    } catch (e) {
      print(e);
      TrackingUtils()
          .trackButtonClick("Guest", "increase quantity", DateTime.now().toUtc().toString(), "Product screen");
    }
  }
}

Future<void> showChooseListDialog({required BuildContext context, required ListItem listItem}) async {
  showDialog(context: context, builder: (ctx) => ChooseListDialog(item: listItem, context: context));
}

class ItemSize {
  String price;
  String size;

  ItemSize({required this.price, required this.size});
}
