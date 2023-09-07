import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/screens/home_screen.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../models/chatlist.dart';
import '../../providers/chatlists_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../../utils/tooltips_keys.dart';
import '../../utils/triangle_painter.dart';
import '../components/button.dart';
import '../components/close_button.dart';
import '../screens/chatlists_screen.dart';
import '../screens/contact_profile_screen.dart';
import '../screens/main_screen.dart';

class InviteMembersDialog extends StatefulWidget {
  final List listUsers;
  final bool isContactsPermissionGranted;
  final List contactsList;
  final Function shareList;
  final Function addContactToChatlist;
  InviteMembersDialog(
      {Key? key,
      required this.listUsers,
      required this.isContactsPermissionGranted,
      required this.contactsList,
      required this.shareList,
      required this.addContactToChatlist,
      })
      : super(key: key);

  @override
  State<InviteMembersDialog> createState() => _InviteMembersDialogState();
}

class _InviteMembersDialogState extends State<InviteMembersDialog> {
  bool isFirstTime = true;

  Future<Null> getFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstTime = prefs.getBool("firstTime") ?? true;
    });
  }

  Future<Null> turnOffFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("firstTime", false);
      isFirstTime = false;
    });
  }

  @override
  void initState() {
    getFirstTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var chatlistsProvider = Provider.of<ChatlistsProvider>(context,listen: false);
    return ShowCaseWidget(
      onFinish: () async {
        // AppNavigator.pop(context: context);
        chatlistsProvider.deleteList(context, chatlistsProvider.chatlists.last.id);
        chatlistsProvider.stopwatch.stop();
        var onboardingDuration = chatlistsProvider.stopwatch.elapsed.inSeconds.toString();
        print("Onboarding duration: " + onboardingDuration);
      },
      builder: Builder(builder: (showCaseContext){
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (isFirstTime) {
            ShowCaseWidget.of(showCaseContext).startShowCase([TooltipKeys.showCase6]);
          }
        });
       return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Showcase.withWidget(
            height: 50,
            width: 150,
            targetBorderRadius: BorderRadius.circular(10),
            key: isFirstTime ? TooltipKeys.showCase6 : new GlobalKey<State<StatefulWidget>>(),
            tooltipPosition: TooltipPosition.bottom,
            container: Container(
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
                    width: 240.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: purple70,
                    ),
                    child: Column(
                        children: [
                          Text(
                            "toAddFamilyAndFriends".tr(),
                            maxLines: 5,
                            style: TextStyles.textViewRegular13.copyWith(color: white),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await turnOffFirstTime();
                              ShowCaseWidget.of(showCaseContext).next();
                              AppNavigator.pop(context: context);
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
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Wrap(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.listUsers.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.inviteMembers.tr(),
                                  style: TextStylesInter.textViewSemiBold20.copyWith(color: blackSecondary),
                                ),
                                GenericButton(
                                    onPressed: () => AppNavigator.pop(context: context),
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.zero,
                                    width: 36,
                                    color: purple70,
                                    child: Icon(
                                      Icons.close,
                                      color: white,
                                    ))
                              ],
                            ),
                            10.ph,
                            ListView(
                                shrinkWrap: true,
                                children: widget.listUsers.map((userInfo) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (userInfo.id == FirebaseAuth.instance.currentUser?.uid) {
                                        AppNavigator.pop(context: context);
                                        NavigatorController.jumpToTab(2);
                                      } else {
                                        List<ChatList> lists = [];
                                        var friends =
                                        await Provider.of<ChatlistsProvider>(context, listen: false).getAllFriends();

                                        friends.forEach((element) {
                                          if (element.id == userInfo.id) {
                                            element.chatlists.forEach((element) {
                                              lists.add(ChatList(
                                                  id: element.id,
                                                  name: element.get("list_name"),
                                                  storeName: element.get("storeName"),
                                                  userIds: element.get("userIds"),
                                                  totalPrice: element.get("total_price"),
                                                  storeImageUrl: element.get("storeImageUrl"),
                                                  itemLength: element.get("size"),
                                                  lastMessage: element.get("last_message"),
                                                  lastMessageDate: element.get("last_message_date"),
                                                  lastMessageUserId: element.get("last_message_userId"),
                                                  lastMessageUserName: element.get("last_message_userName")));
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
                                            backgroundImage: NetworkImage(
                                              userInfo.imageURL,
                                            ),
                                            radius: 20,
                                          ),
                                          20.pw,
                                          Text(
                                            userInfo.name,
                                            style: TextStylesInter.textViewRegular16.copyWith(color: black2),
                                          ),
                                          Spacer(),
                                          if (widget.listUsers.indexOf(userInfo) == 0)
                                            Text(
                                              "Owner",
                                              style: TextStylesDMSans.textViewBold12.copyWith(color: mainPurple),
                                            ) //The owner is always the 1st one on the list
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()),
                          ],
                          20.ph,
                          InkWell(
                            onTap: () {
                              widget.shareList();
                            },
                            child: Text(LocaleKeys.invitePeopleViaLink.tr(),
                                style: TextStylesInter.textViewRegular12.copyWith(color: brightOrange)),
                          ),
                          30.ph,
                          Text(
                            LocaleKeys.contactsOnBargainB.tr(),
                            style: TextStylesInter.textViewRegular12.copyWith(color: mainPurple),
                          ),
                          15.ph,
                          if (widget.contactsList.isNotEmpty) ...[
                            ListView(
                                shrinkWrap: true,
                                children: widget.contactsList.map((userInfo) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        List<ChatList> lists = [];
                                        var friends =
                                        await Provider.of<ChatlistsProvider>(context, listen: false).getAllFriends();

                                        friends.forEach((element) {
                                          if (element.id == userInfo.id) {
                                            element.chatlists.forEach((element) {
                                              lists.add(ChatList(
                                                  id: element.id,
                                                  name: element.get("list_name"),
                                                  storeName: element.get("storeName"),
                                                  userIds: element.get("userIds"),
                                                  totalPrice: element.get("total_price"),
                                                  storeImageUrl: element.get("storeImageUrl"),
                                                  itemLength: element.get("size"),
                                                  lastMessage: element.get("last_message"),
                                                  lastMessageDate: element.get("last_message_date"),
                                                  lastMessageUserId: element.get("last_message_userId"),
                                                  lastMessageUserName: element.get("last_message_userName")));
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
                                            backgroundImage: NetworkImage(
                                              userInfo.imageURL,
                                            ),
                                            radius: 20,
                                          ),
                                          15.pw,
                                          Text(
                                            userInfo.name,
                                            style: TextStylesInter.textViewRegular14.copyWith(color: black2),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              await widget.addContactToChatlist(userInfo, context);
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(15),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            LocaleKeys.addedToList.tr(),
                                                            style: TextStylesInter.textViewSemiBold28
                                                                .copyWith(color: blackSecondary),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          15.ph,
                                                          Text(LocaleKeys.greatNews.tr(),
                                                              style: TextStylesInter.textViewRegular16
                                                                  .copyWith(color: Color.fromRGBO(72, 72, 74, 1)),
                                                              textAlign: TextAlign.center),
                                                        ],
                                                      ),
                                                    ),
                                                  ));
                                            },
                                            child: Row(children: [
                                              Text(
                                                LocaleKeys.add.tr(),
                                                style: TextStylesInter.textViewSemiBold14.copyWith(color: mainPurple),
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
                                    ),
                                  );
                                }).toList()),
                          ],
                          if (widget.contactsList.isEmpty && !widget.isContactsPermissionGranted)
                            Row(
                              children: [
                                SizedBox(
                                  width: 200.w,
                                  child: Text(
                                    LocaleKeys.addYourPhoneNumber.tr(),
                                    style: TextStylesInter.textViewRegular15.copyWith(color: black),
                                  ),
                                ),
                                Spacer(),
                                GenericButton(
                                    onPressed: () {
                                      AppNavigator.pop(context: context,object: "Phone Added");
                                      pushNewScreen(context, screen: ProfileScreen(isEditing: true, isBackButton: true), withNavBar: true);
                                    },
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.zero,
                                    width: 36,
                                    color: purple70,
                                    child: Icon(
                                      Icons.add,
                                      color: white,
                                    ))
                              ],
                            ),
                          if (widget.contactsList.isEmpty && widget.isContactsPermissionGranted)
                            Text(
                              LocaleKeys.noContactsFound.tr(),
                              style: TextStylesInter.textViewRegular15.copyWith(color: black),
                            ),
                          10.ph,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      }),
    );
  }
}
