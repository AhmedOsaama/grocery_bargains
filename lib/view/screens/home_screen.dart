import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/generic_field.dart';
import 'package:swaav/view/screens/product_detail_screen.dart';
import 'package:swaav/view/screens/register_screen.dart';
import 'package:swaav/view/widgets/categoryWidget.dart';
import 'package:swaav/view/widgets/discountItem.dart';
import 'package:swaav/view/widgets/productItem.dart';
import 'package:swaav/view/widgets/search_item.dart';

import '../../config/routes/app_navigator.dart';
import '../../providers/google_sign_in_provider.dart';
import '../../services/dynamic_link_service.dart';
import '../../utils/assets_manager.dart';
import '../../utils/icons_manager.dart';
import '../components/button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;

  @override
  void initState() {
    getUserDataFuture = FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    DynamicLinkService().listenToDynamicLinks(
        context); //case 2 the app is open but in background and opened again via deep link
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                      future: getUserDataFuture,
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator());
                        }
                        return Text(
                          'Hello, ' + snapshot.data!['username'],
                          style: TextStylesDMSans.textViewBold22
                              .copyWith(color: prussian),
                        );
                      }
                  ),
                  FutureBuilder(
                      future: getUserDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        return snapshot.data!['imageURL'] != "" ? CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!['imageURL']),radius: 30,) : SvgPicture.asset(personIcon);
                      }
                  ),
                  GenericButton(
                      onPressed: () async {
                        var pref = await SharedPreferences.getInstance();
                        pref.setBool("rememberMe", false);
                        var isGoogleSignedIn = await Provider.of<GoogleSignInProvider>(context,listen: false).googleSignIn.isSignedIn();
                        if(isGoogleSignedIn) {
                          await Provider.of<GoogleSignInProvider>(context,listen: false).logout();
                        }else{
                          FirebaseAuth.instance.signOut();
                        }
                        AppNavigator.pushReplacement(context: context,screen: RegisterScreen());
                        print("SIGNED OUT...................");
                      },
                      borderRadius: BorderRadius.circular(10),
                      height: 31.h,
                      width: 100.w,
                      child: Text(
                        "Log out",
                        style: TextStyles.textViewBold12,
                      )),
                ],
              ),
              SizedBox(height: 24.h,),
              GenericField(
                isFilled: true,
                onTap: () =>
                    showSearch(context: context, delegate: MySearchDelegate()),
                prefixIcon: Icon(Icons.search),
                borderRaduis: 999,
                hintText: LocaleKeys.whatAreYouLookingFor.tr(),
                hintStyle:
                    TextStyles.textViewSemiBold14.copyWith(color: gunmetal),
              ),
              SizedBox(height: 25.h,),
              Container(
                height: 100.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryWidget(categoryImagePath: vegetables,categoryName: LocaleKeys.vegetables.tr(), color: Colors.green,),
                    CategoryWidget(categoryImagePath: fruits,categoryName: LocaleKeys.fruits.tr(), color: Colors.red,),
                    CategoryWidget(categoryImagePath: beverages,categoryName: LocaleKeys.beverages.tr(), color: Colors.yellow,),
                    CategoryWidget(categoryImagePath: grocery,categoryName: LocaleKeys.grocery.tr(), color: Colors.deepPurpleAccent,),
                    CategoryWidget(categoryImagePath: edibleOil,categoryName: LocaleKeys.edibleOil.tr(), color: Colors.cyan,),
                  ],
                ),
              ),
              SizedBox(height: 30.h,),
              Text(LocaleKeys.recentSearches.tr(),style: TextStylesDMSans.textViewBold16.copyWith(color: prussian),),
              SizedBox(height: 10.h,),
              Container(
                height: 260.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProductItem(price: "8.00", name: "Fresh Peach", quantity: "dozen", imagePath: peach),
                    ProductItem(price: "8.00", name: "Fresh Peach", quantity: "dozen", imagePath: peach),
                    ProductItem(price: "8.00", name: "Fresh Peach", quantity: "dozen", imagePath: peach),
                  ],
                ),
              ),
              SizedBox(height: 30.h,),
              Text(LocaleKeys.latestDiscounts.tr(),style: TextStylesDMSans.textViewBold16.copyWith(color: prussian),),
              SizedBox(height: 10.h,),
              Container(
                height: 250.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    DiscountItem(name: "Avocado", priceBefore: "7.00", priceAfter: "4.00", measurement: "2.0 lbs"),
                    DiscountItem(name: "Pinapple", priceBefore: "7.00", priceAfter: "4.00", measurement: "2.0 lbs"),
                    DiscountItem(name: "Black grape", priceBefore: "7.00", priceAfter: "4.00", measurement: "2.0 lbs"),
                    DiscountItem(name: "Black grape", priceBefore: "7.00", priceAfter: "4.00", measurement: "2.0 lbs"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
//product Item

//discount item

}

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults = ["Rice", "Bread", "Biscuits", "Milk"];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      GestureDetector(
        onTap: () {
          query = '';
        },
        child: Container(
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: grey)),
            child: Icon(
              Icons.close,
              color: Colors.black,
            )),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null), icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        children: [
          GestureDetector(
            onTap: (){
              AppNavigator.push(context: context, screen: ProductDetailScreen());
            },
              child: SearchItem()),
          SearchItem(),
          SearchItem(),
          SearchItem(),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.recentSearches.tr(),
            style: TextStyles.textViewMedium20.copyWith(color: gunmetal),
          ),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (ctx, i) => Divider(),
                itemCount: suggestions.length,
                itemBuilder: (ctx, i) {
                  final suggestion = suggestions[i];
                  return ListTile(
                    title: Text(suggestion),
                    leading: Icon(Icons.search),
                    onTap: () {
                      query = suggestion;
                      showResults(context);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
