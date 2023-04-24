import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/components/plus_button.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/screens/product_detail_screen.dart';

import '../../config/routes/app_navigator.dart';
import '../../models/product.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({Key? key, required this.subCategory})
      : super(key: key);
  final String subCategory;
  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;

  var isLoading = false;
  TextStyle textButtonStyle =
      TextStylesInter.textViewRegular16.copyWith(color: mainPurple);
  bool switchValue = false;

  int? _selectedIndex;
  String sortDropdownValue = 'Sort';
  String sizeDropdownValue = 'Size';
  String brandDropdownValue = 'Brand';
  String storeDropdownValue = 'Store';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        title: Text(
          "Search result",
          style: TextStylesInter.textViewSemiBold17.copyWith(color: black2),
        ),
        leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              AppNavigator.pop(context: context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: black,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              GenericField(
                isFilled: true,
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  return showSearch(
                      context: context, delegate: MySearchDelegate(pref));
                },
                prefixIcon: Icon(Icons.search),
                borderRaduis: 999,
                boxShadow: BoxShadow(
                  color: shadowColor,
                  blurRadius: 28.0,
                ),
              ),
              15.ph,
              // SizedBox(
              //   height: 30.h,
              //   child: Row(children: [
              //     Container(
              //       width: 70.w,
              //       decoration: BoxDecoration(
              //           color: white,
              //           border: Border.all(color: dropBorderColor),
              //           borderRadius: BorderRadius.all(Radius.circular(4.r))),
              //       child: Center(
              //         child: DropdownButton<String>(
              //           value: sortDropdownValue,
              //           icon: Icon(
              //             Icons.keyboard_arrow_down,
              //             color: mainPurple,
              //           ),
              //           iconSize: 24,
              //           //elevation: 16,
              //           underline: Container(),
              //           style: TextStyle(color: purple50, fontSize: 16.sp),
              //           borderRadius: BorderRadius.circular(4.r),
              //           onChanged: (String? newValue) {
              //             setState(() {
              //               sortDropdownValue = newValue!;
              //             });
              //           },
              //           items: <String>['Sort', 'Two', 'Free', 'Four']
              //               .map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value,
              //               child: Text(value),
              //             );
              //           }).toList(),
              //         ),
              //       ),
              //     ),
              //     8.pw,
              //     Container(
              //       width: 80.w,
              //       decoration: BoxDecoration(
              //           color: white,
              //           border: Border.all(color: dropBorderColor),
              //           borderRadius: BorderRadius.all(Radius.circular(4.r))),
              //       child: Center(
              //         child: DropdownButton<String>(
              //           value: brandDropdownValue,
              //           icon: Icon(
              //             Icons.keyboard_arrow_down,
              //             color: mainPurple,
              //           ),
              //           iconSize: 24,
              //           //elevation: 16,
              //           underline: Container(),
              //           style: TextStyle(color: purple50, fontSize: 16.sp),
              //           borderRadius: BorderRadius.circular(4.r),
              //           onChanged: (String? newValue) {
              //             setState(() {
              //               brandDropdownValue = newValue!;
              //             });
              //           },
              //           items: <String>['Brand', 'Two', 'Free', 'Four']
              //               .map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value,
              //               child: Text(value),
              //             );
              //           }).toList(),
              //         ),
              //       ),
              //     ),
              //     8.pw,
              //     Container(
              //       width: 76.w,
              //       decoration: BoxDecoration(
              //           color: white,
              //           border: Border.all(color: dropBorderColor),
              //           borderRadius: BorderRadius.all(Radius.circular(4.r))),
              //       child: Center(
              //         child: DropdownButton<String>(
              //           value: storeDropdownValue,
              //           icon: Icon(
              //             Icons.keyboard_arrow_down,
              //             color: mainPurple,
              //           ),
              //           iconSize: 24,
              //           //elevation: 16,
              //           underline: Container(),
              //           style: TextStyle(color: purple50, fontSize: 16.sp),
              //           borderRadius: BorderRadius.circular(4.r),
              //           onChanged: (String? newValue) {
              //             setState(() {
              //               storeDropdownValue = newValue!;
              //             });
              //           },
              //           items: <String>['Store', 'Two', 'Free', 'Four']
              //               .map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value,
              //               child: Text(value),
              //             );
              //           }).toList(),
              //         ),
              //       ),
              //     ),
              //     8.pw,
              //     Container(
              //       width: 68.w,
              //       decoration: BoxDecoration(
              //           color: white,
              //           border: Border.all(color: dropBorderColor),
              //           borderRadius: BorderRadius.all(Radius.circular(4.r))),
              //       child: Center(
              //         child: DropdownButton<String>(
              //           value: sizeDropdownValue,
              //           icon: Icon(
              //             Icons.keyboard_arrow_down,
              //             color: mainPurple,
              //           ),
              //           underline: Container(),
              //           iconSize: 24,
              //           //elevation: 16,
              //           style: TextStyle(color: purple50, fontSize: 16.sp),
              //           borderRadius: BorderRadius.circular(4.r),
              //           onChanged: (String? newValue) {
              //             setState(() {
              //               sizeDropdownValue = newValue!;
              //             });
              //           },
              //           items: <String>['Size', 'Two', 'Free', 'Four']
              //               .map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value,
              //               child: Text(value),
              //             );
              //           }).toList(),
              //         ),
              //       ),
              //     ),
              //   ]),
              // ),            //TODO: uncomment filters section
              15.ph,
              Text(
                widget.subCategory,
                style:
                    TextStylesInter.textViewSemiBold16.copyWith(color: black2),
              ),
              10.ph,
              SingleChildScrollView(
                child: Container(
                  //  height: ScreenUtil().screenHeight,
                  child: Consumer<ProductsProvider>(
                    builder: (ctx, provider, _) {
                      var products =
                          provider.getProductsBySubCategory(widget.subCategory);
                      if (provider.albertProducts.isEmpty &&
                          provider.jumboProducts.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (products.isEmpty) {
                        return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              50.ph,
                              Text("No products matches this category"),
                            ],
                          ),
                        );
                      }
                      return GridView.builder(
                          physics:
                              ScrollPhysics(), // to disable GridView's scrolling
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 0.6,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: products.length,
                          itemBuilder: (BuildContext ctx, index) {
                            var oldPriceExists = true;
                            if (products.elementAt(index).oldPrice == null) {
                              products.elementAt(index).oldPrice = "";
                              oldPriceExists = false;
                            }
                            if (products.elementAt(index).oldPrice == "") {
                              oldPriceExists = false;
                            }
                            if (oldPriceExists) {
                              if ((double.parse(
                                          products.elementAt(index).oldPrice!) -
                                      double.parse(
                                          products.elementAt(index).price)) <=
                                  0) {
                                oldPriceExists = false;
                              }
                            }

                            if (products.elementAt(index).size2 == null) {
                              products.elementAt(index).size2 = "";
                            }

                            Product p = Product(
                                id: products.elementAt(index).id,
                                oldPrice:
                                    products.elementAt(index).oldPrice ?? "",
                                storeName: products.elementAt(index).storeName,
                                name: products.elementAt(index).name,
                                url: products.elementAt(index).url,
                                category: products.elementAt(index).category,
                                price: products.elementAt(index).price,
                                size: products.elementAt(index).size,
                                imageURL: products.elementAt(index).imageURL,
                                description:
                                    products.elementAt(index).description,
                                size2: products.elementAt(index).size2 ?? "");
                            return GestureDetector(
                              onTap: () => AppNavigator.push(
                                  context: context,
                                  screen: ProductDetailScreen(
                                    comparisonId: -1,
                                    productId: p.id,
                                    oldPrice: p.oldPrice ?? "",
                                    storeName: p.storeName,
                                    productName: p.name,
                                    imageURL: p.imageURL,
                                    description: p.description,
                                    size1: p.size,
                                    size2: p.size2 ?? "",
                                    price1: double.tryParse(p.price) ?? 0.0,
                                    price2:
                                        double.tryParse(p.price2 ?? "") ?? 0.0,
                                  )),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    new BoxShadow(
                                        color: shadowColor,
                                        blurRadius: 20.0,
                                        offset: Offset(0, 20)),
                                  ],
                                ),
                                child: Card(
                                  elevation: 50,
                                  shadowColor: shadowColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            45.ph,
                                            Row(
                                              children: [
                                                40.pw,
                                                Container(
                                                  width: 60.w,
                                                  height: 60.h,
                                                  child: CachedNetworkImage(
                                                    imageUrl: products
                                                        .elementAt(index)
                                                        .imageURL,
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Icon(Icons
                                                            .no_photography),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  15.ph,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      25.pw,
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 40.h,
                                                          width: ScreenUtil()
                                                                  .screenWidth *
                                                              0.3,
                                                          child: Text(
                                                            products
                                                                .elementAt(
                                                                    index)
                                                                .name,
                                                            style: TextStylesInter
                                                                .textViewBold16
                                                                .copyWith(
                                                                    color:
                                                                        black2),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  5.ph,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      25.pw,
                                                      Text(
                                                        products
                                                            .elementAt(index)
                                                            .size,
                                                        style: TextStylesInter
                                                            .textViewMedium12
                                                            .copyWith(
                                                                color:
                                                                    darkGrey),
                                                      ),
                                                    ],
                                                  ),
                                                  30.ph,
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      20.pw,
                                                      Text(
                                                        "€" +
                                                            products
                                                                .elementAt(
                                                                    index)
                                                                .price,
                                                        style: TextStylesInter
                                                            .textViewMedium15
                                                            .copyWith(
                                                                color: black2),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                  5.ph,
                                                  oldPriceExists
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            20.pw,
                                                            Text(
                                                              "€" +
                                                                  products
                                                                      .elementAt(
                                                                          index)
                                                                      .oldPrice!,
                                                              style: TextStylesInter
                                                                  .textViewMedium10
                                                                  .copyWith(
                                                                      color:
                                                                          black2,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                            ),
                                                            (double.parse(products
                                                                            .elementAt(
                                                                                index)
                                                                            .oldPrice!) -
                                                                        double.parse(products
                                                                            .elementAt(index)
                                                                            .price)) >
                                                                    0
                                                                ? Text(
                                                                    " €" +
                                                                        (double.parse(products.elementAt(index).oldPrice!) -
                                                                                double.parse(products.elementAt(index).price))
                                                                            .toStringAsFixed(2) +
                                                                        " less",
                                                                    style: TextStylesInter
                                                                        .textViewMedium10
                                                                        .copyWith(
                                                                            color:
                                                                                green),
                                                                  )
                                                                : Container()
                                                          ],
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: SvgPicture.asset(
                                                    chatShare)),
                                            Column(
                                              children: [
                                                PlusButton(onTap: () {}),
                                                20.ph
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
              10.ph,
            ],
          ),
        ),
      ),
    );
  }

  Widget choiceChips(List<String> subs) {
    List<Widget> chips = [];

    for (int i = 0; i < subs.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          label: Text(subs[i]),
          labelStyle: const TextStyle(color: mainPurple),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
          backgroundColor: purple10,
          selected: _selectedIndex == i,
          selectedColor: Colors.black,
          onSelected: (bool value) {
            setState(() {
              _selectedIndex = i;
            });
          },
        ),
      );
      chips.add(item);
    }
    return Wrap(
      spacing: 6,
      direction: Axis.horizontal,
      children: chips,
    );
  }

  Future fetch(int startingIndex) {
    return Provider.of<ProductsProvider>(context, listen: false)
        .getProducts(startingIndex);
  }
}
