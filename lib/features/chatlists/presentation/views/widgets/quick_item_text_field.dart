import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../models/list_item.dart';
import '../../../../../providers/chatlists_provider.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../../view/components/generic_field.dart';

class QuickItemTextField extends StatelessWidget {
  final TextEditingController quickItemController;
  final String listId;
  const QuickItemTextField({Key? key, required this.quickItemController, required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericField(
      controller: quickItemController,
      onSubmitted: (value) {
        if (quickItemController.text.isEmpty) return;
        Provider.of<ChatlistsProvider>(context, listen: false).addItemToList(
            ListItem(
                id: -1,
                storeName: "",
                imageURL: '',
                isChecked: false,
                name: value.trim(),
                price: 0.0,
                quantity: 0,
                size: '',
                text: value.trim(),
                brand: ''),
            listId);
        quickItemController.clear();
        TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "add manual(text) item",
            DateTime.now().toUtc().toString(), "Chatlist screen");
      },
      hintText: LocaleKeys.addSomethingQuickly.tr(),
     // border: const OutlineInputBorder(
     //   borderSide: BorderSide(color: Colors.red)
     // ),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffD6D6D6))
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffD6D6D6))
      ),
      // contentPadding: EdgeInsets.only(left: 10),
      hintStyle: TextStylesInter.textViewRegular12.copyWith(color: primaryGreen),
      suffixIcon: TextButton(
        onPressed: () async {
          if (quickItemController.text.isEmpty) return;
          await Provider.of<ChatlistsProvider>(context, listen: false).addItemToList(
              ListItem(
                  id: -1,
                  storeName: "",
                  imageURL: '',
                  isChecked: false,
                  name: quickItemController.text.trim(),
                  price: 0.0,
                  quantity: 0,
                  size: '',
                  text: quickItemController.text.trim(),
                  brand: ''),
              listId);
          quickItemController.clear();
          TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "add manual(text) item",
              DateTime.now().toUtc().toString(), "Chatlist screen");
        },
        child: Text(
          LocaleKeys.add.tr(),
          style: TextStylesInter.textViewBold12.copyWith(color: primaryGreen),
        ),
      ),
    );
  }
}
