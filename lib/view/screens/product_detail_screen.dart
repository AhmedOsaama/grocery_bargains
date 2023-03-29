import 'package:cloud_firestore/cloud_firestore.dart';
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

class ProductDetailScreen extends StatefulWidget {
  final String storeName;
  final String productName;
  final String imageURL;
  final String description;
  final double price;
  final String oldPrice;
  final String size1;
  final String size2;
  final String bestValueSize;
  const ProductDetailScreen(
      {Key? key,
      required this.storeName,
      required this.productName,
      required this.imageURL,
      required this.description,
      required this.price,
      required this.oldPrice, required this.size1, required this.size2, required this.bestValueSize})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // final productImages = [milk, peach, spar];
  final productSizes = [];
  bool isLoading = false;
  final comparisonItems = [
    PriceComparisonItem(),
    PriceComparisonItem(),
    PriceComparisonItem(),
  ];

  var selectedIndex = 0;
  var selectedSizeIndex = 0;

  int quantity = 1;

  Future fetch() async {
    setState(() {
      comparisonItems.addAll([
        PriceComparisonItem(),
        PriceComparisonItem(),
        PriceComparisonItem(),
        PriceComparisonItem(),
      ]);
    });
  }

  List<Map> allLists = [];

  @override
  void initState() {
    productSizes.addAll([widget.size1,widget.size2]);
    super.initState();
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
                          Provider.of<ChatlistsProvider>(context, listen: false)
                              .showChooseListDialog(
                            context: context,
                            isSharing: false,
                            listItem: ListItem(
                                name: widget.productName,
                                oldPrice: widget.oldPrice,
                                price: widget.price,
                                isChecked: false,
                                quantity: quantity,
                                imageURL: widget.imageURL,
                                size: widget.bestValueSize),
                          );
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
                      Provider.of<ChatlistsProvider>(context, listen: false)
                          .showChooseListDialog(
                        context: context,
                        isSharing: true,
                        listItem: ListItem(
                            name: widget.productName,
                            oldPrice: widget.oldPrice,
                            price: widget.price,
                            isChecked: false,
                            quantity: quantity,
                            imageURL: widget.imageURL,
                            size: widget.bestValueSize),
                      );
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
                  priceAlertButton,
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
              Text(
                "Price Comparison",
                style: TextStyles.textViewSemiBold18.copyWith(color: prussian),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: comparisonItems.length + 1,
                itemBuilder: (context, index) {
                  if (index < comparisonItems.length) {
                    return comparisonItems[index];
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: verdigris,
                            ))
                          : Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await Future.delayed(Duration(seconds: 1));
                                    await fetch();
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "See more",
                                          style: TextStyles.textViewMedium10
                                              .copyWith(color: prussian),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
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
                },
              ),
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
                      "The price shown are available online and may not reflect in store. Confirm prices before visiting store",
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
                                  ? verdigris
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.network(widget.imageURL),
                            SizedBox(
                              width: 15.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  size,
                                  style: TextStyles.textViewSemiBold16,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "\$${size}",
                                      style: TextStyles.textViewMedium12
                                          .copyWith(
                                              color: Color.fromRGBO(
                                                  108, 197, 29, 1)),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      size,
                                      style: TextStyles.textViewRegular12
                                          .copyWith(color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            )
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
