import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/models/product.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/utils.dart';
import 'package:swaav/view/components/generic_field.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/home_screen.dart';
import 'package:swaav/view/widgets/store_list_widget.dart';

import '../../models/list_item.dart';
import '../../models/store_list.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../widgets/product_item.dart';

class AddStoreItemsScreen extends StatefulWidget {
  final String storeName;
  final String storeImageURL;
  const AddStoreItemsScreen({Key? key, required this.storeName, required this.storeImageURL}) : super(key: key);

  @override
  State<AddStoreItemsScreen> createState() => _AddStoreItemsScreenState();
}

class _AddStoreItemsScreenState extends State<AddStoreItemsScreen> {
  var storeCategories = [
    LocaleKeys.vegetablesAndFruits.tr(),
    LocaleKeys.frozenFood.tr(),
    LocaleKeys.healthAndToiletries.tr(),
    LocaleKeys.drinks.tr(),
    LocaleKeys.household.tr(),
    LocaleKeys.pets.tr(),
    LocaleKeys.bakery.tr(),
  ];
  List subCategories = [
    "Bananas",
    "Lemon",
    "Apples",
    "Orange",
    "Pineapple",
    "Strawberry",
    "Pomelo",
    "Kiwi",
  ];
  List<StoreList> lists = [];
  var recentSearches = [
    Product(price: 1.25, description: "355ml, Price", imageURL: peach, name: "Diet Coke", fullPrice: 1.55),
    Product(price: 2.25, description: "355ml, Price", imageURL: peach, name: "Fresh Peach", fullPrice: 3.00),
    Product(price: 5.25, description: "355ml, Price", imageURL: peach, name: "Another Diet Coke", fullPrice: 8.55),
  ];
  var categorySelected;
  var selectedListIndex = 0;
  String getTotalListPrice(List<ListItem> items){
    var total = 0.0;
    for (var item in items) {
      total += item.price;
    }
    return total.toStringAsFixed(2);
  }

  Future<String> createList() async {
    var docRef =  await FirebaseFirestore.instance.collection('/lists').add({
      "list_name": "Name...",
      "storeName": widget.storeName,
      "storeImageUrl": widget.storeImageURL,
      "userIds": [FirebaseAuth.instance.currentUser?.uid],
    });
    return docRef.id;
  }

  Future<void> createAndSaveList() async {
    var docId = await createList();
    setState(() {
    lists.add(StoreList(docId: docId,items: [], storeName: widget.storeName, name: "Name...", people: [], storeImageUrl: widget.storeImageURL));
    });
  }

  Future<void> saveListName(String docId, String newListName) async {
    await FirebaseFirestore.instance.collection('/lists').doc(docId).update({
      "list_name": newListName,
    });
  }

  Future<void> addItemsToList(ListItem item) async {
    final userData = await FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      FirebaseFirestore.instance.collection('/lists/${lists[selectedListIndex].docId}/items')
          .add({
        'item_name': item.name,
        'item_image': item.imageURL,
        'item_description': item.description,
        'item_quantity': item.quantity,
        'item_isChecked': item.isChecked,
        'item_price': item.price,
        'createdAt': Timestamp.now(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'message': "",
        'username': userData['username'],
        'userImageURL': userData['imageURL'],
      });
  }

  @override
  void initState() {
   createAndSaveList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70.h,
              ),
              BackButton(),
              SizedBox(
                height: 90.h,
                child: ListView(                      //TODO: convert to listview builder and make the plus button like see more
                  scrollDirection: Axis.horizontal,
                  children: lists.map((list) => GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedListIndex = lists.indexOf(list);
                      });
                    },
                    child: Container(
                      width: 300.w,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: selectedListIndex == lists.indexOf(list) ? verdigris : Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(list.storeImageUrl,width: 28,height: 28,),
                          SizedBox(width: 10.w,),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                    hintText: "Name...",
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value){
                                    // setState(() {
                                    list.name = value;
                                    // });
                                  },
                                  onSubmitted: (value){
                                    saveListName(list.docId, value);
                                  },
                                ),
                                // Text(list.name, style: TextStyles.textViewMedium15.copyWith(color: prussian),),
                                Text("${list.items.length} Items",style: TextStyles.textViewMedium10.copyWith(color: Colors.grey),),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text("€${getTotalListPrice(list.items)}",style: TextStyles.textViewSemiBold16.copyWith(color: prussian),),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: PlusButton(onTap: (){
                  setState(() {
                    createAndSaveList();
                    selectedListIndex += 1;
                  });
                }),
              ),                          //TODO: add this inside listview as the last item like see more
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
              Row(
                children: [
                  Text(
                    LocaleKeys.todaysBestBargain.tr(),
                    style: TextStyles.textViewRegular10
                        .copyWith(color: Color.fromRGBO(14, 79, 104, 1)),
                  ),
                  Spacer(),
                  Icon(Icons.store_outlined),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: borderColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(spar),
                        Text(
                          "Albert Heinz",
                          style: TextStyles.textViewMedium10
                              .copyWith(color: prussian),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.recentSearches.tr(),
                    style:
                        TextStyles.textViewSemiBold16.copyWith(color: prussian),
                  ),
                  Text(
                    LocaleKeys.seeAll.tr(),
                    style:
                        TextStyles.textViewRegular16.copyWith(color: verdigris),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 260.h,
                child: ListView.builder(
                  itemCount: recentSearches.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx,i){
                    var name = recentSearches[i].name;
                    var price = recentSearches[i].price;
                    var fullPrice = recentSearches[i].fullPrice;
                    var description = recentSearches[i].description;
                    var imageURL = recentSearches[i].imageURL;
                    return ProductItemWidget(
                        onTap: () async {
                          var item = ListItem(name: name, price: price, isChecked: false, quantity: 1, imageURL: imageURL, description: description);
                          await addItemsToList(item);
                          setState(() {
                              lists[selectedListIndex].items.add(item);
                          });
                        },
                        price: price.toString(),
                        fullPrice: fullPrice.toString(),
                        name: name,
                        description: description,
                        imagePath: imageURL
                    );
                  },
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                LocaleKeys.shopByAisle.tr(),
                style: TextStyles.textViewRegular10
                    .copyWith(color: const Color.fromRGBO(14, 79, 104, 1)),
              ),
              SizedBox(height: 15.h),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: storeCategories
                    .map((category) => GestureDetector(
                          onTap: () {
                            if (categorySelected != category) {
                              setState(() {
                                categorySelected = category;
                              });
                            } else {
                              setState(() {
                                categorySelected = null;
                              });
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category,
                                    style: TextStyles.textViewLight12
                                        .copyWith(color: prussian),
                                  ),
                                  Icon(categorySelected != category
                                      ? Icons.arrow_forward_ios_outlined
                                      : Icons.keyboard_arrow_up)
                                ],
                              ),
                              Divider(),
                              if (categorySelected == category) ...[
                                GridView(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 14,
                                    crossAxisSpacing: 23,
                                  ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: subCategories
                                      .map((subCat) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset(
                                                    milk,
                                                  )),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                subCat,
                                                style: TextStyles
                                                    .textViewRegular10
                                                    .copyWith(
                                                        color: const Color.fromRGBO(
                                                            14, 79, 104, 1)),
                                              )
                                            ],
                                          ))
                                      .toList(),
                                ),
                                SizedBox(
                                  height: 40.h,
                                )
                              ]
                            ],
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
