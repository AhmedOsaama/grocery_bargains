import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/products_provider.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/components/search_delegate.dart';
import 'package:bargainb/view/components/search_widget.dart';
import 'package:bargainb/view/screens/category_screen.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:translator/translator.dart';

import '../../config/routes/app_navigator.dart';
import '../components/search_appBar.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  void initState() {
    try{
    TrackingUtils().trackPageVisited("All categories screen", FirebaseAuth.instance.currentUser!.uid);
    }catch(e){

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: SearchAppBar(isBackButton: true,),
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
                        (index) {
                          var category = provider.categories[index].category;
                          return GestureDetector(
                              onTap: () => AppNavigator.pushReplacement(
                                  context: context,
                                  screen: CategoryScreen(
                                    category: category,
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
                                        errorBuilder: (_,p,x){
                                          return SvgPicture.asset(imageError);
                                        },
                                      ),
                                    ),
                                    FutureBuilder(
                                      future: GoogleTranslator().translate(category, to: "nl"),
                                      builder: (context, snapshot) {
                                        if(snapshot.connectionState == ConnectionState.waiting) return Container();
                                        var translatedCategory = snapshot.data!.text;
                                        if(context.locale.languageCode == "nl"){
                                         return Flexible(
                                            child: Text(
                                              translatedCategory,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStylesInter.textView16
                                                  .copyWith(color: black2),
                                            ),
                                          );
                                        }
                                        return Flexible(
                                          child: Text(
                                            category,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStylesInter.textView16
                                                .copyWith(color: black2),
                                          ),
                                        );
                                      }
                                    ),
                                  ]),
                            );
                        }),
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
