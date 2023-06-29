import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/components/search_widget.dart';
import 'package:bargainb/view/screens/category_screen.dart';

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
      body: WillPopScope(
        onWillPop: () {
          FocusScope.of(context).unfocus();
          AppNavigator.popToFrist(context: context);
          return Future.value(true);
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.h,
              ),
              SearchWidget(isBackButton: true),
              SizedBox(
                height: 10.h,
              ),
              Consumer<ProductsProvider>(builder: (ctx, provider, _) {
                if (provider.categories.isNotEmpty)
                  return GridView.count(
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 15),
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
                                  screen: CategoryScreen(
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
    );
  }
}
