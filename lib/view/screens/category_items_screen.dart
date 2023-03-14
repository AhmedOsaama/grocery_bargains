import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/item.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';
import '../components/nav_bar.dart';
import '../widgets/backbutton.dart';

class CategoryItemsScreen extends StatefulWidget {
  final String listId;
  CategoryItemsScreen({Key? key, required this.listId}) : super(key: key);

  @override
  State<CategoryItemsScreen> createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  List<Item> addedItems = [];

  var allItems = [
    Item(name: "Carrot",description: "",id: "1",imageUrl: 'https://i5.walmartimages.ca/images/Enlarge/686/686/6000198686686.jpg',categoryId: "",createdAt: "",createdBy: "",),
    Item(name: "Apple",description: "",id: "2",imageUrl: 'https://www.collinsdictionary.com/images/full/apple_158989157.jpg',categoryId: "",createdAt: "",createdBy: "",),
    Item(name: "Cabbage",description: "",id: "3",imageUrl: 'https://images.heb.com/is/image/HEBGrocery/000374791?fit=constrain,1&wid=800&hei=800&fmt=jpg&qlt=85,0&resMode=sharp2&op_usm=1.75,0.3,2,0',categoryId: "",createdAt: "",createdBy: "",),
    Item(name: "Cauliflower",description: "",id: "4",imageUrl: 'https://5.imimg.com/data5/IE/YN/MY-51545753/sg-cauliflower-2c-1nos-500x500.png',categoryId: "",createdAt: "",createdBy: "",),
  ];

  Future<void> addItemsToList() async {
    final userData = await FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    for(Item item in addedItems) {
      FirebaseFirestore.instance.collection('/lists/${widget.listId}/items')
          .add({
        'item_name': item.name,
        'item_image': item.imageUrl,
        'createdAt': Timestamp.now(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'message': "",
        'username': userData['username'],
        'userImageURL': userData['imageURL'],
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 62.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 22.w,),
            MyBackButton(),
            Spacer(),
            Container(
                width: 200.w,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Search",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                )),
            Spacer(),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GenericButton(
              onPressed: addedItems.isNotEmpty ? () async {
                await addItemsToList();
                var docRef = await FirebaseFirestore.instance.doc('/lists/${widget.listId}').get();
                var listName = docRef.get("list_name");
                print("LIST NAME: $listName");
                // AppNavigator.pushReplacement(context: context, screen: ListViewScreen(listId: widget.listId,listName: listName,));
              } : null,
              child: Text(
                "Done",
                style: TextStyles.textViewBold15,
              ),
              borderRadius: BorderRadius.circular(6),
              // width: 37.w,
              height: 30.h,
            ),
            SizedBox(width: 10.w,),
            GenericButton(
              onPressed: () {},
              child: Text(
                "Filter",
                style: TextStyles.textViewBold15,
              ),
              borderRadius: BorderRadius.circular(6),
              width: 95.w,
              height: 35.h,
            ),
          ],
        ),  SizedBox(
          height: 20.h,
        ),
        DragTarget<Item>(
          builder: (context,candidItems,_) {
            return Container(
              width: double.infinity,
              height: 101.h,
              color: candidItems.isNotEmpty ? Colors.red.withOpacity(0.5) : Color.fromRGBO(77, 191, 163, 1),
              child: Center(
                  child: Text(
                candidItems.isNotEmpty ? candidItems.first!.name : "Drop your items to create a list",
                style: TextStyles.textViewBold20
                    .copyWith(color: Color.fromRGBO(81, 82, 80, 1)),
              )),
            );
          },
          onAccept: (item){
            print(item);
            setState(() {
              addedItems.add(item);
            });
          },
        ),
        SizedBox(
          height: 50.h,
        ),
        Expanded(
            child: GridView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 16, crossAxisSpacing: 26),
          children:
              allItems.map((item) => LongPressDraggable<Item>(
                data: item,
                // dragAnchorStrategy: pointerDragAnchorStrategy,
                feedback: Container(
                  width: 150.w,
                  height: 150.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(item.imageUrl),opacity: 0.8),
                    borderRadius: BorderRadius.circular(6),
                    // color: Color.fromRGBO(204, 204, 204, 0.8),
                  ),
                  child: Container(),
                ),
                child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(item.imageUrl)),
                        borderRadius: BorderRadius.circular(6),
                        color: Color.fromRGBO(204, 204, 204, 1),
                      ),
                      child: Container(),
                    ),
              )).toList(),
        ))
      ],
    ),
      bottomNavigationBar: NavBar(),
    );
  }
}
