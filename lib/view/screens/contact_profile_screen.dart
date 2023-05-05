import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/providers/google_sign_in_provider.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/models/userinfo.dart' as UserInfo;

class ContactProfileScreen extends StatefulWidget {
  ContactProfileScreen({Key? key, required this.user, required this.lists})
      : super(key: key);
  UserInfo.UserInfo user;
  List<ChatList> lists;
  @override
  State<ContactProfileScreen> createState() => _ContactProfileScreenState();
}

class _ContactProfileScreenState extends State<ContactProfileScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  @override
  void initState() {
    updateUserDataFuture();
    super.initState();
  }

  String brandDropdownValue = '';
  void updateUserDataFuture() {
    getUserDataFuture = FirebaseFirestore.instance
        .collection('/users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GoogleSignInProvider>(builder: (ctx, provider, _) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.2,
          backgroundColor: Colors.white,
          title: Text(
            LocaleKeys.profile.tr(),
            style: TextStyles.textViewSemiBold16.copyWith(color: black1),
          ),
          actions: [
            Center(
              child: PopupMenuButton(
                  color: white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Text(
                    LocaleKeys.edit.tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                        color: mainPurple),
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text(
                            "List removal",
                            style: TextStyles.textViewSemiBold12
                                .copyWith(color: black2),
                          ),
                        ),
                        PopupMenuItem(
                          height: 0.h,
                          enabled: false,
                          child: Divider(
                            color: grey,
                            thickness: 2,
                          ),
                        ),
                        PopupMenuItem(
                          child: Text(
                            "Delete",
                            style: TextStyles.textViewSemiBold12
                                .copyWith(color: black2),
                          ),
                        ),
                      ]),
            ),
            15.pw
          ],
          leading: IconButton(
              onPressed: () {
                AppNavigator.pop(context: context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: mainPurple,
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: FutureBuilder(
                  future: getUserDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (ScreenUtil().screenHeight / 3).round().toInt().ph,
                          CircularProgressIndicator(),
                        ],
                      ));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        24.ph,
                        Center(
                          child: Column(
                            children: [
                              widget.user.imageURL.isEmpty
                                  ? SvgPicture.asset(
                                      peopleIcon,
                                      width: 120.w,
                                      height: 120.h,
                                    )
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        widget.user.imageURL,
                                      ),
                                      radius: 60.r,
                                    ),
                              10.ph,
                              Text(
                                widget.user.name,
                                style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              4.ph,
                              Text(
                                widget.user.phoneNumber,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        30.ph,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'GENERAL CHATS',
                            style: TextStylesInter.textViewRegular12
                                .copyWith(color: mainPurple),
                          ),
                        ),
                        15.ph,
                        widget.lists.isEmpty
                            ? Text(
                                'No chatlists found :(',
                                style: TextStylesInter.textViewRegular12
                                    .copyWith(color: black),
                              )
                            : ListView.separated(
                                itemCount: widget.lists.length,
                                separatorBuilder: (context, index) => Divider(
                                  color: grey,
                                  thickness: 2,
                                ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      AppNavigator.push(
                                          context: context,
                                          screen: ChatListViewScreen(
                                            listId:
                                                widget.lists.elementAt(i).id,
                                          ));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              widget.lists
                                                  .elementAt(i)
                                                  .storeImageUrl,
                                              height: 52.h,
                                              width: 52.w,
                                            ),
                                            15.pw,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.lists
                                                      .elementAt(i)
                                                      .name,
                                                  style: TextStyles
                                                      .textViewSemiBold16
                                                      .copyWith(color: black2),
                                                ),
                                                RichText(
                                                    text: TextSpan(
                                                        text:
                                                            "${widget.lists.elementAt(i).itemLength} items",
                                                        style: TextStyles
                                                            .textViewRegular10
                                                            .copyWith(
                                                                color:
                                                                    purple50),
                                                        children: [
                                                      TextSpan(
                                                          text:
                                                              "  €${widget.lists.elementAt(i).totalPrice}",
                                                          style: TextStyles
                                                              .textViewRegular10
                                                              .copyWith(
                                                                  color:
                                                                      black2))
                                                    ])),
                                                widget.lists
                                                        .elementAt(i)
                                                        .lastMessage
                                                        .isNotEmpty
                                                    ? Text(
                                                        "${widget.lists.elementAt(i).lastMessageUserId == FirebaseAuth.instance.currentUser?.uid ? LocaleKeys.you.tr() : widget.lists.elementAt(i).lastMessageUserName} : ${widget.lists.elementAt(i).lastMessage}")
                                                    : Text("")
                                              ],
                                            )
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: mainPurple,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                        10.ph,
                      ],
                    );
                  }),
            ),
          ),
        ),
      );
    });
  }
}
