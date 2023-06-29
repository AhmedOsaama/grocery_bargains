import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/components/search_widget.dart';
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
import '../widgets/discountItem.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({Key? key, required this.subCategory, required this.subCategoryLabel}) : super(key: key);
  final String subCategory;
  final String subCategoryLabel;
  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  late Future getProductsBySubCategoryFuture;

  var isLoading = false;
  TextStyle textButtonStyle = TextStylesInter.textViewRegular16.copyWith(color: mainPurple);
  bool switchValue = false;

  int? _selectedIndex;
  String sortDropdownValue = 'Sort';
  String brandDropdownValue = 'Brand';
  String storeDropdownValue = 'Store';

  @override
  void initState() {
    getProductsBySubCategoryFuture = Provider.of<ProductsProvider>(context, listen: false)
        .getProductsBySubCategory(widget.subCategory, "Store", "Brand");
    super.initState();
  }

  List<Product> products = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.h,
              ),
              SearchWidget(isBackButton: true),
              // 15.ph,
              15.ph,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  widget.subCategoryLabel,
                  style: TextStylesInter.textViewSemiBold16.copyWith(color: black2),
                ),
              ),
              10.ph,
              Container(
                //  height: ScreenUtil().screenHeight,
                child: FutureBuilder(
                  future: getProductsBySubCategoryFuture,
                  builder: (ctx, snapshot) {
                    products = snapshot.data ?? [];
                    if (sortDropdownValue == "Sort" && brandDropdownValue == "Brand" && storeDropdownValue == "Store") {
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
                        physics: ScrollPhysics(), // to disable GridView's scrolling
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisExtent: 260,
                            childAspectRatio: 0.67,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                        itemCount: products.length,
                        itemBuilder: (BuildContext ctx, index) {
                          Product p = Product(
                              id: products.elementAt(index).id,
                              oldPrice: products.elementAt(index).oldPrice ?? "",
                              storeName: products.elementAt(index).storeName,
                              name: products.elementAt(index).name,
                              brand: products.elementAt(index).brand,
                              url: products.elementAt(index).url,
                              category: products.elementAt(index).category,
                              price: products.elementAt(index).price,
                              price2: products.elementAt(index).price2 ?? "",
                              size: products.elementAt(index).size,
                              imageURL: products.elementAt(index).imageURL,
                              description: products.elementAt(index).description,
                              size2: products.elementAt(index).size2 ?? "");
                          return DiscountItem(product: p, inGridView: false,);
                        });
                  },
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

  Future fetch(int startingIndex) {
    return Provider.of<ProductsProvider>(context, listen: false).getProducts(startingIndex);
  }
}
