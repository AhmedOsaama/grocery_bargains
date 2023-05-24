import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
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
  late Future getProductsBySubCategoryFuture;

  var isLoading = false;
  TextStyle textButtonStyle =
      TextStylesInter.textViewRegular16.copyWith(color: mainPurple);
  bool switchValue = false;

  int? _selectedIndex;
  String sortDropdownValue = 'Sort';
  String brandDropdownValue = 'Brand';
  String storeDropdownValue = 'Store';

  @override
  void initState() {
    getProductsBySubCategoryFuture =
        Provider.of<ProductsProvider>(context, listen: false)
            .getProductsBySubCategory(widget.subCategory, "Store", "Brand");
    super.initState();
  }

  List<Product> products = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        title: Text(
          "SearchResult".tr(),
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
                      context: context, delegate: MySearchDelegate(pref, true));
                },
                prefixIcon: Icon(Icons.search),
                borderRaduis: 999,
                boxShadow: BoxShadow(
                  color: shadowColor,
                  blurRadius: 28.0,
                ),
              ),
              15.ph,
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
                  child: FutureBuilder(
                    future: getProductsBySubCategoryFuture,
                    builder: (ctx, snapshot) {
                      products = snapshot.data ?? [];
                      if (sortDropdownValue == "Sort" &&
                          brandDropdownValue == "Brand" &&
                          storeDropdownValue == "Store") {
                        // products = provider.getProductsBySubCategory(
                        //     widget.subCategory,
                        //     storeDropdownValue,
                        //     brandDropdownValue);
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (products.isEmpty) {
                        return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              50.ph,
                              Text("NoProductsFound".tr()),
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
                              if ((double.parse(
                                          products.elementAt(index).oldPrice!) -
                                      double.parse(
                                          products.elementAt(index).price ??
                                              products[index].price2!)) <=
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
                              onTap: () async {
                                int comparisonId =
                                    await Provider.of<ProductsProvider>(context,
                                            listen: false)
                                        .getComparisonId(
                                            products.elementAt(index).storeName,
                                            products.elementAt(index).url);
                                AppNavigator.push(
                                    context: context,
                                    screen: ProductDetailScreen(
                                      comparisonId: comparisonId,
                                      productId: p.id,
                                      oldPrice: p.oldPrice ?? "",
                                      storeName: p.storeName,
                                      productName: p.name,
                                      imageURL: p.imageURL,
                                      description: p.description,
                                      size1: p.size,
                                      size2: p.size2 ?? "",
                                      price1:
                                          double.tryParse(p.price ?? "") ?? 0.0,
                                      price2: double.tryParse(p.price2 ?? "") ??
                                          0.0,
                                    ));
                              },
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
                                                            (products
                                                                    .elementAt(
                                                                        index)
                                                                    .price ??
                                                                products[index]
                                                                    .price2!),
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
                                                                        double.parse(products.elementAt(index).price ??
                                                                            products[index].price2!)) >
                                                                    0
                                                                ? Text(
                                                                    " €" +
                                                                        (double.parse(products.elementAt(index).oldPrice!) - double.parse(products.elementAt(index).price ?? products[index].price2!)).toStringAsFixed(
                                                                            2) +
                                                                        "Less"
                                                                            .tr(),
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
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
                                              child: PopupMenuButton(
                                                  position:
                                                      PopupMenuPosition.under,
                                                  color: white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r)),
                                                  child: SvgPicture.asset(
                                                      chatShare),
                                                  itemBuilder: (context) {
                                                    List<
                                                            PopupMenuEntry<
                                                                dynamic>>
                                                        items = [];
                                                    Provider.of<ChatlistsProvider>(
                                                            context,
                                                            listen: false)
                                                        .chatlists
                                                        .forEach((e) => {
                                                              items.add(
                                                                  PopupMenuItem(
                                                                onTap:
                                                                    () async {
                                                                  await Provider.of<ChatlistsProvider>(context, listen: false).shareItemAsMessage(
                                                                      itemName:
                                                                          products[index]
                                                                              .name,
                                                                      itemImage: products
                                                                          .elementAt(
                                                                              index)
                                                                          .imageURL,
                                                                      itemSize: products
                                                                          .elementAt(
                                                                              index)
                                                                          .size,
                                                                      itemPrice: products
                                                                          .elementAt(
                                                                              index)
                                                                          .price,
                                                                      itemOldPrice: products
                                                                          .elementAt(
                                                                              index)
                                                                          .oldPrice,
                                                                      listId:
                                                                          e.id);
                                                                },
                                                                child: Text(
                                                                  e.name,
                                                                  style: TextStyles
                                                                      .textViewSemiBold12
                                                                      .copyWith(
                                                                          color:
                                                                              black2),
                                                                ),
                                                              ))
                                                            });
                                                    return items;
                                                  }),
                                            ),
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    AppNavigator.push(
                                                        context: context,
                                                        screen:
                                                            ProductDetailScreen(
                                                          comparisonId: -1,
                                                          productId: p.id,
                                                          oldPrice:
                                                              p.oldPrice ?? "",
                                                          storeName:
                                                              p.storeName,
                                                          productName: p.name,
                                                          imageURL: p.imageURL,
                                                          description:
                                                              p.description,
                                                          size1: p.size,
                                                          size2: p.size2 ?? "",
                                                          price1:
                                                              double.tryParse(
                                                                      p.price ??
                                                                          "") ??
                                                                  0.0,
                                                          price2:
                                                              double.tryParse(
                                                                      p.price2 ??
                                                                          "") ??
                                                                  0.0,
                                                        ));
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: borderColor),
                                                    ),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: mainPurple,
                                                    ),
                                                  ),
                                                ),
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
