import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/widgets/price_comparison_item.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final productImages = [milk, peach, brand];
  final productSizes = ["285 ml", "250 ml", '211 ml'];
  bool isLoading = false;
  final comparisonItems = [
    PriceComparisonItem(),
    PriceComparisonItem(),
    PriceComparisonItem(),
  ];

  var selectedIndex = 0;
  var selectedSizeIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100.h,
              ),
              Text("Albert Heinz "),
              Text("Semi-skimmed milk"),
              Row(
                children: [
                  Column(
                      children: productImages.map((image) {
                    var index = productImages.indexOf(image);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 3),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.0,
                              color: selectedIndex == index
                                  ? verdigris
                                  : Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(image),
                      ),
                    );
                  }).toList()),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      height: 214.h,
                      width: 214.w,
                      child:
                          Image.asset(productImages.elementAt(selectedIndex))),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  addToListButton,
                  shareButton,
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
                          onPressed: () {},
                          icon: Icon(Icons.remove),
                          color: verdigris,
                        ),
                        VerticalDivider(),
                        Text(
                          "3",
                          style: TextStyles.textViewMedium18,
                        ),
                        VerticalDivider(),
                        IconButton(
                            onPressed: () {},
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
              SizedBox(
                height: 20.h,
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
                            Image.asset(milk),
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
                                      "\$2.22 x 4",
                                      style: TextStyles.textViewMedium12
                                          .copyWith(
                                              color: Color.fromRGBO(
                                                  108, 197, 29, 1)),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      "1.50 lbs",
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
              SizedBox(
                height: 20.h,
              ),
              Text("Description", style: TextStyles.textViewSemiBold18),
              const Text(
                  "Et quidem facing, ut summum bonum sit extremum et rationibus conquisitis de voluptate. Sed ut summum bonum sit id,")
            ],
          ),
        ),
      ),
    );
  }

  var addToListButton = Column(
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
          Icons.add_box_outlined,
        ),
      ),
      SizedBox(
        height: 10.h,
      ),
      Text(
        "Add to list",
        style: TextStyles.textViewMedium12.copyWith(color: prussian),
      )
    ],
  );
  var shareButton = Column(
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
        style: TextStyles.textViewMedium12.copyWith(color: prussian),
      )
    ],
  );
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
