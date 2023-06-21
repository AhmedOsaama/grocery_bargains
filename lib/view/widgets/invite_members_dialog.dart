import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../models/chatlist.dart';
import '../../providers/chatlists_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';
import '../components/close_button.dart';
import '../screens/contact_profile_screen.dart';
import '../screens/main_screen.dart';

class InviteMembersDialog extends StatelessWidget {
  final List listUsers;
  final bool isContactsPermissionGranted;
  final List contactsList;
  final Function shareList;
  final Function addContactToChatlist;
  const InviteMembersDialog({Key? key, required this.listUsers, required this.isContactsPermissionGranted, required this.contactsList, required this.shareList, required this.addContactToChatlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Wrap(
          children: [
            Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (listUsers.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.inviteMembers.tr(),
                              style: TextStylesInter.textViewSemiBold20
                                  .copyWith(color: blackSecondary),
                            ),
                            GenericButton(onPressed: () => AppNavigator.pop(context: context),
                                shape: CircleBorder(),
                                padding: EdgeInsets.zero,
                                width: 36,
                                color: purple70, child: Icon(Icons.close,color: white,))
                          ],
                        ),
                        10.ph,
                        ListView(
                            shrinkWrap: true,
                            children: listUsers.map((userInfo) {
                              return GestureDetector(
                                onTap: () async {
                                  if (userInfo.id ==
                                      FirebaseAuth.instance
                                          .currentUser?.uid) {
                                    AppNavigator.pop(
                                        context: context);
                                    NavigatorController.jumpToTab(2);
                                  } else {
                                    List<ChatList> lists = [];
                                    var friends = await Provider.of<
                                        ChatlistsProvider>(
                                        context,
                                        listen: false)
                                        .getAllFriends();

                                    friends.forEach((element) {
                                      if (element.id == userInfo.id) {
                                        element.chatlists
                                            .forEach((element) {
                                          lists.add(ChatList(
                                              id: element.id,
                                              name: element
                                                  .get("list_name"),
                                              storeName: element
                                                  .get("storeName"),
                                              userIds: element
                                                  .get("userIds"),
                                              totalPrice: element
                                                  .get("total_price"),
                                              storeImageUrl:
                                              element.get(
                                                  "storeImageUrl"),
                                              itemLength:
                                              element.get("size"),
                                              lastMessage: element.get(
                                                  "last_message"),
                                              lastMessageDate: element.get(
                                                  "last_message_date"),
                                              lastMessageUserId:
                                              element.get(
                                                  "last_message_userId"),
                                              lastMessageUserName:
                                              element.get(
                                                  "last_message_userName")));
                                        });
                                      }
                                    });

                                    AppNavigator.push(
                                        context: context,
                                        screen: ContactProfileScreen(
                                          lists: lists,
                                          user: userInfo,
                                        ));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      userInfo.imageURL.isEmpty
                                          ? SvgPicture.asset(
                                        bee,
                                        width: 35,
                                        height: 35,
                                      )
                                          : CircleAvatar(
                                        backgroundImage:
                                        NetworkImage(
                                          userInfo.imageURL,
                                        ),
                                        radius: 20,
                                      ),
                                      20.pw,
                                      Text(
                                        userInfo.name,
                                        style: TextStylesInter
                                            .textViewRegular16
                                            .copyWith(color: black2),
                                      ),
                                      Spacer(),
                                      if(listUsers.indexOf(userInfo) == 0) Text("Owner",style: TextStylesDMSans.textViewBold12.copyWith(color: mainPurple),)         //The owner is always the 1st one on the list
                                    ],
                                  ),
                                ),
                              );
                            }).toList()),
                      ],
                      20.ph,
                      TextButton(
                        onPressed: () => shareList(),
                        child: Text(
                            LocaleKeys.invitePeopleViaLink.tr(), style: TextStylesInter.textViewRegular12.copyWith(color: mainOrange)),),
                      10.ph,
                      Text(
                        LocaleKeys.contactsOnBargainB.tr(),
                        style: TextStylesInter.textViewRegular12
                            .copyWith(color: mainPurple),
                      ),
                      15.ph,
                      if (contactsList.isNotEmpty) ...[
                        ListView(
                            shrinkWrap: true,
                            children: contactsList.map((userInfo) {
                              return Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    List<ChatList> lists = [];
                                    var friends = await Provider.of<
                                        ChatlistsProvider>(
                                        context,
                                        listen: false)
                                        .getAllFriends();

                                    friends.forEach((element) {
                                      if (element.id == userInfo.id) {
                                        element.chatlists
                                            .forEach((element) {
                                          lists.add(ChatList(
                                              id: element.id,
                                              name: element
                                                  .get("list_name"),
                                              storeName: element
                                                  .get("storeName"),
                                              userIds: element
                                                  .get("userIds"),
                                              totalPrice: element
                                                  .get("total_price"),
                                              storeImageUrl:
                                              element.get(
                                                  "storeImageUrl"),
                                              itemLength:
                                              element.get("size"),
                                              lastMessage: element.get(
                                                  "last_message"),
                                              lastMessageDate: element.get(
                                                  "last_message_date"),
                                              lastMessageUserId:
                                              element.get(
                                                  "last_message_userId"),
                                              lastMessageUserName:
                                              element.get(
                                                  "last_message_userName")));
                                        });
                                      }
                                    });

                                    AppNavigator.push(
                                        context: context,
                                        screen: ContactProfileScreen(
                                          lists: lists,
                                          user: userInfo,
                                        ));
                                  },
                                  child: Row(
                                    children: [
                                      userInfo.imageURL.isEmpty
                                          ? SvgPicture.asset(
                                        peopleIcon,
                                        width: 35.w,
                                        height: 35.h,
                                      )
                                          : CircleAvatar(
                                        backgroundImage:
                                        NetworkImage(
                                          userInfo.imageURL,
                                        ),
                                        radius: 20,
                                      ),
                                      15.pw,
                                      Text(
                                        userInfo.name,
                                        style: TextStylesInter
                                            .textViewRegular14
                                            .copyWith(color: black2),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          await addContactToChatlist(
                                                userInfo, context);
                                          showDialog(
                                              context: context, builder: (ctx) => Dialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(LocaleKeys.addedToList.tr(),
                                                    style: TextStylesInter.textViewSemiBold28.copyWith(color: blackSecondary),
                                                  textAlign: TextAlign.center
                                                    ,),
                                                  15.ph,
                                                  Text(
                                                    LocaleKeys.greatNews.tr(),
                                                    style: TextStylesInter.textViewRegular16.copyWith(color: Color.fromRGBO(72, 72, 74, 1)),
                                                      textAlign: TextAlign.center
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                        },
                                        child: Row(children: [
                                          Text(
                                            LocaleKeys.add.tr(),
                                            style: TextStylesInter
                                                .textViewSemiBold14
                                                .copyWith(
                                                color:
                                                mainPurple),
                                          ),
                                          10.pw,
                                          CircleAvatar(
                                            child: Icon(
                                              Icons.person_add_alt,
                                              color: white,
                                            ),
                                            backgroundColor:
                                            mainPurple,
                                          )
                                        ]),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList()),
                      ],
                      if (contactsList.isEmpty &&
                          !isContactsPermissionGranted)
                        Text(
                          LocaleKeys.addYourPhoneNumber.tr(),
                          style: TextStylesInter.textViewRegular15
                              .copyWith(color: black),
                        ),
                      if (contactsList.isEmpty &&
                          isContactsPermissionGranted)
                        Text(
                          LocaleKeys.noContactsFound.tr(),
                          style: TextStylesInter.textViewRegular15
                              .copyWith(color: black),
                        ),
                      10.ph,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
