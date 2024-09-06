import 'package:bargainb/features/search/presentation/views/algolia_search_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../../../../../providers/products_provider.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/icons_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';
import '../category_screen.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  Future? getCategoryTranslations;

  Future getAllCategories() async {
    await Provider.of<ProductsProvider>(context, listen: false).getAllCategories();
  }

  Future translateCategories() async {
    var productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    List<Future<Translation>> translatedCategoryList = [];
    productsProvider.categories.forEach((element) {
      var translationFuture = GoogleTranslator().translate(element.category, to: "nl");
      translatedCategoryList.add(translationFuture);
    });
    return Future.wait(translatedCategoryList);
  }

  @override
  void initState() {
    super.initState();
    getAllCategories().then((value) {
      if (context.locale.languageCode == "nl") getCategoryTranslations = translateCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    var allCategories = Provider.of<ProductsProvider>(context).categories;
    return allCategories.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            height: ScreenUtil().screenHeight * 0.16,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: allCategories.map((element) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: allCategories.first == element ? 0 : 10.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        pushNewScreen(context,
                            screen: AlgoliaSearchScreen(
                              category: element.category,
                            ),
                            withNavBar: true);
                        try {
                          TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Open category page",
                              DateTime.now().toUtc().toString(), "Home screen");
                        } catch (e) {
                          print(e);
                          TrackingUtils().trackButtonClick(
                              "Guest", "Open category page", DateTime.now().toUtc().toString(), "Home screen");
                        }
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              element.image,
                              width: 90,
                              height: 60,
                              errorBuilder: (_, p, ctx) {
                                return SvgPicture.asset(imageError);
                              },
                            ),
                            if (context.locale.languageCode == "nl")
                              FutureBuilder(
                                  future: getCategoryTranslations,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) return SizedBox();
                                    var translatedCategories = [];
                                    if (snapshot.data != null) translatedCategories = snapshot.data ?? [];
                                    try {
                                      var translatedCategoryIndex = allCategories.indexOf(element);
                                      return Flexible(
                                        child: Text(
                                          translatedCategories[translatedCategoryIndex].toString(),
                                          maxLines: 3,
                                          textAlign: TextAlign.center,
                                          style: TextStyles.textViewMedium10.copyWith(color: gunmetal),
                                        ),
                                      );
                                    } catch (e) {
                                      print("ERROR: $e");
                                    }
                                    return Text(
                                      element.category,
                                      style: TextStyles.textViewMedium10.copyWith(color: gunmetal),
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                    );
                                  }),
                            Text(
                              element.category,
                              style: TextStyles.textViewMedium10.copyWith(color: gunmetal),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList()),
          );
  }
}
