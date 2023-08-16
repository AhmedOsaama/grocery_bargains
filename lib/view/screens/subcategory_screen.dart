import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/components/search_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../../utils/tracking_utils.dart';
import '../components/button.dart';
import '../components/search_appBar.dart';
import '../widgets/discountItem.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({Key? key, required this.subCategory, required this.subCategoryLabel}) : super(key: key);
  final String subCategory;
  final String subCategoryLabel;
  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  var isLoading = false;
  TextStyle textButtonStyle = TextStylesInter.textViewRegular16.copyWith(color: mainPurple);
  bool switchValue = false;

  int? _selectedIndex;
  String sortDropdownValue = 'Sort';
  String storeDropdownValue = 'Store';
  List products = [];
  List results = [];
  late Future getProductsBySubCategoryFuture;

  var isFetching = false;

  @override
  void initState() {
    var productProvider = Provider.of<ProductsProvider>(context, listen: false);
    try {
      getProductsBySubCategoryFuture = productProvider.getProductsBySubCategory(widget.subCategory, 0);
      TrackingUtils().trackPageVisited("Subcategory Screen", FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {}
    super.initState();
  }

  List filterProducts(List results, List products, ProductsProvider productProvider) {
    if (sortDropdownValue == "Sort" && storeDropdownValue == "Store") {
      results = List.from(products);
    }
    if (sortDropdownValue != "Sort" && storeDropdownValue == "Store") {
      results = productProvider.sortProducts(sortDropdownValue, results);
    }
    if (sortDropdownValue == "Sort" && storeDropdownValue != "Store") {
      if (storeDropdownValue == "Albert Heijn") {
        results = products.where((product) => productProvider.getStoreName(product?.storeId) == "Albert").toList();
      } else {
        results =
            products.where((product) => productProvider.getStoreName(product?.storeId) == storeDropdownValue).toList();
      }
    }
    if (sortDropdownValue != "Sort" && storeDropdownValue != "Store") {
      if (storeDropdownValue == "Albert Heijn") {
        results = products.where((product) => productProvider.getStoreName(product?.storeId) == "Albert").toList();
      } else {
        results =
            products.where((product) => productProvider.getStoreName(product?.storeId) == storeDropdownValue).toList();
      }
      results = productProvider.sortProducts(sortDropdownValue, results);
    }
    try {
      TrackingUtils()
          .trackSearchPerformed("$sortDropdownValue, $storeDropdownValue", FirebaseAuth.instance.currentUser!.uid, "");
    } catch (e) {}
    return results;
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: white,
      appBar: SearchAppBar(
        isBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(color: orange70, borderRadius: BorderRadius.all(Radius.circular(6.r))),
                  child: DropdownButton<String>(
                    value: sortDropdownValue,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: white,
                    ),
                    iconSize: 24,
                    underline: Container(),
                    dropdownColor: orange70,
                    style: TextStyles.textViewMedium12,
                    borderRadius: BorderRadius.circular(4.r),
                    onChanged: (String? newValue) {
                      setState(() {
                        sortDropdownValue = newValue!;
                      });
                    },
                    items: <String>['Sort', 'Low price', 'High price'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyles.textViewMedium12,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                8.pw,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(color: orange70, borderRadius: BorderRadius.all(Radius.circular(6.r))),
                  child: Center(
                    child: DropdownButton<String>(
                      value: storeDropdownValue,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: white,
                      ),
                      iconSize: 24,
                      dropdownColor: orange70,
                      underline: Container(),
                      style: TextStyles.textViewMedium12,
                      borderRadius: BorderRadius.circular(4.r),
                      onChanged: (String? newValue) {
                        setState(() {
                          storeDropdownValue = newValue!;
                        });
                      },
                      items: <String>['Store', 'Albert Heijn', 'Jumbo', 'Hoogvliet']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyles.textViewMedium12,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                8.pw,
              ]),
              15.ph,
              Text(
                widget.subCategoryLabel,
                style: TextStylesInter.textViewSemiBold16.copyWith(color: black2),
              ),
              10.ph,
              FutureBuilder(
                  future: getProductsBySubCategoryFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (products.isEmpty) products.addAll(snapshot.data ?? []);
                    if (products.isEmpty) return Center(child: Text("NoProductsFound".tr()));
                    results = filterProducts(results, products, productProvider);
                    return GridView.builder(
                        physics: ScrollPhysics(), // to disable GridView's scrolling
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisExtent: 260,
                            childAspectRatio: 0.67,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                        itemCount: results.length,
                        itemBuilder: (BuildContext ctx, index) {
                          Product p = Product(
                            id: results.elementAt(index).id,
                            oldPrice: results.elementAt(index).oldPrice ?? "",
                            storeId: results.elementAt(index).storeId,
                            name: results.elementAt(index).name,
                            brand: results.elementAt(index).brand,
                            link: results.elementAt(index).link,
                            category: results.elementAt(index).category,
                            price: results.elementAt(index).price,
                            unit: results.elementAt(index).unit,
                            image: results.elementAt(index).image,
                            description: results.elementAt(index).description,
                            gtin: results.elementAt(index).gtin,
                            subCategory: results.elementAt(index).subCategory,
                            offer: results.elementAt(index).offer,
                            englishName: results.elementAt(index).englishName,
                            similarId: results.elementAt(index).similarId,
                            similarStId: results.elementAt(index).similarStId,
                            availableNow: results.elementAt(index).availableNow,
                            dateAdded: results.elementAt(index).dateAdded,
                          );
                          return DiscountItem(
                            product: p,
                            inGridView: false,
                          );
                        });
                  }),
              isFetching
                  ? Center(child: CircularProgressIndicator())
                  : GenericButton(
                      borderRadius: BorderRadius.circular(10),
                      borderColor: mainPurple,
                      color: Colors.white,
                      onPressed: results.isEmpty
                          ? () {}
                          : () async {
                              setState(() {
                                isFetching = true;
                              });
                              try {
                                var startingIndex = results.last.id + 1;
                                print("StartingIndex: " + startingIndex.toString());
                                var newProducts =
                                    await productProvider.getProductsBySubCategory(widget.subCategory, startingIndex);
                                products.addAll(newProducts);
                              } catch (e) {
                                print(e);
                              }
                              // results = filterProducts(results, products, productProvider);
                              setState(() {
                                isFetching = false;
                              });
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "SEE MORE",
                            style: TextStyles.textViewMedium12.copyWith(color: blackSecondary),
                          ),
                          10.pw,
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                        ],
                      )),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
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
}
