import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../models/list_item.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets_manager.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';
import '../screens/choose_store_screen.dart';

class ChooseListDialog extends StatefulWidget {
  final List allLists;
  final ListItem item;
  const ChooseListDialog({Key? key, required this.allLists, required this.item}) : super(key: key);

  @override
  State<ChooseListDialog> createState() => _ChooseListDialogState();
}

class _ChooseListDialogState extends State<ChooseListDialog> {
  var selectedListId = "choose";
  var hasChosenList = false;
  Future<void> addItemToList(ListItem item, String docId) async {
    final userData = await FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    FirebaseFirestore.instance.collection('/lists/$docId/items').add({
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
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30.h,
            ),
            Text(
              LocaleKeys.chooseList.tr(),
              style: TextStyles.textViewSemiBold34.copyWith(color: prussian),
            ),
            SizedBox(
              height: 25.h,
            ),
            DropdownButton(
                isExpanded: true,
                underline: Container(),
                value: selectedListId,
                items: widget.allLists
                    .map((list) => DropdownMenuItem<String>(
                        value: list['list_id'],
                        child: Text(
                          list['list_name'],
                          style: TextStyles.textViewRegular14
                              .copyWith(color: Colors.grey),
                        )))
                    .toList()
                  ..insert(
                      0,
                      DropdownMenuItem(
                          value: "choose",
                          child: Text(
                            LocaleKeys.chooseList.tr(),
                            style: TextStyles.textViewRegular14
                                .copyWith(color: Colors.grey),
                          ))),
                onChanged: (value) {
                  setState(() {
                    if (value != 'choose') {
                      selectedListId = value!;
                      hasChosenList = true;
                    }else{
                      selectedListId = 'choose';
                      hasChosenList = false;
                    }
                  });
                }),
            SizedBox(
              height: 10.h,
            ),
            GenericButton(
                onPressed: () async {
                  if (hasChosenList) {
                    await addItemToList(
                       widget.item,
                        selectedListId);
                    AppNavigator.pop(context: context);
                  }else {
                    //TODO: pass the item to the chooseStoreScreen page and add it as the first item in the list created
                    // AppNavigator.pushReplacement(
                    //     context: context, screen: ChooseStoreScreen());
                    }
                  },
                height: 60.h,
                width: double.infinity,
                color: verdigris,
                borderRadius: BorderRadius.circular(6),
                child: Text(
                  hasChosenList ? LocaleKeys.addToList.tr() : LocaleKeys.createNewList.tr(),
                  style: TextStyles.textViewSemiBold16
                      .copyWith(color: Colors.white),
                )),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
