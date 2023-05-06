import 'dart:async';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/models/user_info.dart' as UserInfo;
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/contact_profile_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

final contactsCheckbox = new ValueNotifier(<String, bool>{});

//Map<String, bool> contactsCheckbox = ValueNotifer({});
class NewGroupChatScreen extends StatefulWidget {
  NewGroupChatScreen({Key? key, required this.contactsList}) : super(key: key);
  List<UserInfo.UserContactInfo> contactsList;
  @override
  State<NewGroupChatScreen> createState() => _NewGroupChatScreenState();
}

class _NewGroupChatScreenState extends State<NewGroupChatScreen> {
  List<UserInfo.UserContactInfo> addedList = [];
  Map<String, List<UserInfo.UserContactInfo>> contactsOrdered = {};

  List<String> alphabets =
      List.generate(26, (index) => String.fromCharCode(index + 65));
  List<String> specialChars = [];
  ScrollController controller = ScrollController();
  bool done = false;

  @override
  void initState() {
    orderContacts();
    super.initState();
  }

  void addValueToMap<K, V>(Map<K, List<V>> map, K key, V value) =>
      map.update(key, (list) => list..add(value), ifAbsent: () => [value]);

  List<Widget> contactsColumn = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: lightPurple,
        foregroundColor: Colors.black,
        // leading: backButt,
        title: Text(
          "Add",
          style: TextStyles.textViewSemiBold16.copyWith(color: black1),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                List<String> ids = [];
                addedList.forEach((element) {
                  ids.add(element.id);
                });

                var listId =
                    await Provider.of<ChatlistsProvider>(context, listen: false)
                        .createChatList(ids);

                AppNavigator.pushReplacement(
                    context: context,
                    screen: ChatListViewScreen(
                      listId: listId,
                    ));
              },
              child: Text(
                "Next",
                style:
                    TextStyles.textViewSemiBold16.copyWith(color: mainPurple),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              20.ph,
              addedList.isEmpty
                  ? Container()
                  : Builder(
                      builder: (context) {
                        List<Widget> columns = [];
                        addedList.forEach((element) {
                          columns.add(Column(
                            children: [
                              Stack(
                                children: [
                                  element.imageURL.isEmpty
                                      ? SvgPicture.asset(
                                          peopleIcon,
                                          width: 35.w,
                                          height: 35.h,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            element.imageURL,
                                          ),
                                          radius: 20,
                                        ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          addedList.remove(element);
                                        });
                                        contactsCheckbox.value[element.email +
                                            element.phoneNumber +
                                            element.name] = false;
                                        contactsCheckbox.notifyListeners();
                                      },
                                      excludeFromSemantics: true,
                                      child: SvgPicture.asset(closeIcon),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                element.name,
                                style: TextStyles.textViewRegular14
                                    .copyWith(color: black),
                              )
                            ],
                          ));
                          columns.add(10.pw);
                        });

                        return Align(
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: controller,
                            child: Row(
                              children: columns,
                            ),
                          ),
                        );
                      },
                    ),
              Builder(
                builder: (context) {
                  if (!done) {
                    contactsOrdered.forEach((key, value) {
                      contactsColumn.add(12.ph);
                      contactsColumn.add(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            key,
                            style: TextStylesInter.textViewRegular12
                                .copyWith(color: mainPurple),
                          ),
                        ),
                      );
                      contactsColumn.add(12.ph);
                      value.forEach((element) {
                        contactsColumn.add(Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                var lists =
                                    await Provider.of<ChatlistsProvider>(
                                            context,
                                            listen: false)
                                        .getAllSharedChatlists(element.id);

                                AppNavigator.push(
                                    context: context,
                                    screen: ContactProfileScreen(
                                      lists: lists,
                                      user: element,
                                    ));
                              },
                              child: Row(
                                children: [
                                  element.imageURL.isEmpty
                                      ? SvgPicture.asset(
                                          peopleIcon,
                                          width: 35.w,
                                          height: 35.h,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            element.imageURL,
                                          ),
                                          radius: 20,
                                        ),
                                  15.pw,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        element.name,
                                        style: TextStylesInter
                                            .textViewSemiBold16
                                            .copyWith(color: black2),
                                      ),
                                      Text(
                                        element.phoneNumber,
                                        style: TextStylesInter.textViewRegular12
                                            .copyWith(color: phoneText),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable: contactsCheckbox,
                                builder: (context, value, w) {
                                  return Checkbox(
                                      activeColor: purple70,
                                      checkColor: white,
                                      side:
                                          BorderSide(width: 3, color: purple70),
                                      shape: CircleBorder(),
                                      value: value[element.email +
                                          element.phoneNumber +
                                          element.name],
                                      splashRadius: 10,
                                      onChanged: (v) async {
                                        if (!addedList.contains(element)) {
                                          setState(() {
                                            addedList.add(element);
                                          });
                                          value[element.email +
                                              element.phoneNumber +
                                              element.name] = true;
                                          contactsCheckbox.notifyListeners();
                                          if (controller.hasClients) {
                                            Timer(Duration(milliseconds: 100),
                                                () {
                                              controller.animateTo(
                                                controller
                                                    .position.maxScrollExtent,
                                                curve: Curves.easeOut,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                              );
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            addedList.remove(element);
                                          });
                                          value[element.email +
                                              element.phoneNumber +
                                              element.name] = false;
                                          contactsCheckbox.notifyListeners();
                                        }
                                      });
                                })
                          ],
                        ));
                      });
                    });
                    done = true;
                  }
                  return Column(
                    children: contactsColumn,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  orderContacts() {
    alphabets.forEach(
      (e) {
        widget.contactsList.forEach((element) {
          contactsCheckbox.value.addAll(
              {element.email + element.phoneNumber + element.name: false});
          contactsCheckbox.notifyListeners();
          if (element.name[0].toUpperCase() == e) {
            addValueToMap(contactsOrdered, e, element);
          } else if (!alphabets.contains(element.name[0].toUpperCase())) {
            if (!specialChars.contains(element.name[0])) {
              specialChars.add(element.name[0]);
            }
          }
        });
      },
    );
    specialChars.forEach(
      (e) {
        widget.contactsList.forEach((element) {
          if (element.name[0].toUpperCase() == e) {
            addValueToMap(contactsOrdered, e, element);
          }
        });
      },
    );
  }
}
