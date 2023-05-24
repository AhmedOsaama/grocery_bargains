import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/view/widgets/signin_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/price_comparison_item.dart';

import '../../models/list_item.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final String storeName;
  final int productId;
  final String productName;
  final String imageURL;
  final String description;
  final double? price1;
  final double? price2;
  final String? oldPrice;
  final String size1;
  final String size2;
  const ProductDetailScreen({
    Key? key,
    required this.storeName,
    required this.productName,
    required this.imageURL,
    required this.description,
    required this.price1,
    required this.price2,
    required this.size1,
    required this.size2,
    required this.productId,
    this.oldPrice,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // final productImages = [milk, peach, spar];
  List<ItemSize> productSizes = [];
  var defaultPrice = 0.0;
  bool isLoading = false;
  final comparisonItems = [];

  var selectedIndex = 0;
  var selectedSizeIndex = 0;
  var bestValueSize = "";

  int quantity = 1;

  List<Map> allLists = [];

  @override
  void initState() {
    productSizes.addAll([
      ItemSize(price: widget.price1.toString(), size: widget.size1),
      ItemSize(price: widget.price2.toString(), size: widget.size2),
    ]);
    defaultPrice = widget.price1 == null
        ? widget.price2 as double
        : widget.price1 as double;
    // mixpanel.track("view_product", properties: {
    //   "product_id": widget.productId,
    //   "store_name": widget.storeName
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    try {
      bestValueSize = Provider.of<ProductsProvider>(context, listen: false)
          .bestValueBargains
          .firstWhere((bargain) => bargain.itemId == widget.productId)
          .bestValueSize;
    } catch (e) {
      print("Error in product page: couldn't find best value size");
      print(e);
      bestValueSize = "";
    }
    print("BEST VALUE SIZE: $bestValueSize");

    getComparisons();

    super.didChangeDependencies();
  }

  void getComparisons() {
    try {
      var productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      late ComparisonProduct productComparison;
      Product albertProduct;
      Product jumboProduct;
      Product hoogvlietProduct;
      if(widget.storeName == "Albert"){
        productComparison = productsProvider.comparisonProducts.firstWhere(
                (comparisonProduct) => widget.productId == comparisonProduct.albertId);
      } if(widget.storeName == "Jumbo"){
        productComparison = productsProvider.comparisonProducts.firstWhere(
                (comparisonProduct) => widget.productId == comparisonProduct.jumboId);
      } if(widget.storeName == "Hoogvliet"){
        productComparison = productsProvider.comparisonProducts.firstWhere(
                (comparisonProduct) => widget.productId == comparisonProduct.hoogvlietId);
      }
      albertProduct = productsProvider.albertProducts.firstWhere((product) => product.id == productComparison.albertId);
      jumboProduct = productsProvider.jumboProducts.firstWhere((product) => product.id == productComparison.jumboId);
      hoogvlietProduct = productsProvider.hoogvlietProducts.firstWhere((product) => product.id == productComparison.hoogvlietId);

      comparisonItems.add(GestureDetector(
        onTap: widget.storeName == "Jumbo"
            ? () {}
            : () => goToStoreProductPage(context, "Jumbo", jumboProduct),
        child: PriceComparisonItem(
            isSameStore: widget.storeName == "Jumbo",
            price: jumboProduct.price ?? "N/A",
            size: jumboProduct.size,
            storeImagePath: jumbo),
      ));
      comparisonItems.add(GestureDetector(
        onTap: widget.storeName == "Albert"
            ? () {}
            : () => goToStoreProductPage(context, "Albert", albertProduct),
        child: PriceComparisonItem(
            isSameStore: widget.storeName == "Albert",
            price: albertProduct.price ?? "N/A",
            size: albertProduct.size,
            storeImagePath: albert),
      ));
      comparisonItems.add(GestureDetector(
        onTap: widget.storeName == "Hoogvliet"
            ? () {}
            : () => goToStoreProductPage(context, "Hoogvliet", hoogvlietProduct),
        child: PriceComparisonItem(
            isSameStore: widget.storeName == "Hoogvliet",
            price: hoogvlietProduct.price ?? "N/A",
            size: hoogvlietProduct.size,
            storeImagePath: hoogLogo),
      ));
    } catch (e) {
      print("Failed to get price comparisons in product detail");
      print(e);
    }
  }

  void goToStoreProductPage(
      BuildContext context, String selectedStore, Product product) {
      AppNavigator.push(
          context: context,
          screen: ProductDetailScreen(
            productId: product.id,
            storeName: selectedStore,
            productName: product.name,
            imageURL: product.imageURL,
            description: product.description,
            price1: double.tryParse(product.price ?? "") ?? 0.0,
            price2: double.tryParse(product.price2 ?? "") ?? 0.0,
            size1: product.size,
            size2: product.size2 ?? "",
          ));
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.storeName,
                style: TextStyles.textViewMedium30.copyWith(color: prussian),
              ),
              Text(
                widget.productName,
                style: TextStyles.textViewLight15,
              ),
              10.ph,
              Center(
                child: Container(
                    height: 214.h,
                    width: 214.w,
                    child:
                        // Image.asset(productImages.elementAt(selectedIndex))
                        Image.network(
                      widget.imageURL,
                      width: 214.w,
                      height: 214.h,
                    )),
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        //adding
                        onTap: () async {
                          if (FirebaseAuth.instance.currentUser == null) {
                            showDialog(
                                context: context,
                                builder: (ctx) => SigninDialog(
                                      body:
                                          'You have to be signed in to use this feature.',
                                      buttonText: 'Sign in',
                                      title: 'Sign In',
                                    ));
                          } else {
                            Provider.of<ChatlistsProvider>(context,
                                    listen: false)
                                .showChooseListDialog(
                              context: context,
                              isSharing: false,
                              listItem: ListItem(
                                  storeName: widget.storeName,
                                  name: widget.productName,
                                  oldPrice: widget.oldPrice,
                                  price: defaultPrice.toString(),
                                  isChecked: false,
                                  quantity: quantity,
                                  imageURL: widget.imageURL,
                                  size: widget.size1,
                                  text: ''),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(21),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(135, 208, 192, 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SvgPicture.asset(
                            plusIcon,
                            width: 18,
                            height: 18,
                            color: prussian,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "addToList".tr(),
                        style: TextStyles.textViewMedium12
                            .copyWith(color: prussian),
                      )
                    ],
                  ),
                  GestureDetector(
                    //sharing
                    onTap: () async {
                      if (FirebaseAuth.instance.currentUser == null) {
                        showDialog(
                            context: context,
                            builder: (ctx) => SigninDialog(
                                  body:
                                      'You have to be signed in to use this feature.',
                                  buttonText: 'Sign in',
                                  title: 'Sign In',
                                ));
                      } else {
                        Provider.of<ChatlistsProvider>(context, listen: false)
                            .showChooseListDialog(
                          context: context,
                          isSharing: true,
                          listItem: ListItem(
                              storeName: widget.storeName,
                              name: widget.productName,
                              oldPrice: widget.oldPrice,
                              price: defaultPrice.toString(),
                              isChecked: false,
                              quantity: quantity,
                              imageURL: widget.imageURL,
                              size: widget.size1,
                              text: ''),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(135, 208, 192, 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.share_outlined,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "share".tr(),
                          style: TextStyles.textViewMedium12
                              .copyWith(color: prussian),
                        )
                      ],
                    ),
                  ),
                  // priceAlertButton,
                ],
              ),
              SizedBox(
                height: 25.h,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Quantity",
              //       style: TextStyles.textViewMedium12
              //           .copyWith(color: Colors.grey),
              //     ),
              //     Container(
              //       child: Row(
              //         children: [
              //           IconButton(
              //             onPressed: () {
              //               if (quantity > 0) {
              //                 setState(() {
              //                   quantity--;
              //                 });
              //               }
              //             },
              //             icon: Icon(Icons.remove),
              //             color: verdigris,
              //           ),
              //           VerticalDivider(),
              //           Text(
              //             quantity.toString(),
              //             style: TextStyles.textViewMedium18,
              //           ),
              //           VerticalDivider(),
              //           IconButton(
              //               onPressed: () {
              //                 setState(() {
              //                   ++quantity;
              //                 });
              //               },
              //               icon: Icon(Icons.add),
              //               color: verdigris),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 30.h,
              ),
              if (comparisonItems.isNotEmpty) ...[
                Text(
                  "PriceComparison".tr(),
                  style:
                      TextStyles.textViewSemiBold18.copyWith(color: prussian),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: comparisonItems.length,
                  itemBuilder: (context, index) {
                    return comparisonItems[index];
                  },
                ),
              ],
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: grey, width: 2),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_outlined),
                    SizedBox(
                      width: 15.w,
                    ),
                    Flexible(
                        child: Text(
                      "ThePricesShown".tr(),
                      style: TextStyles.textViewLight12
                          .copyWith(color: const Color.fromRGBO(62, 62, 62, 1)),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                "Sizes".tr(),
                style: TextStyles.textViewSemiBold18,
              ),
              ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: productSizes.map((size) {
                    var index = productSizes.indexOf(size);
                    print("SIZE: " + size.size);
                    print("PRICE: " + size.price);
                    if (size.size.isEmpty ||
                        size.size == "None" ||
                        size.price == '0.0') {
                      return Container();
                    }
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSizeIndex = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.0,
                              color: bestValueSize == size.size
                                  ? mainPurple
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              widget.imageURL,
                              errorBuilder: (ctx, _, s) =>
                                  Icon(Icons.no_photography),
                              width: 64,
                              height: 64,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  size.size,
                                  style: TextStyles.textViewSemiBold16,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "\€${size.price}", //to type euro: ALT + 0128
                                      style: TextStyles.textViewMedium12
                                          .copyWith(
                                              color: Color.fromRGBO(
                                                  108, 197, 29, 1)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
                            if (bestValueSize.isNotEmpty &&
                                bestValueSize == size.size)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: purple70),
                                child: Text(
                                  "BESTVALUE".tr(),
                                  style: TextStyles.textViewRegular12
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList()),
              Divider(),
              SizedBox(
                height: 20.h,
              ),
              Text("Description".tr(),
                  style:
                      TextStyles.textViewSemiBold18.copyWith(color: prussian)),
              SizedBox(
                height: 10.h,
              ),
              Text(
                widget.description,
                style: TextStyles.textViewMedium14
                    .copyWith(color: Color.fromRGBO(134, 136, 137, 1)),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  var priceAlertButton = Column(
    children: [
      Container(
        width: 60,
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(135, 208, 192, 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.notifications_none_outlined,
        ),
      ),
      SizedBox(
        height: 10.h,
      ),
      Text(
        "Price alert",
        style: TextStyles.textViewMedium12.copyWith(color: prussian),
      )
    ],
  );
}

class ItemSize {
  String price;
  String size;

  ItemSize({required this.price, required this.size});
}
