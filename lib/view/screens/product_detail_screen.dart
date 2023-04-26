import 'package:bargainb/models/comparison_product.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/view/widgets/signin_dialog.dart';
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
      productComparison = Provider.of<ProductsProvider>(context, listen: false)
          .comparisonProducts
          .firstWhere((comparisonProduct) =>
              comparisonProduct.id == widget.comparisonId);
      comparisonItems.add(PriceComparisonItem(
          price: productComparison.jumboPrice,
          size: productComparison.jumboSize ?? "N/A",
          storeImagePath: jumbo));
      comparisonItems.add(PriceComparisonItem(
          price: productComparison.albertPrice,
          size: productComparison.albertPrice,
          storeImagePath: albert));
      comparisonItems.add(PriceComparisonItem(
          price: productComparison.hoogvlietPrice,
          size: productComparison.hoogvlietSize,
          storeImagePath: hoogLogo));
    } catch (e) {
      print("Failed to get price comparisons in product detail");
    }

    super.didChangeDependencies();
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
                      errorBuilder: (ctx,_,s) => Icon(Icons.no_photography),
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
                                  size: widget.size1),
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
                            builder: (ctx) =>
                                SigninDialog(
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
                              size: widget.size1),
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
                    // if (index < comparisonItems.length) {
                    return comparisonItems[index];
                    // }
                    // else
                    // {
                    //   return Padding(
                    //     padding: EdgeInsets.symmetric(vertical: 32),
                    //     child: isLoading
                    //         ? Center(
                    //             child: CircularProgressIndicator(
                    //             color: verdigris,
                    //           ))
                    //         : Center(
                    //             child: Container(
                    //               decoration: BoxDecoration(
                    //                 border: Border.all(color: Colors.grey),
                    //                 borderRadius: BorderRadius.circular(12),
                    //               ),
                    //               child: InkWell(
                    //                 onTap: () async {
                    //                   setState(() {
                    //                     isLoading = true;
                    //                   });
                    //                   await Future.delayed(Duration(seconds: 1));
                    //                   await fetch();
                    //                   setState(() {
                    //                     isLoading = false;
                    //                   });
                    //                 },
                    //                 borderRadius: BorderRadius.circular(12),
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.all(5),
                    //                   child: Row(
                    //                     mainAxisSize: MainAxisSize.min,
                    //                     children: [
                    //                       Text(
                    //                         "See more",
                    //                         style: TextStyles.textViewMedium10
                    //                             .copyWith(color: prussian),
                    //                       ),
                    //                       Icon(
                    //                         Icons.keyboard_arrow_down,
                    //                         size: 18,
                    //                         color: Colors.grey,
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //   );
                    // }
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
                    if (size.size.isEmpty) {
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
                              errorBuilder: (ctx,_,s) => Icon(Icons.no_photography),
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
