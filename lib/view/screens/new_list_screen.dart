import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/view/components/generic_menu.dart';
import 'package:swaav/view/components/my_scaffold.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/sub_categories_screen.dart';
import 'package:swaav/view/widgets/backbutton.dart';

class NewListScreen extends StatefulWidget {
  NewListScreen({Key? key}) : super(key: key);

  @override
  State<NewListScreen> createState() => _NewListScreenState();
}

class _NewListScreenState extends State<NewListScreen> {
  bool isAddingItem = false;
  bool isChoosingCategory = false;
  TextEditingController listNameController = TextEditingController();

  Future<String> createList() async {
    var docRef =  await FirebaseFirestore.instance.collection('/lists').add({
      "list_name": listNameController.text.trim(),
      "userIds": [FirebaseAuth.instance.currentUser?.uid],
    });
    return docRef.id;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body:
    Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: Column(
      children: [
        SizedBox(height: 62.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyBackButton(),
            Spacer(),
            Container(
              width: 200.w,
                child: TextField(
                  controller: listNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)
                    )
                  ),
                )),
            Spacer(),
          ],
        ),
        Spacer(),
        if(!isAddingItem) PlusButton(onTap: (){
          setState(() {
            isAddingItem = true;
          });
        }),
        if(isAddingItem && !isChoosingCategory)
          GenericMenu(margin: 10.w,option1Text: "Add item", option2Text: "Categories", option1Func: (){}, option2Func: (){
            setState(() {
              isChoosingCategory = true;
            });
          }),
        if(isChoosingCategory)
          Row(
            children: [
              MyBackButton(
                onTap: (){
                  setState(() {
                    isChoosingCategory = false;
                  });
                },
              ),
              SizedBox(width: 10.w,),
              Expanded(
                child: GenericMenu(margin: 0.w,option1Text: "Grocery", option2Text: "Clothing", option1Func: () async {
                  //TODO: check whether a list name is provided before proceeding
                  var listId = await createList();
                  AppNavigator.pushReplacement(context: context, screen: SubCategoriesScreen(
                    listId: listId,
                    listName: listNameController.text.trim(),
                    subCategories:
                  const ["Fruit & Vegetables",
                  "Bread & Pastry",
                    "Milk & Cheese",
                    "Meat & Fish",
                    "Ingredients & Spices",
                    "Grain Products",
                    "Snacks & Sweets",
                    "Beverages"
                  ]
                    ,));
                }, option2Func: () async {
                  var listId = await createList();
                  AppNavigator.pushReplacement(context: context, screen: SubCategoriesScreen(
                    listId: listId,
                    listName: listNameController.text.trim(),
                    subCategories:
                  const [
                    "Shirts/Blouses",
                      "Jeans/Pants",
                      "Accessories",
                      "Shoes",
                      "Jackets",
                      "Suits",
                      "Sports wear",
                      "Kids Basics"

                  ],));
                }),
              ),
            ],
          )
      ],
    ),
    )
    );
  }
}
