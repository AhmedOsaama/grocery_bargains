import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/components/generic_menu.dart';
import 'package:swaav/view/components/nav_bar.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/choose_store_screen.dart';
import 'package:swaav/view/screens/list_view_screen.dart';
import 'package:swaav/view/widgets/backbutton.dart';
import 'package:swaav/view/widgets/store_list.dart';
import 'package:swaav/view/widgets/swaav_list.dart';

import '../../config/routes/app_navigator.dart';
import 'new_list_screen.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({Key? key}) : super(key: key);

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  late Future<QuerySnapshot> getAllListsFuture;
  var isFabPressed = false;
  var storeItems = [ {
    "isChecked": false,
    "itemName": 'Melkan long-life',
    "itemPrice": "1.19"
  },
    {
      "isChecked": true,
      "itemName": 'item name',
      "itemPrice": "1.19"
    }];

  @override
  void initState() {
    getAllListsFuture = FirebaseFirestore.instance
        .collection('/lists')
        .where("userIds", arrayContains: FirebaseAuth.instance.currentUser?.uid)
        .get();
    super.initState();
  }

  bool isAdding = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: getFab(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 91.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.myLists.tr(),
                  style:
                      TextStyles.textViewSemiBold30.copyWith(color: prussian),
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.chat_outlined))
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
                child: FutureBuilder(
                    future: getAllListsFuture,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var allLists = snapshot.data?.docs;
                      if (!snapshot.hasData) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 40.h,
                            ),
                            Text(
                              LocaleKeys.createYourFirstList.tr(),
                              style: TextStyles.textViewMedium23.copyWith(
                                  color: Colors.grey.withOpacity(0.7)),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            SvgPicture.asset(noLists),
                          ],
                        );
                      }
                      return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 24.h,
                                  crossAxisSpacing: 10.w,
                                  childAspectRatio: 2 / 3),
                          itemCount: allLists!.length,
                          itemBuilder: (ctx, i) {
                            return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (ctx) => ListViewScreen(
                                        items: storeItems,
                                          storeName: "SPAR",
                                          listId: allLists[i].id,
                                          listName: allLists[i]['list_name']))),
                              child:
                                  StoreList(
                                    storeImagePath: brand,
                                    storeItems: storeItems,
                                        listName: allLists[i]['list_name']
                                  )
                                  // SwaavList(
                                  //     userImage: peopleIcon,
                                  //     items: [
                                  //       {
                                  //         "isChecked": false,
                                  //         "itemName": 'Melkan long-life',
                                  //       },{
                                  //         "isChecked": false,
                                  //         "itemName": 'Melkan long-life',
                                  //       },{
                                  //         "isChecked": false,
                                  //         "itemName": 'Melkan long-life',
                                  //       },{
                                  //         "isChecked": false,
                                  //         "itemName": 'Melkan long-life',
                                  //       },
                                  //       {
                                  //         "isChecked": false,
                                  //         "itemName": 'Melkan long-life',
                                  //       },
                                  //     ],
                                  //     listName: allLists[i]['list_name']),
                            );
                          });
                    })),
          ],
        ),
      ),
    );
  }

  Widget getFab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFabPressed)
          GenericButton(
              height: 40,
              onPressed: () {
                AppNavigator.push(context: context, screen: const ChooseStoreScreen());
              },
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              shadow: const [
                BoxShadow(
                    blurRadius: 28,
                    offset: Offset(0, 4),
                    color: Color.fromRGBO(59, 59, 59, 0.12))
              ],
              child: Text(
                LocaleKeys.store.tr(),
                style: TextStylesDMSans.textViewBold15
                    .copyWith(color: const Color.fromRGBO(82, 75, 107, 1)),
              )),
        SizedBox(
          height: 10.h,
        ),
        if (isFabPressed)
          GenericButton(
              height: 40,
              onPressed: () {
                AppNavigator.push(context: context, screen: NewListScreen());
              },
              borderRadius: BorderRadius.circular(8),
              shadow: const [
                BoxShadow(
                    blurRadius: 28,
                    offset: Offset(0, 4),
                    color: Color.fromRGBO(59, 59, 59, 0.12))
              ],
              color: Colors.white,
              child: Text(
                LocaleKeys.blank.tr(),
                style: TextStylesDMSans.textViewBold15
                    .copyWith(color: const Color.fromRGBO(82, 75, 107, 1)),
              )),
        SizedBox(
          height: 10.h,
        ),
        GenericButton(
          width: 60,
          height: 60,
          onPressed: () {
            setState(() {
              isFabPressed = !isFabPressed;
            });
          },
          color: verdigris,
          borderRadius: BorderRadius.circular(20),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }
}
