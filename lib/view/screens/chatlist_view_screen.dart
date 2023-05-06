import 'dart:developer';
import 'dart:io';

import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/models/userinfo.dart' as UserInfo;
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/view/components/draggable_list.dart';
import 'package:bargainb/view/screens/chatlists_screen.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/chat_view_widget.dart';

import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../components/dotted_container.dart';

var imagesWidgets = ValueNotifier(<Widget>[]);

class ChatListViewScreen extends StatefulWidget {
  final String listId;
  // String listName;
  // final String? storeName;
  // final String? storeImage;
  final bool isUsingDynamicLink;
  final bool isNotificationOpened;
  bool isListView;
  // final Function? updateList;
  ChatListViewScreen({
    Key? key,
    required this.listId,
    // required this.listName,
    this.isUsingDynamicLink = false,
    // this.storeName,
    // this.storeImage,
    // this.updateList,
    this.isListView = false, //The screen opens on a Chat View by default
    this.isNotificationOpened = false,
  }) : super(key: key);

  @override
  State<ChatListViewScreen> createState() => _ChatListViewScreenState();
}

class _ChatListViewScreenState extends State<ChatListViewScreen> {
  bool isDeleting = false;
  late Future<Widget> getUserImagesFuture;
  late Future<QuerySnapshot> getListItemsFuture;
  bool isEditingName = false;
  List<UserInfo.UserInfo> listUsers = [];
  List<UserInfo.UserInfo> contactsList = [];
  var inviteFriendController = TextEditingController();
  bool isContactsPermissionGranted = false;

  var isInvitingFriends = false;
  late ChatList chatList;

  @override
  void initState() {
    chatList = Provider.of<ChatlistsProvider>(context, listen: false)
        .chatlists
        .firstWhere((chatList) => chatList.id == widget.listId);
    if (widget.isUsingDynamicLink) {
      var currentUserId = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore.instance
          .collection('/lists')
          .doc(widget.listId)
          .get()
          .then((listSnapshot) {
        final List userIds = listSnapshot.data()!['userIds'];
        if (!userIds.contains(currentUserId)) {
          userIds.add(currentUserId);
          FirebaseFirestore.instance
              .collection('/lists')
              .doc(widget.listId)
              .update({"userIds": userIds});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("User added successfully to list ${chatList.name}")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User Already Exists in the list")));
        }
      });
    }
    getUserImagesFuture = getUserImages();

    // getListItemsFuture = FirebaseFirestore.instance
    //     .collection('/lists/${widget.listId}/items')
    //     .get();
    super.initState();
  }

  Future<Widget> getUserImages() async {
    List<Widget> imageWidgets = [];
    List userIds = [];
    List allUserIds = [];
    imageWidgets.clear();
    try {
      // var allLists = await FirebaseFirestore.instance
      //     .collection('/lists')
      //     .get()
      //     .timeout(Duration(seconds: 10));
      // allLists.docs.forEach((doc) {
      //   allUserIds.add(...(doc['userIds'] as List)
      //       .where((userId) => !allUserIds.contains(userId))
      //   );
      // });
      print(allUserIds);
      final list = await FirebaseFirestore.instance
          .collection('/lists')
          .doc(widget.listId)
          .get()
          .timeout(Duration(seconds: 10));
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
      final userSnapshot = await FirebaseFirestore.instance
          .collection('/users')
          .doc(userId)
          .get();
      imageUrl = userSnapshot.data()!['imageURL'];
      email = userSnapshot.data()!['email'];
      userName = userSnapshot.data()!['username'];
      phoneNumber = userSnapshot.data()!['phoneNumber'];
      id = userSnapshot.data()!['phoneNumber'];
      listUsers.add(UserInfo.UserInfo(
          id: id,
          phoneNumber: phoneNumber,
          imageURL: imageUrl,
          name: userName,
          email: email));

      if (imageUrl.isEmpty) {
        imageWidgets.add(
          SvgPicture.asset(
            peopleIcon,
            width: 40.w,
            height: 40.h,
          ),
        );
      } else {
        imageWidgets.add(CircleAvatar(
          backgroundImage: NetworkImage(
            imageUrl,
          ),
          radius: 20,
        ));
      }
    }
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
        print("Contacts size: " + contacts.length.toString());

        var users = await FirebaseFirestore
            .instance //getting all users that signed in with phone
            .collection('users')
            .where('phoneNumber', isNotEqualTo: '')
            .get();
        if (users.docs.isNotEmpty) {
          for (var user in users.docs) {
            try {
              var phoneNumber = user.get('phoneNumber');

              var contactIndex = contacts.indexWhere((contact) {
                return (contact.phones.first.normalizedNumber == phoneNumber);
              });

              if (contactIndex != -1) {
                //match found
                var contact = contacts.elementAt(contactIndex);
                var participantIndex = listUsers.indexWhere((participant) =>
                    participant.phoneNumber ==
                    contact.phones.first.normalizedNumber);
                if (participantIndex == -1) {
                  //contact is not part of the chatlist
                  var name = user.get('username');
                  var email = user.get('email');
                  var imageURL = user.get('imageURL');
                  var id = "";
                  contactsList.add(UserInfo.UserInfo(
                      id: id,
                      phoneNumber: phoneNumber,
                      imageURL: imageURL,
                      name: name,
                      email: email));
                }
              }
            } catch (e) {
              log(e.toString());
            }
          }
        }
      }
    }

    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15),
      // color: Colors.red,
      // width: 50.w,
      //height: 100.h,
      child: Stack(
          children: imageWidgets
              .map((image) => Positioned(
                    right: imageWidgets.indexOf(image) * 25,
                    child: image,
                  ))
              .toList()),
    );
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
    // var chatlistsProvider =
    //     Provider.of<ChatlistsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        foregroundColor: Colors.black,
        leading: widget.isNotificationOpened
            ? IconButton(
                icon: Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios),
                onPressed: () => AppNavigator.pushReplacement(
                    context: context, screen: MainScreen()),
              )
            : null,
        actions: [
          InkWell(
            onTap: () async {
              setState(() {
                isInvitingFriends = !isInvitingFriends;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: ScreenUtil().screenHeight / 4,
                  // height: 50,
                  child: FutureBuilder(
                      future: getUserImagesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: verdigris,
                          ));
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: snapshot.data ?? SvgPicture.asset(peopleIcon),
                        );
                      }),
                ),
                // 5.pw,
                Icon(
                  isInvitingFriends
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: mainPurple,
                  size: 35.sp,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: white, boxShadow: [
              BoxShadow(
                  blurRadius: 50,
                  offset: Offset(0, 20),
                  color: Color.fromRGBO(52, 99, 237, 0.15)),
            ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      isEditingName
                          ? Container(
                              width: 210.w,
                              child: TextFormField(
                                initialValue: chatList.name,
                                style: TextStyles.textViewSemiBold24
                                    .copyWith(color: prussian),
                                onFieldSubmitted: (value) async {
                                  await updateListName(value);
                                },
                              ),
                            )
                          : Container(
                              width: 210.w,
                              child: Text(
                                chatList.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.textViewSemiBold24
                                    .copyWith(color: prussian),
                              ),
                            ),
                      Spacer(),
                      DropdownButton(
                        underline: Container(),
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'rename', child: Text("Rename")),
                          DropdownMenuItem(
                              value: 'remove', child: Text("Remove")),
                          DropdownMenuItem(
                            value: 'copy',
                            enabled: false,
                            child: Text("Copy"),
                          ),
                        ],
                        onChanged: (option) {
                          if (option == 'rename') {
                            // Share.share("text");

                            setState(() {
                              isEditingName = true;
                            });
                          } else if (option == 'remove') {
                            deleteList(context);
                          }
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              widget.isListView = !widget.isListView;
                            });
                          },
                          icon: widget.isListView
                              ? Icon(Icons.chat_outlined)
                              : SvgPicture.asset(listViewIcon)),
                    ],
                  ),
                ),
                Divider(
                  height: 20.h,
                ),
                widget.isListView
                    ? Expanded(
                        child: FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('/lists/${widget.listId}/items')
                                .orderBy('time')
                                .get(),
                            builder: (context, snapshot) {
                              final items = snapshot.data?.docs ?? [];

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              }
                              var storeImages = {
                                "jumbo": false,
                                "hoogvliet": false,
                                "albert": false
                              };
                              itemsState.value = items;
                              if (itemsState.value.isNotEmpty) {
                                itemsState.value.forEach((element) {
                                  if (element["text"] == "") {
                                    if (element["item_image"]
                                        .toString()
                                        .contains("jumbo")) {
                                      storeImages["jumbo"] = true;
                                    } else if (element["item_image"]
                                        .toString()
                                        .contains(".ah.")) {
                                      storeImages["albert"] = true;
                                    } else if (element["item_image"]
                                        .toString()
                                        .contains("hoogvliet")) {
                                      storeImages["hoogvliet"] = true;
                                    }
                                  }
                                });
                              }
                              imagesWidgets.value = [];
                              storeImages.forEach((key, value) {
                                if (value) {
                                  switch (key) {
                                    case "jumbo":
                                      imagesWidgets.value.add(SizedBox(
                                          height: 50.h,
                                          width: 50.w,
                                          child: Image.asset(jumbo)));
                                      break;
                                    case "albert":
                                      imagesWidgets.value.add(SizedBox(
                                          height: 40.h,
                                          width: 40.w,
                                          child: Image.asset(albert)));

                                      break;
                                    case "hoogvliet":
                                      imagesWidgets.value.add(SizedBox(
                                          height: 50.h,
                                          width: 50.w,
                                          child: Image.asset(hoogLogo)));
                                      break;
                                  }
                                  imagesWidgets.value.add(10.pw);
                                }
                              });
                              var total = 0.0;
                              items.forEach(
                                (element) {
                                  if (element["text"].toString().isEmpty)
                                    total +=
                                        double.parse(element["item_price"]);
                                },
                              );
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Spacer(),
                                      Text(
                                        "${items.length} items",
                                        style: TextStyles.textViewMedium10
                                            .copyWith(
                                                color: Color.fromRGBO(
                                                    204, 204, 203, 1)),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        LocaleKeys.total.tr(),
                                        style: TextStyles.textViewMedium15
                                            .copyWith(color: prussian),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "€ " + total.toStringAsFixed(2),
                                        style: TextStyles.textViewBold15
                                            .copyWith(color: prussian),
                                      ),
                                      10.pw
                                    ],
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: imagesWidgets,
                                      builder: (context, value, m) {
                                        return imagesWidgets.value.isNotEmpty
                                            ? Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Stores",
                                                        style: TextStyles
                                                            .textViewMedium10
                                                            .copyWith(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        113,
                                                                        146,
                                                                        242,
                                                                        1)),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children:
                                                            imagesWidgets.value,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container();
                                      }),
                                  items.isEmpty
                                      ? Column(
                                          children: [
                                            40.ph,
                                            Container(
                                              alignment: Alignment.topCenter,
                                              child: DottedContainer(
                                                text: LocaleKeys
                                                    .addToListFirstItem
                                                    .tr(),
                                              ),
                                            ),
                                            40.ph,
                                          ],
                                        )
                                      : Container(),
                                  Expanded(
                                    flex: 7,
                                    child: DraggableList(
                                      inChatView: false,
                                      items: items,
                                      listId: widget.listId,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      )
                    : Expanded(
                        child: ChatView(
                        listId: widget.listId,
                      ))
              ],
            ),
          ),
          isInvitingFriends
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Wrap(
                    children: [
                      Container(
                        /*     height: contactsList.isEmpty
                            ? ScreenUtil().screenHeight * 0.3
                            : ScreenUtil().screenHeight * 0.5, */
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 20,
                                  offset: Offset(0, 20),
                                  color: Color.fromRGBO(52, 99, 237, 0.15)),
                            ]),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (listUsers.isNotEmpty) ...[
                                  Text(
                                    'Members',
                                    style: TextStylesInter.textViewSemiBold26
                                        .copyWith(color: black),
                                  ),
                                  10.ph,
                                  ListView(
                                      shrinkWrap: true,
                                      children: listUsers.map((userInfo) {
                                        return Row(
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
                                            20.pw,
                                            Text(
                                              userInfo.name,
                                              style: TextStylesInter
                                                  .textViewRegular16
                                                  .copyWith(color: black2),
                                            )
                                          ],
                                        );
                                      }).toList()),
                                ],
                                50.ph,
                                if (contactsList.isNotEmpty) ...[
                                  Text(
                                    'Add to list',
                                    style: TextStylesInter.textViewSemiBold26
                                        .copyWith(color: black),
                                  ),
                                  15.ph,
                                  Text(
                                    'CONTACTS ON BARGAINB',
                                    style: TextStylesInter.textViewRegular12
                                        .copyWith(color: mainPurple),
                                  ),
                                  10.ph,
                                  ListView(
                                      shrinkWrap: true,
                                      children: contactsList.map((userInfo) {
                                        return Padding(
                                          padding: EdgeInsets.only(top: 10),
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
                                              20.pw,
                                              Text(
                                                userInfo.name,
                                                style: TextStylesInter
                                                    .textViewRegular16
                                                    .copyWith(color: black2),
                                              ),
                                              Spacer(),
                                              InkWell(
                                                onTap: () =>
                                                    addContactToChatlist(
                                                        userInfo, context),
                                                child: Row(children: [
                                                  Text(
                                                    "Add",
                                                    style: TextStylesInter
                                                        .textViewSemiBold14
                                                        .copyWith(
                                                            color: mainPurple),
                                                  ),
                                                  10.pw,
                                                  CircleAvatar(
                                                    child: Icon(
                                                      Icons.person_add_alt,
                                                      color: white,
                                                    ),
                                                    backgroundColor: mainPurple,
                                                  )
                                                ]),
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList()),
                                ],
                                if (contactsList.isEmpty &&
                                    !isContactsPermissionGranted)
                                  Text(
                                    "Please add your number to see your friends on BargainB",
                                    style: TextStylesInter.textViewRegular15
                                        .copyWith(color: black),
                                  ),
                                if (contactsList.isEmpty &&
                                    isContactsPermissionGranted)
                                  Text(
                                    "No contacts found on BargainB",
                                    style: TextStylesInter.textViewRegular15
                                        .copyWith(color: black),
                                  ),
                                10.ph
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future<void> addContactToChatlist(
      UserInfo.UserInfo userInfo, BuildContext context) async {
    try {
      var userData = await FirebaseFirestore.instance
          .collection('/users')
          .where('phoneNumber', isEqualTo: userInfo.phoneNumber)
          .get();
      var userId = userData.docs.first.id;
      await FirebaseFirestore.instance
          .collection('/lists')
          .doc(widget.listId)
          .update({
        "userIds": FieldValue.arrayUnion([userId])
      });
      setState(() {
        listUsers.clear();
        contactsList.clear();
        getUserImagesFuture = getUserImages();
        isInvitingFriends = false;
      });
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Couldn't find a user with that email",
        ),
      ));
    }
  }

  // void markItemAsAdded() {
  //   widget.messageDocPath.update(                            //TODO: use the chat reference to update the item as un added
  //       {
  //         'isAddedToList': true,
  //       });
  // }

  // Future<void> shareListViaDeepLink() async {
  //   // final dynamicLinkParams = DynamicLinkParameters(
  //   //   link: Uri.parse(
  //   //       "https://www.google.com/add_user/${widget.listName}/${widget.listId}"), //TODO: listName has white space and that won't reflect well in using the link later
  //   //   uriPrefix: "https://swaav.page.link",
  //   //   androidParameters:
  //   //       const AndroidParameters(packageName: "thebargainb.app"),
  //   //   // iosParameters: const IOSParameters(bundleId: "com.example.app.ios"),
  //   // );
  //   // final dynamicLink =
  //   //     await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  //   // Share.share(dynamicLink.shortUrl.toString());
  //   Share.share("https://bargainb.app.link?bnc_validate=true");
  // }

  Future<void> updateListName(String value) async {
    setState(() {
      isEditingName = false;
      chatList.name = value;
    });
    Provider.of<ChatlistsProvider>(context, listen: false)
        .updateListName(value, widget.listId);
  }

  Future<void> deleteList(BuildContext context) async {
    Provider.of<ChatlistsProvider>(context, listen: false)
        .deleteList(context, widget.listId);
    await pushDynamicScreen(context, screen: ChatlistsScreen());
  }
}
