import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/providers/chatlists_provider.dart';

import '../../generated/locale_keys.g.dart';
import '../../models/list_item.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';

class ChooseListDialog extends StatefulWidget {
  final bool isSharing;
  final ListItem item;
  const ChooseListDialog(
      {Key? key, required this.item, required this.isSharing})
      : super(key: key);

  @override
  State<ChooseListDialog> createState() => _ChooseListDialogState();
}

class _ChooseListDialogState extends State<ChooseListDialog> {
  var selectedListId = "choose";
  var hasChosenList = false;
  bool done = false;

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
                done ? widget.item.storeName : "Add to list",
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
                            done
                                ? widget.item.name
                                : "Choose a chatlist or create new",
                            style: TextStyles.textViewRegular14
                                .copyWith(color: black),
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
                      done
                          ? widget.item.name
                          : "Choose a chatlist or create new",
                      style:
                          TextStyles.textViewRegular14.copyWith(color: black),
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
                                if (!widget.isSharing) {
                                  var b = await Provider.of<ChatlistsProvider>(
                                          context,
                                          listen: false)
                                      .addItemToList(
                                          widget.item, selectedListId);
                                  setState(() {
                                    done = b;
                                  });
                                } else {
                                  var b = await Provider.of<ChatlistsProvider>(
                                          context,
                                          listen: false)
                                      .shareItem(
                                          item: widget.item,
                                          docId: selectedListId);
                                  setState(() {
                                    done = b;
                                  });
                                }
                              },
                        height: 60.h,
                        width: double.infinity,
                        color: yellow,
                        disabledBackgroundColor: done ? yellow : orange10,
                        borderRadius: BorderRadius.circular(6),
                        child: (done
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Added  ",
                                    style: TextStylesInter.textViewSemiBold16
                                        .copyWith(color: white),
                                  ),
                                  Icon(
                                    Icons.done,
                                    color: white,
                                  )
                                ],
                              )
                            : Text(
                                LocaleKeys.addToList.tr(),
                                style: TextStylesInter.textViewSemiBold16
                                    .copyWith(color: black2),
                              ))),
                    15.ph,
                    GenericButton(
                        //TODO: create and share or add an item button(Check the figma flow)
                        onPressed: () async {
                          if (done) {
                            Navigator.of(context).pop();

                            await pushNewScreen(context,
                                screen: ChatListViewScreen(
                                  // updateList: updateList,
                                  listId: selectedListId,
                                  isListView: !widget.isSharing,
                                ),
                                withNavBar: false);
                            NavigatorController.jumpToTab(1);
                          } else {
                            Provider.of<ChatlistsProvider>(context,
                                    listen: false)
                                .createChatList([]);
                          }
                        },
                        height: 60.h,
                        width: double.infinity,
                        borderColor: Colors.grey,
                        color: white,
                        borderRadius: BorderRadius.circular(6),
                        child: Text(
                          done
                              ? "View in the chatlist"
                              : LocaleKeys.createNewList.tr(),
                          style: TextStylesInter.textViewSemiBold16.copyWith(
                              color: Color.fromRGBO(128, 128, 128, 1)),
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
