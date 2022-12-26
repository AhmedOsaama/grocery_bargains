import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/utils/fonts_utils.dart';
import 'package:swaav/view/components/generic_appbar.dart';
import 'package:swaav/view/components/my_scaffold.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/category_items_screen.dart';
import 'package:swaav/view/screens/chat_view_screen.dart';

import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';

class ListViewScreen extends StatefulWidget {
  final String listId;
  final String listName;
  ListViewScreen({Key? key,required this.listId, required this.listName}) : super(key: key);

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Column(
          children: [
            SizedBox(height: 62.h,),
            GenericAppBar(appBarTitle: widget.listName,actions: [
              GestureDetector(
                onTap: (){},
                child: SvgPicture.asset(shareIcon),
              ),
              SizedBox(width: 20.w,),
              GestureDetector(
                onTap: () => AppNavigator.pushReplacement(context: context, screen: ChatViewScreen(listName: widget.listName,listId: widget.listId,)),
                child: SvgPicture.asset(chatIcon),
              )
            ],),
            SizedBox(height: 64.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200.w,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Search",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                    ),
                  ),
                ),
                SizedBox(width: 15.w,),
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
            ),
            SizedBox(height: 40.h,),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("/lists/${widget.listId}/items").orderBy('createdAt', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var items = snapshot.data!.docs;
                    //LIST VIEW
                    items = items.where((item) => item['message'] == "").toList();
                    return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 50.h,
                    crossAxisSpacing: 90.w,
                    crossAxisCount: 2
                  ),
                      itemCount: items.length,
                      itemBuilder: (ctx,i) {
                      if(items[i]['message'] == ""){
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onLongPress: (){
                                setState(() {
                                  isDeleting = !isDeleting;
                                });
                              },
                              child: Container(
                              color: items[i]['userId'] == FirebaseAuth.instance.currentUser?.uid ?  Colors.yellow.withOpacity(0.6) : null,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                children: [
                                  isDeleting ? Icon(Icons.delete_rounded) :
                                  Image.network( items[i]['item_image'],width: 100.w,height: 100.h,),
                                  Container(
                                    width: 32.w,
                                    height: 21.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Color.fromRGBO(217, 217, 217, 1),
                                    ),
                                    child: Center(child: Text("3",style: TextStyles.textViewBold15,)),
                                  ),
                                ],
                  ),
                              ),
                      ),
                            ),
                            Positioned(child: CircleAvatar(backgroundImage: NetworkImage(items[i]['userImageURL']),radius: 20,),top: -15 ,right: -15,),
                          ],
                        );
                      }
                      return SizedBox();
                      },
                  );
                }
              ),
            ),
            SizedBox(height: 10.h,),
            PlusButton(onTap: () => AppNavigator.pushReplacement(context: context, screen: CategoryItemsScreen(listId: widget.listId))),
          ],
        )
    );
  }
}
