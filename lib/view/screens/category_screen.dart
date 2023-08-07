import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/components/search_appBar.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/components/search_widget.dart';
import 'package:bargainb/view/screens/subcategory_screen.dart';
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
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/screens/product_detail_screen.dart';
import 'package:translator/translator.dart';

import '../../config/routes/app_navigator.dart';
import '../../models/product.dart';
import '../../utils/tracking_utils.dart';
import '../widgets/discountItem.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key, required this.category}) : super(key: key);
  final String category;
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  var isLoading = false;
  TextStyle textButtonStyle = TextStylesInter.textViewRegular16.copyWith(color: mainPurple);
  bool switchValue = false;
  int counter = 0;
  bool isSortOpen = false;
  String sortDropdownValue = 'Sort';
  String brandDropdownValue = 'Brand';
  String storeDropdownValue = 'Store';
  String categoryName = '';

  List<Widget> chips = [];
  List<Widget> chipsToShow = [];
  int maxChipsToShow = 6;
  List<Product> products = [];
  late Future getProductsByCategoryFuture;
  List results = [];

  @override
  void initState() {
    try{
      TrackingUtils().trackPageVisited("Category screen", FirebaseAuth.instance.currentUser!.uid);
    }catch(e){

    }
    var productProvider = Provider.of<ProductsProvider>(context,listen: false);
    getProductsByCategoryFuture = productProvider.getProductsByCategory(widget.category, 0);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<ProductsProvider>(context, listen: false).categories.forEach((element) {
      if (element.category == widget.category) {
        categoryName = element.category;
        var subCategoriesList = element.subcategories.split(","); //dutch subcategories
        if (subCategoriesList.isNotEmpty) {
          subCategoriesList.forEach((subCategory) {
            var subCategoryIndex = subCategoriesList.indexOf(subCategory);
            var subCategoryLabel = subCategory;
            chips.add(Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: FutureBuilder(
                    future: GoogleTranslator().translate(subCategoryLabel, to: "nl"),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) return Container();
                      var translatedSubCategory = "";
                      try {
                        translatedSubCategory = snapshot.data!.text;
                      }catch(e){
                        translatedSubCategory = "N/A";
                        print(e);
                      }
                      if (context.locale.languageCode == "nl") {
                        return Flexible(
                          child: Text(
                            translatedSubCategory,
                          ),
                        );
                      }

                      return Text(subCategoryLabel);
                    }),
                labelStyle: const TextStyle(color: mainPurple),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                backgroundColor: purple10,
                selected: false,
                onSelected: (bool value) {
                  AppNavigator.push(
                      context: context,
                      screen: SubCategoryScreen(subCategory: subCategory, subCategoryLabel: subCategoryLabel));
                },
              ),
            ));
          });
        }
      }
    });
    if (chips.isNotEmpty) {
      if (chips.length > 6 && chipsToShow.length < chips.length) {
        chipsToShow = chips.getRange(0, 6).toList();

        chipsToShow.add(
          ChoiceChip(
            label: Text("ShowMore".tr()),
            labelStyle: const TextStyle(color: black2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            selected: false,
            backgroundColor: Colors.transparent,
            onSelected: (bool value) {
              setState(() {
                chipsToShow.clear();
                chipsToShow.addAll(chips);
                chipsToShow.add(ChoiceChip(
                  label: Text("ShowLess".tr()),
                  labelStyle: const TextStyle(color: black2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  selected: false,
                  backgroundColor: Colors.transparent,
                  onSelected: (bool value) {
                    setState(() {
                      chipsToShow.clear();
                      chipsToShow = chips.getRange(0, 6).toList();
                      chipsToShow.add(showMoreButton());
                    });
                  },
                ));
              });
            },
          ),
        );
      } else {
        chipsToShow = chips;
      }
    }
    super.didChangeDependencies();
  }

  Widget showMoreButton() {
    return ChoiceChip(
      label: Text("ShowMore".tr()),
      labelStyle: const TextStyle(color: black2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      selected: false,
      backgroundColor: Colors.transparent,
      onSelected: (bool value) {
        setState(() {
          chipsToShow.clear();
          chipsToShow.addAll(chips);
          chipsToShow.add(ChoiceChip(
            label: Text("ShowLess".tr()),
            labelStyle: const TextStyle(color: black2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            selected: false,
            backgroundColor: Colors.transparent,
            onSelected: (bool value) {
              setState(() {
                chipsToShow.clear();
                chipsToShow = chips.getRange(0, 6).toList();
                chipsToShow.add(showMoreButton());
              });
            },
          ));
        });
      },
    );
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
        results =
            products.where((product) => product?.storeName == "Albert").toList();
      }else{
        results =
            products.where((product) => product?.storeName == storeDropdownValue).toList();
      }
    }
    if (sortDropdownValue != "Sort" && storeDropdownValue != "Store") {
      if (storeDropdownValue == "Albert Heijn") {
        results =
            products.where((product) => product?.storeName == "Albert").toList();
      }else{
        results =
            products.where((product) => product?.storeName == storeDropdownValue).toList();
      }
      results = productProvider.sortProducts(sortDropdownValue, results);
    }
    try{
    TrackingUtils().trackSearchPerformed("$sortDropdownValue, $storeDropdownValue", FirebaseAuth.instance.currentUser!.uid, "");
    }catch(e){

    }
    return results;
  }


  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductsProvider>(context,listen: false);
    results = filterProducts(results, products, productProvider);
    return Scaffold(
      backgroundColor: white,
      appBar: SearchAppBar(
        isBackButton: true,
      ),
      body: WillPopScope(
        onWillPop: () {
          FocusScope.of(context).unfocus();
          AppNavigator.popToFrist(context: context);
          return Future.value(true);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: GoogleTranslator().translate(categoryName, to: "nl"),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) return Container();
                      var translatedCategory = "";
                      try{
                        translatedCategory = snapshot.data!.text;
                      }catch(e){
                        translatedCategory = "N/A";
                        print(e);
                      }
                      if (context.locale.languageCode == "nl") {
                        return Flexible(
                          child: Text(
                            translatedCategory,
                            style: TextStylesInter.textViewSemiBold16.copyWith(color: black2),
                          ),
                        );
                      }
                      return Text(
                        categoryName,
                        style: TextStylesInter.textViewSemiBold16.copyWith(color: black2),
                      );
                    }),
                16.ph,
                Row(
                    children: [
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
                          items:
                          <String>['Sort', 'Low price', 'High price'].map<DropdownMenuItem<String>>((String value) {
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
                20.ph,
                Text(
                  "Subcategories".tr(),
                  style: TextStylesInter.textViewSemiBold16.copyWith(color: black2),
                ),
                chipsToShow.isNotEmpty
                    ? choiceChips()
                    : Center(
                        child: Text(
                          "NoSubcategoriesFound".tr(),
                          style: TextStylesInter.textViewMedium10.copyWith(color: black),
                        ),
                      ),
                10.ph,
                    products.isEmpty ?
                       Column(
                        children: [30.ph, Center(child: Text("NoProductsFound".tr()))],
                      ) :
                    FutureBuilder(
                      future: getProductsByCategoryFuture,
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        List products = snapshot.data ?? [];
                        if(products.isEmpty) return Center(child: Text("NoProductsFound".tr()));
                        return GridView.builder(
                            physics: ScrollPhysics(), // to disable GridView's scrolling
                            shrinkWrap: true,
                            // padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                              return DiscountItem(product: p, inGridView: false,);
                            });
                      }
                    ),
                10.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget choiceChips() {
    return Wrap(
      spacing: 6,
      direction: Axis.horizontal,
      children: chipsToShow,
    );
  }

}
