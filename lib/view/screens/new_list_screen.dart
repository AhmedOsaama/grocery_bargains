import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/generic_field.dart';
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
  TextEditingController descController = TextEditingController();

  Future<String> createList() async {
    var docRef =  await FirebaseFirestore.instance.collection('/lists').add({
      "list_name": listNameController.text.trim(),
      "userIds": [FirebaseAuth.instance.currentUser?.uid],
    });
    return docRef.id;
  }

  var listName = 'Blank';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(),
                Text(listName,style: TextStyles.textViewSemiBold18.copyWith(color: const Color.fromRGBO(24, 24, 24, 1)),),
                TextButton(onPressed: (){}, child: Text(LocaleKeys.autoSave.tr(),style: TextStyles.textViewSemiBold18.copyWith(color: iris),))
              ],
            ),
            SizedBox(height: 30.h,),
            TextField(
              decoration: InputDecoration(
              hintText: LocaleKeys.nameHint.tr(),
              hintStyle: TextStyles.textViewSemiBold34.copyWith(color: prussian),
              suffixIcon: IconButton(icon: Icon(Icons.more_vert),padding: EdgeInsets.zero,onPressed: (){},),
                  border: InputBorder.none
              ),
              onChanged: (value){
                setState(() {
                listName = value;
                });
              },
              controller: listNameController,
            ),
            Divider(),
            TextField(
              controller: descController,
              decoration: InputDecoration(
              hintText: LocaleKeys.descriptionHint.tr(),
              hintStyle: TextStyles.textViewRegular16,
              border: InputBorder.none
              ),
            ),
          ],
        ),
      ),
    );
  }
}
