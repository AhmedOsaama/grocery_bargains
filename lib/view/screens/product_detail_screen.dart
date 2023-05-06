import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/view/widgets/signin_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/price_comparison_item.dart';

import '../../models/list_item.dart';

class ProductDetailScreen extends StatefulWidget {
  final String storeName;
  final int productId;
  final int comparisonId;
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
    required this.comparisonId,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // final productImages = [milk, peach, spar];
  List<ItemSize> productSizes = [];
  Mixpanel mixpanel = Mixpanel('752b3abf782a7347499ccb3ebb504194');
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
    mixpanel.track("view_product", properties: {
      "product_id": widget.productId,
      "store_name": widget.storeName
    });

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
      bestValueSize = "";
    }
    print(bestValueSize);
    ComparisonProduct productComparison;

    try {
      var productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      productComparison = productsProvider
          .comparisonProducts
          .firstWhere((comparisonProduct) =>
              comparisonProduct.id == widget.comparisonId);
      comparisonItems.add(GestureDetector(
        onTap: widget.storeName == "Jumbo" ? (){} : () => goToStoreProductPage(productsProvider,context,"Jumbo",productComparison.jumboLink),
        child: PriceComparisonItem(
            price: productComparison.jumboPrice,
            size: productComparison.jumboSize ?? "N/A",
            storeImagePath: jumbo),
      ));
      comparisonItems.add(GestureDetector(
        onTap: widget.storeName == "Albert" ? (){} : () => goToStoreProductPage(productsProvider,context,"Albert",productComparison.albertLink),
        child: PriceComparisonItem(
            price: productComparison.albertPrice,
            size: productComparison.albertSize,
            storeImagePath: albert),
      ));
      comparisonItems.add(GestureDetector(
        onTap: widget.storeName == "Hoogvliet" ? (){} : () => goToStoreProductPage(productsProvider,context,"Hoogvliet",productComparison.hoogvlietLink),
        child: PriceComparisonItem(
            price: productComparison.hoogvlietPrice,
            size: productComparison.hoogvlietSize,
            storeImagePath: hoogLogo),
      ));
    } catch (e) {
      print("Failed to get price comparisons in product detail");
      print(e);
    }

    super.didChangeDependencies();
  }

  void goToStoreProductPage(ProductsProvider productsProvider,
      BuildContext context, String selectedStore, String productLink) {
    if (selectedStore == "Albert") {
      var product = productsProvider.albertProducts.firstWhere((product) {
        return product.url == productLink;
      });
      AppNavigator.push(
          context: context,
          screen: ProductDetailScreen(
            comparisonId: widget.comparisonId,
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
    if (selectedStore == "Jumbo") {
      var product = productsProvider.jumboProducts
          .firstWhere((product) => product.url == productLink);
      AppNavigator.push(
          context: context,
          screen: ProductDetailScreen(
            comparisonId: widget.comparisonId,
            productId: product.id,
            storeName: selectedStore,
            productName: product.name,
            imageURL: product.imageURL,
            description: product.description,
            price1: double.tryParse(product.price ?? "") ?? 0.0,
            price2: null,
            size1: product.size,
            size2: product.size2 ?? "",
          ));
    }
    if (selectedStore == "Hoogvliet") {
      var product = productsProvider.hoogvlietProducts.firstWhere(
          (product) => product.url == productLink);
      AppNavigator.push(
          context: context,
          screen: ProductDetailScreen(
            comparisonId: widget.comparisonId,
            productId: product.id,
            storeName: selectedStore,
            productName: product.name,
            imageURL: product.imageURL,
            description: product.description,
            price1: double.tryParse(product.price ?? "") ?? 0.0,
            price2: null,
            size1: product.size,
            size2: product.size2 ?? "",
          ));
    }
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
                        "Add to list",
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
                          "Share",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Quantity",
                    style: TextStyles.textViewMedium12
                        .copyWith(color: Colors.grey),
                  ),
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (quantity > 0) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          icon: Icon(Icons.remove),
                          color: verdigris,
                        ),
                        VerticalDivider(),
                        Text(
                          quantity.toString(),
                          style: TextStyles.textViewMedium18,
                        ),
                        VerticalDivider(),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                ++quantity;
                              });
                            },
                            icon: Icon(Icons.add),
                            color: verdigris),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              if (comparisonItems.isNotEmpty) ...[
                Text(
                  "Price Comparison",
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
                      "The prices shown are available online and may not reflect in store. Confirm prices before visiting the store",
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
                "Sizes",
                style: TextStyles.textViewSemiBold18,
              ),
              ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: productSizes.map((size) {
                    var index = productSizes.indexOf(size);
                    print(size.price);
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
                              color: selectedSizeIndex == index
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
                                  "BEST VALUE",
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
              Text("Description",
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
