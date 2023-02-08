import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/components/generic_menu.dart';
import 'package:swaav/view/components/nav_bar.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/list_view_screen.dart';
import 'package:swaav/view/widgets/backbutton.dart';
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
      body: Column(
        children: [
          SizedBox(
            height: 91.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyBackButton(),
                Spacer(
                  flex: 2,
                ),
                Text(
                  "Lists",
                  style:
                      TextStyles.textViewBold15.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                GenericButton(
                  onPressed: () {},
                  child: Text(
                    "Filter",
                    style: TextStyles.textViewBold15,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  width: 95.w,
                  height: 26.h,
                )
              ],
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Expanded(
              child: FutureBuilder(
                  future: getAllListsFuture,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var allLists = snapshot.data?.docs;
                    return ListView.builder(
                        itemCount: allLists!.length,
                        itemBuilder: (ctx, i) {
                          print(allLists[i]['list_name']);
                          return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (ctx) => ListViewScreen(
                                          listId: allLists[i].id,
                                          listName: allLists[i]['list_name']))),
                              child: SwaavList(
                                  listName: allLists[i]['list_name']));
                        });
                  })),
        ],
      ),
    );
  }
}
