import 'dart:io';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/components/chats_search_delegate.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/models/user_info.dart' as UserInfo;
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/contact_profile_screen.dart';
import 'package:bargainb/view/screens/newgroupchat_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class NewChatlistScreen extends StatefulWidget {
  NewChatlistScreen({Key? key}) : super(key: key);

  @override
  State<NewChatlistScreen> createState() => _NewChatlistScreenState();
}

class _NewChatlistScreenState extends State<NewChatlistScreen> {
  List<UserInfo.UserContactInfo> contactsList = [];
  bool isContactsPermissionGranted = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // leading: backButt,
        title: Text(
          "Newchatlist".tr(),
          style: TextStyles.textViewSemiBold16.copyWith(color: black1),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future.value();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                GenericField(
                  isFilled: true,
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    return showSearch(
                        context: context, delegate: ChatSearchDelegate(pref));
                  },
                  prefixIcon: Icon(Icons.search),
                  borderRaduis: 999,
                  hintText: "Search",
                  hintStyle:
                      TextStyles.textViewSemiBold14.copyWith(color: gunmetal),
                ),
                16.ph,
                GestureDetector(
                  onTap: () async {
                    if (contactsList.isEmpty) {
                      var id = await Provider.of<ChatlistsProvider>(context,
                              listen: false)
                          .createChatList([]);
                      pushNewScreen(context,
                          screen: ChatListViewScreen(
                            // updateList: updateList,
                            listId: id,
                          ),
                          withNavBar: false);
                    } else {
                      AppNavigator.push(
                          context: context,
                          screen: NewGroupChatScreen(
                            contactsList: contactsList,
                          ));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: purple50,
                        child: SvgPicture.asset(addmsg),
                      ),
                      15.pw,
                      Text(
                        "NewGroupChatlist".tr(),
                        style: TextStyles.textViewSemiBold16
                            .copyWith(color: black),
                      )
                    ],
                  ),
                ),
                10.ph,
                GestureDetector(
                  onTap: () async {
                    await FlutterContacts.openExternalInsert();
                    /*  AppNavigator.push(
                        context: context, screen: NewContactScreen()); */
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: purple50,
                        child: SvgPicture.asset(newperson),
                      ),
                      15.pw,
                      Text(
                        LocaleKeys.newContact.tr(),
                        style: TextStyles.textViewSemiBold16
                            .copyWith(color: black),
                      )
                    ],
                  ),
                ),
                10.ph,
                GestureDetector(
                  onTap: () {
                    Platform.isAndroid ?
                    Share.share('Hello! I’m using BargainB, you can download it from https://play.google.com/store/apps/details?id=thebargainb.app&hl=en&gl=US') : Share.share('Hello! I’m using BargainB, you can download it from https://apps.apple.com/us/app/bargainb-grocery-savings/id6446258008');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: purple50,
                        child: SvgPicture.asset(newperson),
                      ),
                      15.pw,
                      Text(
                        "InviteToBargain".tr(),
                        style: TextStyles.textViewSemiBold16
                            .copyWith(color: black),
                      )
                    ],
                  ),
                ),
                20.ph,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    LocaleKeys.contactsOnBargainB.tr(),
                    style: TextStylesInter.textViewRegular12
                        .copyWith(color: mainPurple),
                  ),
                ),
                20.ph,
                FutureBuilder(
                    future: getContacts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return snapshot.data!.isEmpty
                          ? (isContactsPermissionGranted
                              ? Text(
                        LocaleKeys.noContactsFound.tr(),
                                  style: TextStylesInter.textViewRegular12
                                      .copyWith(color: black),
                                )
                              : Text(
                        LocaleKeys.pleaseAddYourNumber.tr(),
                                  maxLines: 2,
                                  style: TextStylesInter.textViewRegular12
                                      .copyWith(color: black),
                                ))
                          : ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: snapshot.data!.map((userInfo) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      var lists = await Provider.of<
                                                  ChatlistsProvider>(context,
                                              listen: false)
                                          .getAllSharedChatlists(userInfo.id);

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
                                                backgroundImage: NetworkImage(
                                                  userInfo.imageURL,
                                                ),
                                                radius: 20,
                                              ),
                                        20.pw,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userInfo.name,
                                              style: TextStyles
                                                  .textViewSemiBold16
                                                  .copyWith(color: black2),
                                            ),
                                            Text(
                                              userInfo.phoneNumber,
                                              style: TextStyles
                                                  .textViewRegular12
                                                  .copyWith(color: phoneText),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList());
                    }),
                20.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<UserInfo.UserContactInfo>> getContacts() async {
    List<UserInfo.UserContactInfo> contactss = [];

    var userInfo = await FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (userInfo.get('phoneNumber').isNotEmpty &&
        userInfo.data()!["privacy"]["connectContacts"]) {
      var isPermissionGranted = await FlutterContacts.requestPermission();
      isContactsPermissionGranted = isPermissionGranted;
      if (isPermissionGranted) {
        List<Contact> contacts =
            await FlutterContacts.getContacts(withProperties: true);

        var users = await FirebaseFirestore
            .instance //getting all users that signed in with phone
            .collection('users')
            .where(
              'phoneNumber',
              isNotEqualTo: '',
            )
            .get();
        var regionCode = await PhoneNumberUtil().carrierRegionCode();
        if (users.docs.isNotEmpty) {
          for (var user in users.docs) {
            if (user.get('phoneNumber') != userInfo.get("phoneNumber")) {
              try {
                var phoneNumber = user.get('phoneNumber');

                var contactIndex = -1;
                if(Platform.isIOS) {
                  for (var contact in contacts) {
                    try {
                      var number = contact.phones.first.number;
                      var parsedNumber = await PhoneNumberUtil().parse(
                          number, regionCode: regionCode);
                      if (parsedNumber.e164 == phoneNumber)
                        contactIndex = contacts.indexOf(contact);
                    } catch (e) {
                      // print(e);
                    }
                  }
                }else{
                  contactIndex = contacts.indexWhere((contact) {
                    if(contact.phones.isNotEmpty) return (contact.phones.first.normalizedNumber == phoneNumber);
                    else return false;
                  });
                }

                if (contactIndex != -1) {
                  var name = user.get('username');
                  var email = user.get('email');
                  var imageURL = user.get('imageURL');
                  var id = user.id;

                  contactss.add(UserInfo.UserContactInfo(
                      id: id,
                      phoneNumber: phoneNumber,
                      imageURL: imageURL,
                      name: name,
                      email: email));
                }
              } catch (e) {}
            }
          }
        }
      }
    }
    contactsList = contactss;
    return contactss;
  }
}
