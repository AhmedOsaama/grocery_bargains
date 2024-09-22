import 'dart:developer';

import 'package:bargainb/features/search/presentation/views/widgets/search_appBar.dart';
import 'package:bargainb/utils/down_triangle_painter.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../config/routes/app_navigator.dart';
import '../../../../models/list_item.dart';
import '../../../../providers/chatlists_provider.dart';
import '../../../../providers/products_provider.dart';
import '../../../../providers/subscription_provider.dart';
import '../../../../providers/tutorial_provider.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/assets_manager.dart';
import '../../../../utils/style_utils.dart';
import '../../../../utils/tooltips_keys.dart';
import '../../../../utils/tracking_utils.dart';
import '../../../../utils/triangle_painter.dart';
import '../../../../view/widgets/price_comparison_item.dart';
import '../../../../view/widgets/quantity_counter.dart';
import '../../../chatlists/presentation/views/chatlist_view_screen.dart';
import '../../data/models/product.dart';
import 'main_screen.dart';
import 'widgets/skip_tutorial_button.dart';
import 'widgets/store_product_card.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final comparisonItems = [];
  int quantity = 1;
  List<Map> allLists = [];
  late Future getComparisonsFuture;
  late ListItem listItem;
  bool canUpdateQuantity = false;


  @override
  initState(){
    super.initState();
    getComparisonsFuture = getComparisons();
    initializeListItem();
    trackPageView();
  }

  void trackPageView() {
    try {
      TrackingUtils()
          .trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Product Screen");
    } catch (e) {}
  }

  void initializeListItem() {
    listItem = ListItem(
        id: widget.product.id,
        storeName: widget.product.storeName,
        name: widget.product.name,
        brand: widget.product.brand,
        oldPrice: widget.product.price,
        price: widget.product.price,
        isChecked: false,
        quantity: quantity,
        imageURL: widget.product.image,
        size: widget.product.unit,
        category: widget.product.category,
        text: '');
  }

  Future<void> getComparisons() async {
    try {
      var productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      log("Finding similar products for ${widget.product.compareId}");

        List<Product> similarProducts = await productsProvider.getSimilarProducts(widget.product.compareId);
        for (var product in similarProducts) {
          // log(product.storeName);
          // log(product.storeId.toString());
          // if (product.availableNow == 1) {
            addComparisonItem(product, productsProvider);
        // }
      }
    } catch (e) {
      log("Failed to get price comparisons in product detail");
      log(e.toString());
    }
  }

  void addComparisonItem(Product product, ProductsProvider productsProvider) {
    comparisonItems.add(GestureDetector(
      onTap: () => goToStoreProductPage(context, product),
      child: PriceComparisonItem(
          price: product.price.toString(),
          size: product.unit,
          storeImagePath: productsProvider.getStoreLogoPath(product.storeName)),
    ));
    setState(() {
      canUpdateQuantity = true;
    });
  }

  void addProductToList() {
    if(FirebaseAuth.instance.currentUser != null) {
      Provider.of<ChatlistsProvider>(context, listen: false).addProductToList(context, listItem);
    }
  }

  void goToStoreProductPage(BuildContext context, Product product) {
    AppNavigator.push(
        context: context,
        screen: ProductDetailScreen(
         product: product,
        ));
  }
  @override
  Widget build(BuildContext context) {
    var tutorialProvider = Provider.of<TutorialProvider>(context);
    return Scaffold(
      appBar: SearchAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ShowCaseWidget(
          builder: Builder(
            builder: (ctx) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (tutorialProvider.isTutorialRunning) {
                getComparisonsFuture.whenComplete(() {
                  ShowCaseWidget.of(ctx).startShowCase([TooltipKeys.showCase4]);
                });
              }
            });
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(widget.product.oldPrice != null && (widget.product.oldPrice! - widget.product.price) > 0)
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.orange[500],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text("Saving\n ${(widget.product.oldPrice! - widget.product.price)}", style: TextStyles.textViewRegular10.copyWith(color: Colors.white),),
                      ),
                    ),
                    10.ph,
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Center(
                          child: Image.network(
                            widget.product.image,
                            height: 200,
                            width: 250,
                            errorBuilder: (ctx, _, stack){
                              return Image.asset(bbIconNew, color: Colors.green,);
                            },
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: StoreProductCard(storeName: widget.product.storeName,)
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.product.price.toString(),
                              style: TextStylesPaytoneOne.textViewRegular24.copyWith(color: Color(0xffEA4B48), fontSize: 13),
                            ),
                            if(widget.product.oldPrice != null && widget.product.oldPrice != 0.0)
                              Text(widget.product.oldPrice.toString(), style: TextStylesInter.textViewMedium10.copyWith(color: Colors.grey, decoration: TextDecoration.lineThrough),)
                          ],
                        ),
                      ],
                    ),
                    20.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.product.name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStylesPaytoneOne.textViewRegular24,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: primaryGreen),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text("${widget.product.unit}", style: TextStylesInter.textViewMedium15.copyWith(color: primaryGreen),),
                        )
                      ],
                    ),
                    Divider(),
                    if(widget.product.description != "N/A" && widget.product.description.isNotEmpty) ...[
                      Text("DESCRIPTION".tr(), style: TextStylesInter.textViewRegular12,),
                      15.ph,
                      Text(widget.product.description, style: TextStylesInter.textViewRegular14,),
                      Divider(),
                    ],
                    20.ph,
                    Text("Where to buy ?".tr(), style: TextStylesInter.textViewMedium14.copyWith(color: Color(0xff123013)),),
                    FutureBuilder(
                        future: getComparisonsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if(comparisonItems.isEmpty) {
                            return Center(child: Text("No comparisons found for this product".tr()));
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
                                    : GlobalKey<State<StatefulWidget>>(),
                                tooltipPosition: TooltipPosition.top,
                                container: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      width: 200.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: purple70,
                                      ),
                                      child: Column(children: [
                                        Text(
                                          " View all the available prices, add to your list, and streamline your shopping experience".tr(),
                                          style: TextStyles.textViewRegular16.copyWith(color: Colors.white),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if(FirebaseAuth.instance.currentUser != null && SubscriptionProvider.get(context).isSubscribed) {
                                              ShowCaseWidget.of(ctx).dismiss();
                                              var id = await Provider.of<ChatlistsProvider>(context, listen: false)
                                                  .createChatList([]);
                                              await pushNewScreen(context,
                                                  screen: ChatListViewScreen(
                                                    listId: id,
                                                  ),
                                                  withNavBar: false);
                                              NavigatorController.jumpToTab(1);
                                              ShowCaseWidget.of(ctx).next();
                                            }else{
                                              tutorialProvider.stopTutorial(context);
                                              AppNavigator.pop(context: context);
                                              NavigatorController.jumpToTab(0);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              SkipTutorialButton(tutorialProvider: tutorialProvider, context: ctx),
                                              Spacer(),
                                              Text(
                                                "Next".tr(),
                                                style: TextStyles.textViewSemiBold14.copyWith(color: Colors.white),
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
                                height: 50,
                                width: 50,
                                child: comparisonItems[index],
                              );
                            },
                          );
                        }),
                    20.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(onPressed: (){
                          addProductToList();
                        }, style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            fixedSize: Size(250, 40),
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white
                        ),
                          child: Text("Add to list".tr(), style: TextStylesInter.textViewMedium12,),),
                        10.pw,
                        OutlinedButton(onPressed: (){
                          Provider.of<ProductsProvider>(context, listen: false).shareProductViaDeepLink(
                              widget.product.name, widget.product.id, widget.product.storeName, context);
                          try {
                            TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid,
                                "Share product", DateTime.now().toUtc().toString(), "Product screen");
                          } catch (e) {
                            print(e);
                            TrackingUtils().trackButtonClick("Guest", "Share categories",
                                DateTime.now().toUtc().toString(), "Product screen");
                          }
                        }, child: Row(
                          children: [
                            Text("Share".tr(), style: TextStylesInter.textViewMedium12.copyWith(color: Color(0xff0F0F0F)),),
                            5.pw,
                            Icon(Icons.share_outlined, color: Color(0xff0F0F0F),)
                          ],
                        )),
                      ],
                    ),
                    20.ph,
                    if (canUpdateQuantity)
                      Row(
                        children: [
                          Text("Quantity".tr(), style: TextStylesInter.textViewRegular14,),
                          20.pw,
                          QuantityCounter(
                            quantity: quantity,
                            increaseQuantity: increaseQuantity,
                            decreaseQuantity: decreaseQuantity,
                          ),
                        ],
                      ),
                    25.ph,

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
                          15.pw,
                          Flexible(
                            child: Text(
                              "The price shown are available online and may not reflect in store. Confirm prices before visiting store".tr(),
                              style: TextStyles.textViewLight12.copyWith(color: const Color.fromRGBO(62, 62, 62, 1)),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  decreaseQuantity() {
    setState(() {
      quantity--;
    });
    listItem.quantity--;
  }

  increaseQuantity() {
    setState(() {
      ++quantity;
    });
    listItem.quantity++;
  }
}