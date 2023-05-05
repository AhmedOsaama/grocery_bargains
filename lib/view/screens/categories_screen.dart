import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/components/plus_button.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/screens/subcategories_screen.dart';
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
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/screens/product_detail_screen.dart';

import '../../config/routes/app_navigator.dart';
import '../../models/product.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key, required this.category}) : super(key: key);
  final String category;
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;

  var isLoading = false;
  TextStyle textButtonStyle =
      TextStylesInter.textViewRegular16.copyWith(color: mainPurple);
  bool switchValue = false;
  bool isSortOpen = false;
  String sortDropdownValue = 'Sort';
  String brandDropdownValue = 'Brand';
  String storeDropdownValue = 'Store';

  @override
  void initState() {
    super.initState();
  }

  List<Product> products = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: white,
        title: Text(
          "Search result",
          style: TextStylesInter.textViewSemiBold17.copyWith(color: black2),
        ),
        leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();

              AppNavigator.popToFrist(context: context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: black,
            )),
      ),
      body: WillPopScope(
        onWillPop: () {
          FocusScope.of(context).unfocus();
          AppNavigator.popToFrist(context: context);
          return Future.value(true);
        },
        child: SingleChildScrollView(
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
                        context: context,
                        delegate: MySearchDelegate(pref, true));
                  },
                  prefixIcon: Icon(Icons.search),
                  borderRaduis: 999,
                  boxShadow: BoxShadow(
                    color: shadowColor,
                    blurRadius: 28.0,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Subcategories",
                  style: TextStylesInter.textViewSemiBold16
                      .copyWith(color: black2),
                ),
                Consumer<ProductsProvider>(builder: (c, provider, _) {
                  String sub = "";
                  List<String> subCategories = [];
                  provider.categories.forEach((element) {
                    if (element.category == widget.category) {
                      sub = element.subcategories;
                    }
                  });
                  if (sub.isNotEmpty) {
                    sub.split(",").forEach((element) {
                      subCategories.add(element);
                    });
                  }
                  if (subCategories.isNotEmpty) {
                    return choiceChips(subCategories);
                  }
                  return Center(
                    child: Text(
                      "No subcategories found",
                      style: TextStylesInter.textViewMedium10
                          .copyWith(color: black),
                    ),
                  );
                }),
                16.ph,
                Row(children: [
                  Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: dropBorderColor),
                        borderRadius: BorderRadius.all(Radius.circular(4.r))),
                    child: Center(
                      child: DropdownButton<String>(
                        isExpanded: true,

                        value: sortDropdownValue,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: mainPurple,
                        ),
                        iconSize: 24,
                        //elevation: 16,
                        underline: Container(),
                        style: TextStyle(color: purple50, fontSize: 16.sp),
                        borderRadius: BorderRadius.circular(4.r),
                        onChanged: (String? newValue) {
                          var v = products;
                          setState(() {
                            products = [];
                            sortDropdownValue = newValue!;
                          });

                          v = Provider.of<ProductsProvider>(context,
                                  listen: false)
                              .sortProducts(sortDropdownValue, v);

                          setState(() {
                            products = v;
                          });
                        },
                        items: <String>[
                          'Sort',
                          //'Relevance',
                          'Price low - high',
                          'Price high - low',
                          // 'Nutri Score A - E'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                value,
                                maxLines: 1,
                                style: value == "Sort"
                                    ? TextStyles.textViewRegular16
                                        .copyWith(color: purple50)
                                    : (value == sortDropdownValue
                                        ? TextStyles.textViewRegular10
                                            .copyWith(color: mainPurple)
                                        : TextStyles.textViewRegular10
                                            .copyWith(color: black2)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  8.pw,
                  Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: dropBorderColor),
                        borderRadius: BorderRadius.all(Radius.circular(4.r))),
                    child: Center(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: brandDropdownValue,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: mainPurple,
                        ),
                        iconSize: 24,
                        //elevation: 16,
                        underline: Container(),
                        style: TextStyle(color: purple50, fontSize: 16.sp),
                        borderRadius: BorderRadius.circular(4.r),
                        onChanged: (String? newValue) {
                          var v;
                          setState(() {
                            products = [];
                            brandDropdownValue = newValue!;
                          });

                          v = Provider.of<ProductsProvider>(context,
                                  listen: false)
                              .getProductsByCategory(widget.category,
                                  storeDropdownValue, brandDropdownValue);

                          setState(() {
                            products = v;
                          });
                        },
                        items: <String>[
                          'Brand',
                          'AH',
                          'AH Organic',
                          'Bonduelle',
                          'Heel',
                          'CelaVita',
                          'Innocent',
                          'Iglo',
                          'Sole Valley',
                          'Del Monte',
                          'CoolBest',
                          'Arch',
                          'Chiquita',
                          'Knorr',
                          'Healthy People',
                          'Bieze',
                          'No Fairytales',
                          'Fairtrade Original',
                          'kanzi',
                          'miras',
                          'moon pop',
                          'Pink Lady',
                          'AH Misfits',
                          'Ardos',
                          'Capri Sun',
                          'Drogheria'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                value,
                                maxLines: 1,
                                style: value == "Brand"
                                    ? TextStyles.textViewRegular16
                                        .copyWith(color: purple50)
                                    : (value == brandDropdownValue
                                        ? TextStyles.textViewRegular10
                                            .copyWith(color: mainPurple)
                                        : TextStyles.textViewRegular10
                                            .copyWith(color: black2)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  8.pw,
                  Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: dropBorderColor),
                        borderRadius: BorderRadius.all(Radius.circular(4.r))),
                    child: Center(
                      child: DropdownButton<String>(
                        value: storeDropdownValue,
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: mainPurple,
                        ),
                        iconSize: 24,
                        //elevation: 16,
                        underline: Container(),
                        style: TextStyle(color: purple50, fontSize: 16.sp),
                        borderRadius: BorderRadius.circular(4.r),
                        onChanged: (String? newValue) {
                          var v;
                          setState(() {
                            products = [];
                            storeDropdownValue = newValue!;
                          });

                          v = Provider.of<ProductsProvider>(context,
                                  listen: false)
                              .getProductsByCategory(widget.category,
                                  storeDropdownValue, brandDropdownValue);

                          setState(() {
                            products = v;
                          });
                        },
                        items: <String>['Store', 'Albert', 'Jumbo', 'Hoogvliet']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                value,
                                maxLines: 1,
                                style: value == "Store"
                                    ? TextStyles.textViewRegular16
                                        .copyWith(color: purple50)
                                    : (value == storeDropdownValue
                                        ? TextStyles.textViewRegular10
                                            .copyWith(color: mainPurple)
                                        : TextStyles.textViewRegular10
                                            .copyWith(color: black2)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ]),
                16.ph,
                Text(
                  widget.category,
                  style: TextStylesInter.textViewSemiBold16
                      .copyWith(color: black2),
                ),
                10.ph,
                SingleChildScrollView(
                  child: Container(
                    //  height: ScreenUtil().screenHeight,
                    child: Builder(
                      builder: (ctx) {
                        if (sortDropdownValue == "Sort" &&
                            brandDropdownValue == "Brand" &&
                            storeDropdownValue == "Store") {
                          products = Provider.of<ProductsProvider>(context)
                              .getProductsByCategory(
                                  widget.category, "Store", "Brand");
                        }
                        if (Provider.of<ProductsProvider>(context,
                                    listen: false)
                                .albertProducts
                                .isEmpty &&
                            Provider.of<ProductsProvider>(context,
                                    listen: false)
                                .jumboProducts
                                .isEmpty &&
                            Provider.of<ProductsProvider>(context,
                                    listen: false)
                                .hoogvlietProducts
                                .isEmpty) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (products.isEmpty)
                          return Column(
                            children: [
                              30.ph,
                              Center(child: Text("No products found !"))
                            ],
                          );
                        return GridView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    mainAxisExtent: 260,
                                    childAspectRatio: 0.67,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
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
                                if ((double.parse(products
                                            .elementAt(index)
                                            .oldPrice!) -
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
                                  storeName:
                                      products.elementAt(index).storeName,
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
                                      price2: double.tryParse(p.price2 ?? "") ??
                                          0.0,
                                    )),
                                child: Container(
                                  height: 250.h,
                                  width: 175.w,
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
                                          flex: 4,
                                          child: Column(
                                            children: [
                                              23.ph,
                                              Row(
                                                children: [
                                                  40.pw,
                                                  Container(
                                                    width: 52.w,
                                                    height: 42.h,
                                                    child: CachedNetworkImage(
                                                      imageUrl: products
                                                          .elementAt(index)
                                                          .imageURL,
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
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
                                                          MainAxisAlignment
                                                              .start,
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
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    5.ph,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
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
                                                          MainAxisAlignment
                                                              .start,
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
                                                                  color:
                                                                      black2),
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
                                                                            TextDecoration.lineThrough),
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
                                                                          (double.parse(products.elementAt(index).oldPrice!) - double.parse(products.elementAt(index).price))
                                                                              .toStringAsFixed(2) +
                                                                          " less",
                                                                      style: TextStylesInter
                                                                          .textViewMedium10
                                                                          .copyWith(
                                                                              color: green),
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
                                          flex: 2,
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
                                        10.pw
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
      ),
    );
  }

  Widget choiceChips(List<String> subs) {
    List<Widget> chips = [];

    for (int i = 0; i < subs.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(subs[i]),
          labelStyle: const TextStyle(color: mainPurple),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
          backgroundColor: purple10,
          selected: false,
          onSelected: (bool value) {
            AppNavigator.push(
                context: context,
                screen: SubCategoriesScreen(subCategory: subs[i]));
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
