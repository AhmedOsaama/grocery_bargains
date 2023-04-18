import 'dart:io';

import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/fonts_utils.dart';
import 'package:bargainb/view/components/generic_appbar.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/view/components/my_scaffold.dart';
import 'package:bargainb/view/components/plus_button.dart';
import 'package:bargainb/view/screens/category_items_screen.dart';
import 'package:bargainb/view/screens/chat_view_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/chat_view_widget.dart';

import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';
import '../components/dotted_container.dart';

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
  List<UserInfo> listUsers = [];
  List<UserInfo> contactsList = [];
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
      return SvgPicture.asset(peopleIcon);
    }
    if (userIds.isEmpty) return SvgPicture.asset(peopleIcon);
    String imageUrl = "";
    String userName = "";
    String email = "";
    String phoneNumber = "";
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
      listUsers.add(UserInfo(
          phoneNumber: phoneNumber,
          imageURL: imageUrl,
          name: userName,
          email: email));
      imageWidgets.add(CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
        radius: 20,
      ));
    }
    var userInfo = await FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (userInfo.get('phoneNumber').isNotEmpty) {
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
            var phoneNumber = user.get('phoneNumber');
            var contactIndex = contacts.indexWhere((contact) =>
                contact.phones.first.normalizedNumber == phoneNumber);
            if (contactIndex != -1) {
              //match found
              var contact = contacts.elementAt(contactIndex);
              var participantIndex = listUsers.indexWhere((participant) =>
                  participant.phoneNumber ==
                  contact.phones.first.normalizedNumber);
              if (participantIndex == -1) {
                //contact not found in participants
                var name = user.get('username');
                var email = user.get('email');
                var imageURL = user.get('imageURL');
                contactsList.add(UserInfo(
                    phoneNumber: phoneNumber,
                    imageURL: imageURL,
                    name: name,
                    email: email));
              }
            }
          }
        }
      }
    }

    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15),
      // color: Colors.red,
      // width: 50.w,
      height: 50.h,
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
          Container(
            width: 150.w,
            child: InkWell(
              onTap: () async {
                setState(() {
                  isInvitingFriends = !isInvitingFriends;
                });
              },
              child: Row(
                children: [
                  Expanded(
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
                          return snapshot.data ??
                              const Text("Something went wrong");
                        }),
                  ),
                  // 5.pw,
                  Icon(Icons.arrow_drop_down),
                  10.pw,
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              30.pw,
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
          if (isInvitingFriends)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (listUsers.isNotEmpty) ...[
                    Text(
                      'Participants',
                      style: TextStylesInter.textViewRegular12
                          .copyWith(color: mainPurple),
                    ),
                    10.ph,
                    ListView(
                        shrinkWrap: true,
                        children: listUsers.map((userInfo) {
                          return Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  userInfo.imageURL,
                                ),
                                radius: 20,
                              ),
                              20.pw,
                              Text(
                                userInfo.name,
                                style: TextStylesInter.textViewRegular16
                                    .copyWith(color: black2),
                              )
                            ],
                          );
                        }).toList()),
                  ],
                  10.ph,
                  if (contactsList.isNotEmpty) ...[
                    Text(
                      'Your Contacts',
                      style: TextStylesInter.textViewRegular12
                          .copyWith(color: mainPurple),
                    ),
                    10.ph,
                    ListView(
                        shrinkWrap: true,
                        children: contactsList.map((userInfo) {
                          return Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  userInfo.imageURL,
                                ),
                                radius: 20,
                              ),
                              20.pw,
                              Text(
                                userInfo.name,
                                style: TextStylesInter.textViewRegular16
                                    .copyWith(color: black2),
                              ),
                              Spacer(),
                              TextButton(
                                  onPressed: () => addContactToChatlist(userInfo,context),
                                  child: Text("Add")),
                            ],
                          );
                        }).toList()),
                  ],
                  if (contactsList.isEmpty && !isContactsPermissionGranted)
                    Text(
                        "Please add your number to see your friends on BargainB"),
                  if (contactsList.isEmpty && isContactsPermissionGranted)
                    Text("No contacts found on BargainB"),
                  TextButton(
                      onPressed: () {
                        //TODO: share via link
                        // shareListViaDeepLink();
                      },
                      child: Text(
                        "Invite via link",
                        style: TextStylesInter.textViewRegular15
                            .copyWith(color: mainPurple),
                      )),
                  // GenericField(
                  //   controller: inviteFriendController,
                  //   prefixIcon: Icon(Icons.person_add_alt),
                  //   hintText: LocaleKeys.inputEmail.tr(),
                  //   hintStyle:
                  //       TextStylesDMSans.textViewBold14.copyWith(color: black2),
                  //   onSubmitted: (email) async {
                  //     try {
                  //       var userData = await FirebaseFirestore.instance
                  //           .collection('/users')
                  //           .where('email', isEqualTo: email.trim())
                  //           .get();
                  //       var userId = userData.docs.first.id;
                  //       FirebaseFirestore.instance
                  //           .collection('/lists')
                  //           .doc(widget.listId)
                  //           .update({
                  //         "userIds": FieldValue.arrayUnion([userId])
                  //       });
                  //     } catch (e) {
                  //       print("ERROR: $e");
                  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //         content: Text(
                  //           "Couldn't find a user with that email",
                  //         ),
                  //       ));
                  //     }
                  //     inviteFriendController.clear();
                  //   },
                  // )
                ],
              ),
            ),
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
                    DropdownMenuItem(value: 'rename', child: Text("Rename")),
                    DropdownMenuItem(value: 'remove', child: Text("Remove")),
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
                        // getListItemsFuture = FirebaseFirestore.instance
                        //     .collection('/lists/${widget.listId}/items').orderBy('time')
                        //     .get();
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
                        if (items.isEmpty || !snapshot.hasData) {
                          return Container(
                            margin: EdgeInsets.only(top: 100.h),
                            alignment: Alignment.topCenter,
                            child: DottedContainer(
                              text: LocaleKeys.addToListFirstItem.tr(),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            Row(
                              children: [
                                // IconButton(
                                //     onPressed: () => shareListViaDeepLink(), icon: Icon(Icons.share_outlined)),
                                // IconButton(
                                //     onPressed: () {
                                //       setState(() {
                                //         widget.isListView = !widget.isListView;
                                //       });
                                //     },
                                //     icon: Icon(Icons.message_outlined)),
                                Spacer(),
                                Text(
                                  "${items.length} items",
                                  style: TextStyles.textViewMedium10.copyWith(
                                      color: Color.fromRGBO(204, 204, 203, 1)),
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
                              ],
                            ),
                            Expanded(
                              child: ListView.separated(
                                  itemCount: items.length,
                                  separatorBuilder: (ctx, _) => const Divider(),
                                  itemBuilder: (ctx, i) {
                                    var doc = items[i];
                                    var isChecked = items[i]['item_isChecked'];
                                    if (items[i]['text'] != '') {
                                      return Opacity(
                                        opacity: isChecked ? 0.6 : 1,
                                        child: Row(
                                          children: [
                                            30.pw,
                                            Checkbox(
                                              value: isChecked,
                                              onChanged: (value) {
                                                setState(() {
                                                  isChecked = !isChecked;
                                                });
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        "/lists/${doc.reference.parent.parent?.id}/items")
                                                    .doc(doc.id)
                                                    .update({
                                                  "item_isChecked": isChecked,
                                                }).catchError((e) {
                                                  print(e);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "This operation couldn't be done please try again")));
                                                });
                                                // updateList();
                                              },
                                            ),
                                            Text(
                                              items[i]['text'],
                                              style: TextStylesInter
                                                  .textViewRegular16
                                                  .copyWith(color: black2),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    var itemName = items[i]['item_name'];
                                    var itemImage = items[i]['item_image'];
                                    var itemDescription = items[i]['item_size'];
                                    var itemPrice = items[i]['item_price'];
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Opacity(
                                            opacity: isChecked ? 0.6 : 1,
                                            child: Row(
                                              children: [
                                                30.pw,
                                                Checkbox(
                                                  value: isChecked,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isChecked = !isChecked;
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "/lists/${doc.reference.parent.parent?.id}/items")
                                                        .doc(doc.id)
                                                        .update({
                                                      "item_isChecked":
                                                          isChecked,
                                                    }).catchError((e) {
                                                      print(e);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "This operation couldn't be done please try again")));
                                                    });
                                                    // updateList();
                                                  },
                                                ),
                                                Image.network(
                                                  itemImage,
                                                  width: 55,
                                                  height: 55,
                                                ),
                                                SizedBox(
                                                  width: 12.w,
                                                ),
                                                Container(
                                                  width: 140.w,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        itemName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyles
                                                            .textViewSemiBold14
                                                            .copyWith(
                                                                color: prussian,
                                                                decoration: isChecked
                                                                    ? TextDecoration
                                                                        .lineThrough
                                                                    : null),
                                                      ),
                                                      Container(
                                                        width: 150.w,
                                                        child: Text(
                                                          "$itemDescription",
                                                          style: TextStyles
                                                              .textViewLight12
                                                              .copyWith(
                                                                  color:
                                                                      prussian,
                                                                  decoration: isChecked
                                                                      ? TextDecoration
                                                                          .lineThrough
                                                                      : null),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "€ $itemPrice",
                                                  style: TextStyles
                                                      .textViewMedium13
                                                      .copyWith(
                                                    color: prussian,
                                                    decoration: isChecked
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              await deleteItemFromList(
                                                  items, i, doc);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        );
                      }),
                )
              : Expanded(child: ChatView(listId: widget.listId,))
        ],
      ),
    );
  }

  Future<void> addContactToChatlist(
      UserInfo userInfo, BuildContext context) async {
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

  Future<void> deleteItemFromList(List<QueryDocumentSnapshot<Object?>> items,
      int i, QueryDocumentSnapshot<Object?> doc) async {
    try {
      await Provider.of<ChatlistsProvider>(context, listen: false)
          .deleteItemFromChatlist(
          widget.listId, doc.id, items[i]['item_price']);
    }catch(e){
      print(e);
    }
    setState(() {
      items.remove(items[i]);
    });
    //TODO: check if the item has a chat reference before deleting and if it has then mark the item as un added
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

  void deleteList(BuildContext context) {
    Provider.of<ChatlistsProvider>(context, listen: false)
        .deleteList(context, widget.listId);
  }
}

class UserInfo {
  String name;
  String email;
  String imageURL;
  String phoneNumber;
  UserInfo(
      {required this.phoneNumber,
      required this.imageURL,
      required this.name,
      required this.email});
}
