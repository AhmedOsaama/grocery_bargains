import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/providers/chatlists_provider.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../models/list_item.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';

class ChooseListDialog extends StatefulWidget {
  final bool isSharing;
  final ListItem item;
  const ChooseListDialog(
      {Key? key,
      required this.item,
      required this.isSharing})
      : super(key: key);

  @override
  State<ChooseListDialog> createState() => _ChooseListDialogState();
}

class _ChooseListDialogState extends State<ChooseListDialog> {
  var selectedListId = "choose";
  var hasChosenList = false;

  Future<void> shareItem(
      {required ListItem item, required String docId}) async {
    //TODO: duplicated with chat_view_widget line 310
    final userData = await FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    await FirebaseFirestore.instance.collection('/lists/$docId/messages').add({
      'item_name': item.name,
      'item_image': item.imageURL,
      'item_description': item.size,
      'store_name': item.storeName,
      'isAddedToList': false,
      'item_price': item.price,
      'item_oldPrice': item.oldPrice,
      'message': "",
      'createdAt': Timestamp.now(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'username': userData['username'],
      'userImageURL': userData['imageURL'],
    });
    FirebaseFirestore.instance.collection('/lists').doc(docId).update({
      "last_message": "Shared ${item.name}",
      "last_message_date": Timestamp.now(),
      "last_message_userId": FirebaseAuth.instance.currentUser?.uid,
      "last_message_userName": userData['username'],
    });
  }

  @override
  Widget build(BuildContext context) {
    var chatlistsProvider = Provider.of<ChatlistsProvider>(context);
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
              style: TextStyles.textViewSemiBold34.copyWith(color: black2),
            ),
            SizedBox(
              height: 25.h,
            ),
            Image.network(widget.item.imageURL,width: 192,height: 192,),
            SizedBox(
              height: 25.h,
            ),
            DropdownButton(
                isExpanded: true,
                underline: Container(),
                value: selectedListId,
                items: chatlistsProvider.chatlists
                    .map((chatlist) => DropdownMenuItem<String>(
                        value: chatlist.id,
                        child: Text(
                          chatlist.name,
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
                    } else {
                      selectedListId = 'choose';
                      hasChosenList = false;
                    }
                  });
                }),
            SizedBox(
              height: 10.h,
            ),
            GenericButton(
                onPressed: !hasChosenList
                    ? null
                    : () async {
                        if (!widget.isSharing) {
                          await Provider.of<ChatlistsProvider>(context,
                                  listen: false)
                              .addItemToList(widget.item, selectedListId);
                        } else {
                          await shareItem(
                              item: widget.item, docId: selectedListId);
                        }
                        AppNavigator.pop(context: context);
                      },
                height: 60.h,
                width: double.infinity,
                color: yellow,
                borderRadius: BorderRadius.circular(6),
                child: widget.isSharing
                    ? Text(
                        LocaleKeys.share.tr(),
                        style: TextStylesInter.textViewSemiBold16
                            .copyWith(color: black2),
                      )
                    : Text(
                        // hasChosenList ? LocaleKeys.addToList.tr() : LocaleKeys.createNewList.tr(),
                        LocaleKeys.addToList.tr(),
                        style: TextStylesInter.textViewSemiBold16
                            .copyWith(color: black2),
                      )),
            15.ph,
            GenericButton(                           //TODO: create and share or add an item button(Check the figma flow)
                onPressed: () {
                    Provider.of<ChatlistsProvider>(context,listen: false).createChatList();
                  },
                height: 60.h,
                width: double.infinity,
                borderColor: Colors.grey,
                color: white,
                borderRadius: BorderRadius.circular(6),
                child: Text(
                  LocaleKeys.createNewList.tr(),
                  style: TextStylesInter.textViewSemiBold16
                      .copyWith(color: Color.fromRGBO(128, 128, 128, 1)),
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
