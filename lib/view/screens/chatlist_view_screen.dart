import 'dart:developer';
import 'dart:io';

import 'package:bargainb/main.dart';
import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/models/user_info.dart';
import 'package:bargainb/providers/tutorial_provider.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/components/search_widget.dart';
import 'package:bargainb/features/chatlists/presentation/views/chatlists_screen.dart';
import 'package:bargainb/view/screens/contact_profile_screen.dart';
import 'package:bargainb/view/screens/main_screen.dart';
import 'package:bargainb/view/widgets/invite_members_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/view/widgets/chat_view_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../../utils/tooltips_keys.dart';
import '../../utils/triangle_painter.dart';

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
  FocusNode chatlistNameFocus = FocusNode();

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
    getUserImagesFuture = getUserImages();
    FirebaseMessaging.instance.getToken().then((value) => print("USER TOKEN: $value"));
    TrackingUtils().trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Chatlist Screen");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tutorialProvider = Provider.of<TutorialProvider>(context);
    return Scaffold(
      // bottomNavigationBar: null,
      resizeToAvoidBottomInset: true,
      body: ShowCaseWidget(
        disableBarrierInteraction: true,
          builder: Builder(builder: (showcaseContext) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (tutorialProvider.isTutorialRunning) {
                ShowCaseWidget.of(showcaseContext).startShowCase([TooltipKeys.showCase5, TooltipKeys.showCase6]);
                // ShowCaseWidget.of(showcaseContext).startShowCase([TooltipKeys.showCase6]);
              }
            });
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(color: isFirstTime ? Color.fromRGBO(25, 27, 38, 0.6) : Color.fromRGBO(245, 247, 254, 1), boxShadow: [
              BoxShadow(blurRadius: 50, offset: Offset(0, 20), color: Color.fromRGBO(52, 99, 237, 0.15)),
            ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      GestureDetector(onTap: () => AppNavigator.pop(context: context), child: Icon(Icons.arrow_back_ios_new_outlined,color: mainPurple,)),
                      5.pw,
                      isEditingName
                          ? Container(
                              width: 200.w,
                              child: TextFormField(
                                initialValue: chatList.name,
                                style: TextStyles.textViewSemiBold24.copyWith(color: prussian),
                                focusNode: chatlistNameFocus,
                                onFieldSubmitted: (value) async {
                                  chatlistNameFocus.unfocus();
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
                      Showcase.withWidget(
                        height: 50,
                        width: 150.w,
                        targetBorderRadius: BorderRadius.circular(10),
                        key: tutorialProvider.isTutorialRunning ? TooltipKeys.showCase5 : new GlobalKey<State<StatefulWidget>>(),
                        tooltipPosition: TooltipPosition.bottom,
                        container: buildTutorialContainer(showcaseContext),
                        child: IconButton(
                          onPressed: () {
                            showInviteMembersDialog(context);
                            TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Show invite members dialog", DateTime.now().toUtc().toString(), "Chatlist screen");
                          },
                          icon: SvgPicture.asset(
                            newperson,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      10.pw,
                      Container(
                        width: listUsers.length > 1 ? 60.w : 30.w,
                        height: 40,
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
                                padding: const EdgeInsets.only(top: 11.0),
                                child: snapshot.data ?? SvgPicture.asset(bee),
                              );
                            }),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert),
                          onSelected: (option){
                        if (option == 'Rename') {
                          setState(() {
                            isEditingName = true;
                          });
                          Future.delayed(Duration(milliseconds: 500), (){
                            FocusScope.of(context).requestFocus(chatlistNameFocus);
                          });
                        } else if (option == 'Remove') {
                          showRemoveDialog(context);
                        }
                      }, itemBuilder: (ctx) => [
                        PopupMenuItem(
                            value: 'Rename',
                            child: Text(
                              LocaleKeys.rename.tr(),
                              style: TextStyles.textViewMedium12.copyWith(color: prussian),
                            )),
                        PopupMenuItem(
                            value: 'Remove',
                            child: Text(LocaleKeys.remove.tr(),
                                style: TextStyles.textViewMedium12.copyWith(color: prussian)))
                      ] ),
                    ],
                  ),
                ),
                Expanded(
                    child: ChatView(
                  listId: widget.listId,
                  showInviteMembersDialog: showInviteMembersDialog,
                  isExpandingChatlist: widget.isExpandingChatlist,
                      chatlistName: chatList.name,
                      showcaseContext: showcaseContext,
                ))
              ],
            ),
          ),
        );
  }
      ),
      )
    );
  }

  Container buildTutorialContainer(BuildContext showcaseContext) {
    return Container(
                        child: Column(
                          children: [
                            Container(
                              height: 11,
                              width: 13,
                              child: CustomPaint(
                                painter: TrianglePainter(
                                  strokeColor: purple70,
                                  strokeWidth: 1,
                                  paintingStyle: PaintingStyle.fill,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              width: 160.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: purple70,
                              ),
                              child: Column(
                                  children: [
                                    Text(
                                      "Collaborate with your loved ones, share grocery lists, and  your AI sidekick".tr(),
                                      maxLines: 4,
                                      style: TextStyles.textViewRegular13.copyWith(color: white),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        ShowCaseWidget.of(showcaseContext).next();
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Next".tr(),
                                            style: TextStyles.textViewSemiBold14.copyWith(color: white),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: white,
                                            size: 15.sp,
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      );
  }


  Future<Widget> getUserImages() async {
    listUsers.clear();
    List<Widget> imageWidgets = [];
    List userIds = [];
    imageWidgets.clear();
    try {
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
      final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
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
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();

    if (userInfo.get('phoneNumber').isNotEmpty && userInfo.data()!["privacy"]["connectContacts"]) {
      var isPermissionGranted = await FlutterContacts.requestPermission();
      isContactsPermissionGranted = isPermissionGranted;
      if (isPermissionGranted) {
        List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
      log("Contacts size: ${contacts.length}");
        // print("Contacts size: ${contacts.length}");

        var users = await FirebaseFirestore.instance //getting all users that signed in with phone
            .collection('users')
            .where('phoneNumber', isNotEqualTo: '')
            .get();
        var regionCode = await PhoneNumberUtil().carrierRegionCode();
        log(regionCode.toString());
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
        alignment: AlignmentDirectional.center,
        children: imageWidgets
            .map((image) => Positioned(
          right: imageWidgets.indexOf(image) * 15,
          child: image,
        ))
            .toList());
  }


  Future<dynamic> showRemoveDialog(BuildContext context) {
    return showDialog(
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
                                            onPressed: () => AppNavigator.pop(context: ctx),
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
                                              await deleteList(context);
                                              AppNavigator.pushReplacement(context: context, screen: ChatlistsScreen());
                                              AppNavigator.pop(context: ctx);
                                              // AppNavigator.pop(context: context);
                                              // return Future.value(1);
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
            )).then((value) {
              if(isFirstTime){
                setState(() {
                  isFirstTime = false;
                });
              }
              if(value == "Phone Added"){
                setState(() {
                  getUserImagesFuture = getUserImages();
                });
              }
    });
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
  }
}
