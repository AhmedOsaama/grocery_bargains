import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/providers/chatlists_provider.dart';

import '../../generated/locale_keys.g.dart';
import '../../models/list_item.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/tracking_utils.dart';
import '../components/button.dart';

class ChooseListDialog extends StatefulWidget {
  final ListItem item;
  final BuildContext context;
  const ChooseListDialog({Key? key, required this.item, required this.context}) : super(key: key);

  @override
  State<ChooseListDialog> createState() => _ChooseListDialogState();
}

class _ChooseListDialogState extends State<ChooseListDialog> {
  var selectedListId = "choose";
  var hasChosenList = false;
  bool done = false;

  @override
  void initState() {
    try {
      TrackingUtils().trackPopPageView(
          FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Choose chatlist popup");
    }catch(e){
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var chatlistsProvider = Provider.of<ChatlistsProvider>(context);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      alignment: Alignment.center,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: SizedBox(
        width: double.maxFinite,
        //height: ScreenUtil().screenHeight * 0.8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24.h,
              ),
              Text(
                done ? widget.item.storeName : LocaleKeys.addToList.tr(),
                style: TextStyles.textViewSemiBold26.copyWith(color: black2),
              ),
              done
                  ? SizedBox()
                  : SizedBox(
                      height: 15.h,
                    ),
              done
                  ? Row(
                      children: [
                        Flexible(
                          child: Text(
                            done ? widget.item.name : LocaleKeys.chooseAChatlist.tr(),
                            style: TextStyles.textViewRegular14.copyWith(color: black),
                          ),
                        ),
                        Image.network(
                          widget.item.imageURL,
                          width: 100.w,
                          height: 100.h,
                        )
                      ],
                    )
                  : Text(
                      done ? widget.item.name : LocaleKeys.chooseAChatlist.tr(),
                      style: TextStyles.textViewRegular14.copyWith(color: black),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    DropdownButton(
                        isExpanded: true,
                        underline: Container(),
                        value: selectedListId,
                        items: chatlistsProvider.chatlists
                            .map((chatlist) => DropdownMenuItem<String>(
                                value: chatlist.id,
                                child: Text(
                                  chatlist.name,
                                  style: TextStyles.textViewRegular14.copyWith(color: Colors.grey),
                                )))
                            .toList()
                          ..insert(
                              0,
                              DropdownMenuItem(
                                  value: "choose",
                                  child: Text(
                                    LocaleKeys.chooseList.tr(),
                                    style: TextStyles.textViewRegular14.copyWith(color: Colors.grey),
                                  ))),
                        onChanged: (value) {
                          setState(() {
                            done = false;
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
                        onPressed: !hasChosenList || done
                            ? null
                            : () async {
                                var chatlistsProvider = Provider.of<ChatlistsProvider>(context, listen: false);
                                var b = await chatlistsProvider.addItemToList(widget.item, selectedListId);
                                setState(() {
                                  done = b;
                                });
                                var chatlistName = chatlistsProvider.chatlists
                                    .firstWhere((chatlist) => chatlist.id == selectedListId)
                                    .name;
                                chatlistsProvider.showChatlistSnackBar(
                                    widget.context,
                                    Text(LocaleKeys.addedTo.tr() + " $chatlistName"),
                                    LocaleKeys.view.tr(),
                                    selectedListId,
                                    false);
                                TrackingUtils().trackProductAction(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    DateTime.now().toUtc().toString(),
                                    widget.item.oldPrice == null,
                                    selectedListId,
                                    chatlistName,
                                    widget.item.quantity.toString(),
                                    productId: widget.item.id.toString(),
                                    'Add');
                                  TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "add to list", DateTime.now().toUtc().toString(), "Product screen");
                                AppNavigator.pop(context: context);
                              },
                        height: 60.h,
                        width: double.infinity,
                        color: brightOrange,
                        disabledBackgroundColor: done ? brightOrange : disabledColor,
                        borderRadius: BorderRadius.circular(6),
                        child: Text(
                          LocaleKeys.addToList.tr(),
                          style: TextStylesInter.textViewSemiBold16.copyWith(color: black2),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
