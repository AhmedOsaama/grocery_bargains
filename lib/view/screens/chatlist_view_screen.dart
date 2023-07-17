import 'dart:developer';
import 'dart:io';

import 'package:bargainb/main.dart';
import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/models/user_info.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/components/draggable_list.dart';
import 'package:bargainb/view/components/search_widget.dart';
import 'package:bargainb/view/screens/chatlists_screen.dart';
import 'package:bargainb/view/screens/contact_profile_screen.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/widgets/invite_members_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/chat_view_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../../utils/tooltips_keys.dart';
import '../../utils/triangle_painter.dart';
import '../components/dotted_container.dart';
import '../components/generic_field.dart';
import '../components/search_delegate.dart';

var imagesWidgets = ValueNotifier(<Widget>[]);

class ChatListViewScreen extends StatefulWidget {
  final String listId;
  final bool isUsingDynamicLink;
  final bool isNotificationOpened;
  final bool? isExpandingChatlist;
  ChatListViewScreen({
    Key? key,
    required this.listId,
    this.isUsingDynamicLink = false,
    this.isNotificationOpened = false,
    this.isExpandingChatlist,
  }) : super(key: key);

  @override
  State<ChatListViewScreen> createState() => _ChatListViewScreenState();
}

class _ChatListViewScreenState extends State<ChatListViewScreen> {
  bool isDeleting = false;
  late Future<Widget> getUserImagesFuture;
  late Future<QuerySnapshot> getListItemsFuture;
  bool isEditingName = false;
  List<UserContactInfo> listUsers = [];
  List<UserContactInfo> contactsList = [];
  var inviteFriendController = TextEditingController();
  bool isContactsPermissionGranted = false;

  late ChatList chatList;

  bool isFirstTime = false;

  Future<Null> getFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstTime = prefs.getBool("firstTime") ?? true;
    });
  }

  @override
  void initState() {
    getFirstTime();
    chatList = Provider.of<ChatlistsProvider>(context, listen: false)
        .chatlists
        .firstWhere((chatList) => chatList.id == widget.listId);
    if (widget.isUsingDynamicLink) {
      var currentUserId = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore.instance.collection('/lists').doc(widget.listId).get().then((listSnapshot) {
        final List userIds = listSnapshot.data()!['userIds'];
        if (!userIds.contains(currentUserId)) {
          userIds.add(currentUserId);
          FirebaseFirestore.instance.collection('/lists').doc(widget.listId).update({"userIds": userIds});
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("${LocaleKeys.userAddedToChatlist.tr()} ${chatList.name}")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.userAlreadyExists.tr())));
        }
      });
    }
    getUserImagesFuture = getUserImages();
    TrackingUtils().trackPageVisited("Chatlist screen", FirebaseAuth.instance.currentUser!.uid);

    super.initState();
  }

  Future<Widget> getUserImages() async {
    List<Widget> imageWidgets = [];
    List userIds = [];
    List allUserIds = [];
    imageWidgets.clear();
    try {
      print(allUserIds);
      final list =
          await FirebaseFirestore.instance.collection('/lists').doc(widget.listId).get().timeout(Duration(seconds: 10));
      userIds = list['userIds'];
    } catch (e) {
      print(e);
      return SvgPicture.asset(
        peopleIcon,
        width: 35.w,
        height: 35.h,
      );
    }
    if (userIds.isEmpty) return SvgPicture.asset(peopleIcon);
    String imageUrl = "";
    String userName = "";
    String email = "";
    String phoneNumber = "";
    String id = "";
    for (var userId in userIds) {
      //for every userId in the chatlist
      final userSnapshot = await FirebaseFirestore.instance.collection('/users').doc(userId).get();
      imageUrl = userSnapshot.data()!['imageURL'];
      email = userSnapshot.data()!['email'];
      userName = userSnapshot.data()!['username'];
      phoneNumber = userSnapshot.data()!['phoneNumber'];
      id = userSnapshot.id;
      listUsers
          .add(UserContactInfo(id: id, phoneNumber: phoneNumber, imageURL: imageUrl, name: userName, email: email));

      if (imageUrl.isEmpty) {
        if (imageWidgets.length < 3)
          imageWidgets.add(
            SvgPicture.asset(
              bee,
              width: 20,
              height: 20,
            ),
          );
      } else {
        if (imageWidgets.length < 3)
          imageWidgets.add(CircleAvatar(
            backgroundImage: NetworkImage(
              imageUrl,
            ),
            radius: 10,
          ));
      }
    }
    if (userIds.length > 3) {
      imageWidgets.add(Text(
        "......",
        style: TextStyles.textViewBold15.copyWith(color: black),
      ));
    }
    var userInfo =
        await FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser?.uid).get();

    if (userInfo.get('phoneNumber').isNotEmpty && userInfo.data()!["privacy"]["connectContacts"]) {
      var isPermissionGranted = await FlutterContacts.requestPermission();
      isContactsPermissionGranted = isPermissionGranted;
      if (isPermissionGranted) {
        List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
        print("Contacts size: " + contacts.length.toString());

        var users = await FirebaseFirestore.instance //getting all users that signed in with phone
            .collection('users')
            .where('phoneNumber', isNotEqualTo: '')
            .get();
        var regionCode = await PhoneNumberUtil().carrierRegionCode();
        if (users.docs.isNotEmpty) {
          for (var user in users.docs) {
            try {
              var phoneNumber = user.get('phoneNumber');
              var contactIndex = -1;
              if (Platform.isIOS) {
                for (var contact in contacts) {
                  try {
                    var number = contact.phones.first.number;
                    var parsedNumber = await PhoneNumberUtil().parse(number, regionCode: regionCode);
                    if (parsedNumber.e164 == phoneNumber) contactIndex = contacts.indexOf(contact);
                  } catch (e) {
                    // print(e);
                  }
                }
              } else {
                contactIndex = contacts.indexWhere((contact) {
                  if (contact.phones.isNotEmpty)
                    return (contact.phones.first.normalizedNumber == phoneNumber);
                  else
                    return false;
                });
              }

              if (contactIndex != -1) {
                //match found
                var contact = contacts.elementAt(contactIndex);
                var participantIndex = -1;
                if (Platform.isIOS) {
                  for (var participant in listUsers) {
                    try {
                      var number = contact.phones.first.number;
                      var parsedNumber = await PhoneNumberUtil().parse(number, regionCode: regionCode);
                      if (parsedNumber.e164 == participant.phoneNumber)
                        participantIndex = listUsers.indexOf(participant);
                    } catch (e) {
                      // print(e);
                    }
                  }
                } else {
                  participantIndex = listUsers.indexWhere((participant) {
                    return participant.phoneNumber == contact.phones.first.normalizedNumber;
                  });
                }

                if (participantIndex == -1) {
                  //contact is not part of the chatlist
                  var name = user.get('username');
                  var email = user.get('email');
                  var imageURL = user.get('imageURL');
                  var id = user.id;
                  contactsList.add(
                      UserContactInfo(id: id, phoneNumber: phoneNumber, imageURL: imageURL, name: name, email: email));
                }
              }
            } catch (e) {
              log(e.toString());
            }
          }
        }
      }
    }

    return Stack(
        children: imageWidgets
            .map((image) => Positioned(
                  right: imageWidgets.indexOf(image) * 15,
                  child: image,
                ))
            .toList());
  }

  String getTotalListPrice(List items) {
    var total = 0.0;
    for (var item in items) {
      try {
        total += item['item_price'] ?? 99999;
      } catch (e) {
        total += 0;
      }
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: white, boxShadow: [
          BoxShadow(blurRadius: 50, offset: Offset(0, 20), color: Color.fromRGBO(52, 99, 237, 0.15)),
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            75.ph,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SearchWidget(isBackButton: true),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  isEditingName
                      ? Container(
                          width: 200.w,
                          child: TextFormField(
                            initialValue: chatList.name,
                            style: TextStyles.textViewSemiBold24.copyWith(color: prussian),
                            onFieldSubmitted: (value) async {
                              await updateListName(value);
                            },
                          ),
                        )
                      : Container(
                          width: 150.w,
                          child: Text(
                            chatList.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStylesInter.textViewSemiBold26.copyWith(color: blackSecondary),
                          ),
                        ),
                  Spacer(),
                  DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(6),
                    dropdownColor: purple10,
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    items: [
                      DropdownMenuItem(
                          value: 'Rename',
                          child: Text(
                            LocaleKeys.rename.tr(),
                            style: TextStyles.textViewMedium12.copyWith(color: prussian),
                          )),
                      DropdownMenuItem(
                          value: 'Remove',
                          child: Text(LocaleKeys.remove.tr(),
                              style: TextStyles.textViewMedium12.copyWith(color: prussian))),
                    ],
                    onChanged: (option) {
                      if (option == 'Rename') {
                        setState(() {
                          isEditingName = true;
                        });
                      } else if (option == 'Remove') {
                        showDialog(
                            context: context,
                            builder: (ctx) => Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          groceryList,
                                        ),
                                        // 20.ph,
                                        Text(
                                          LocaleKeys.areYouSureToDelete.tr(),
                                          style: TextStylesInter.textViewSemiBold20.copyWith(color: blackSecondary),
                                        ),
                                        15.ph,
                                        Row(
                                          children: [
                                            Expanded(
                                                child: GenericButton(
                                              height: 60.h,
                                              onPressed: () => AppNavigator.pop(context: context),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(6),
                                              borderColor: grey,
                                              child: Text(
                                                LocaleKeys.cancel.tr(),
                                                style: TextStyles.textViewSemiBold16.copyWith(color: Colors.black),
                                              ),
                                            )),
                                            10.pw,
                                            Expanded(
                                                child: GenericButton(
                                              height: 60.h,
                                              onPressed: () async {
                                                deleteList(context);
                                                AppNavigator.pop(context: context);
                                              },
                                              color: brightOrange,
                                              borderRadius: BorderRadius.circular(6),
                                              borderColor: grey,
                                              child: Text(
                                                LocaleKeys.delete.tr(),
                                                style: TextStyles.textViewSemiBold16.copyWith(color: Colors.white),
                                              ),
                                            )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                      }
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      showInviteMembersDialog(context);
                    },
                    icon: SvgPicture.asset(
                      newperson,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    // width: listUsers.length >= 3 ? 60.w : 35.w,
                    width: 60.w,
                    height: 30,
                    child: FutureBuilder(
                        future: getUserImagesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: verdigris,
                            ));
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: snapshot.data ?? SvgPicture.asset(bee),
                          );
                        }),
                  ),
                ],
              ),
            ),
            Expanded(
                child: ChatView(
              listId: widget.listId,
              showInviteMembersDialog: showInviteMembersDialog,
              isExpandingChatlist: widget.isExpandingChatlist,
            ))
          ],
        ),
      ),
    );
  }

  void showInviteMembersDialog(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (ctx) => InviteMembersDialog(
              listUsers: listUsers,
              isContactsPermissionGranted: isContactsPermissionGranted,
              contactsList: contactsList,
              shareList: shareListViaDeepLink,
              addContactToChatlist: addContactToChatlist,
            ));
  }

  Future<void> addContactToChatlist(UserContactInfo userInfo, BuildContext context) async {
    try {
      var userData = await FirebaseFirestore.instance
          .collection('/users')
          .where('phoneNumber', isEqualTo: userInfo.phoneNumber)
          .get();
      var userId = userData.docs.first.id;
      if (userData.docs.first.data().containsKey('token')) {
        var userDeviceToken = userData.docs.first.get('token');
        get(Uri.parse(
                'https://europe-west1-discountly.cloudfunctions.net/pushNotificationToContact?token=$userDeviceToken&chatlistName=${chatList.name}&chatlistId=${chatList.id}'))
            .then((value) => print(value.body));
      } else {
        print("FAILED TO GET USER DEVICE TOKEN");
      }
      await FirebaseFirestore.instance.collection('/lists').doc(widget.listId).update({
        "userIds": FieldValue.arrayUnion([userId]),
        "new_participant_username": userInfo.name,
      });
      setState(() {
        listUsers.clear();
        contactsList.clear();
        getUserImagesFuture = getUserImages();
      });
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          LocaleKeys.couldntFindUserWithEmail.tr(),
        ),
      ));
    }
  }

  Future<void> updateListName(String value) async {
    setState(() {
      isEditingName = false;
      chatList.name = value;
    });
    Provider.of<ChatlistsProvider>(context, listen: false).updateListName(value, widget.listId);
  }

  Future<void> deleteList(BuildContext context) async {
    Provider.of<ChatlistsProvider>(context, listen: false).deleteList(context, widget.listId);
    await pushDynamicScreen(context, screen: ChatlistsScreen());
  }

  shareListViaDeepLink() async {
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'invite_to_list',
        //canonicalUrl: '',
        title: chatList.name,
        imageUrl:
            'https://play-lh.googleusercontent.com/u6LMBvrIXH6r1LFQftqjSzebxflasn-nhcoZUlP6DjWHV6fmrwgNFyjJeFwFmckrySHF=w240-h480-rw',
        contentDescription: 'Hey, I would like to invite you to ${chatList.name} in BargainB',
        // keywords: ['Plugin', 'Branch', 'Flutter'],
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()..addCustomMetadata('list_id', chatList.id));
    BranchLinkProperties lp = BranchLinkProperties(
        //alias: 'flutterplugin', //define link url,
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
        tags: ['one', 'two', 'three']);
    BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);

    if (response.success) {
      print('Link generated: ${response.result}');
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
    }
    Share.share(response.result);
    TrackingUtils().trackShare(FirebaseAuth.instance.currentUser!.uid);
  }
}
