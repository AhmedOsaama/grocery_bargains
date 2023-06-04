import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/screens/categories_screen.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/generic_field.dart';

import '../../config/routes/app_navigator.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: white,
        title: Text(
          "allCategories".tr(),
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
                  hintText: LocaleKeys.whatAreYouLookingFor.tr(),
                  hintStyle:
                      TextStyles.textViewSemiBold14.copyWith(color: gunmetal),
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
                Consumer<ProductsProvider>(builder: (ctx, provider, _) {
                  if (provider.categories.isNotEmpty)
                    return GridView.count(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 10,
                      childAspectRatio: (MediaQuery.of(context).size.width) *
                          0.88 /
                          (MediaQuery.of(context).size.height / 2),
                      children: List.generate(
                          provider.categories.length,
                          (index) => GestureDetector(
                                onTap: () => AppNavigator.pushReplacement(
                                    context: context,
                                    screen: CategoriesScreen(
                                      category: provider.categories
                                          .elementAt(index)
                                          .category,
                                    )),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 174.w,
                                        height: 174.h,
                                        child: Image.asset(
                                          provider.categories
                                              .elementAt(index)
                                              .image,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          context.locale.languageCode != "nl"
                                              ? provider.categories
                                                  .elementAt(index)
                                                  .englishCategory
                                              : provider.categories
                                                  .elementAt(index)
                                                  .category,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStylesInter.textView16
                                              .copyWith(color: black2),
                                        ),
                                      ),
                                    ]),
                              )),
                      crossAxisCount: 2,
                    );
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
