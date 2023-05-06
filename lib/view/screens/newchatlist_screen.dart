import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/components/chats_search_delegate.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/models/userinfo.dart' as UserInfo;
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/contact_profile_screen.dart';
import 'package:bargainb/view/screens/newgroupchat_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  List<UserInfo.UserInfo> contactsList = [];
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
          "New chatlist",
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
                      AppNavigator.push(
                          context: context,
                          screen: ChatListViewScreen(
                            listId: id,
                          ));
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
                        "New group chatlist",
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
                        "New contact",
                        style: TextStyles.textViewSemiBold16
                            .copyWith(color: black),
                      )
                    ],
                  ),
                ),
                10.ph,
                GestureDetector(
                  onTap: () {
                    Share.share('Hello! I’m using BargainB, you can down...');
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
                        "Invite to BargainB",
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
                    'CONTACTS ON BARGAINB',
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
                                  'No contacts found :(',
                                  style: TextStylesInter.textViewRegular12
                                      .copyWith(color: black),
                                )
                              : Text(
                                  'Please add your number to see your friends on BargainB',
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

  Future<List<UserInfo.UserInfo>> getContacts() async {
    List<UserInfo.UserInfo> contactss = [];

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
        if (users.docs.isNotEmpty) {
          for (var user in users.docs) {
            if (user.get('phoneNumber') != userInfo.get("phoneNumber")) {
              try {
                var phoneNumber = user.get('phoneNumber');

                var contactIndex = contacts.indexWhere((contact) {
                  return (contact.phones.first.normalizedNumber == phoneNumber);
                });

                if (contactIndex != -1) {
                  var name = user.get('username');
                  var email = user.get('email');
                  var imageURL = user.get('imageURL');
                  var id = user.id;

                  contactss.add(UserInfo.UserInfo(
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
