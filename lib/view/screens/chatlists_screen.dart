import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/view/components/chats_search_delegate.dart';
import 'package:bargainb/view/components/search_appBar.dart';
import 'package:bargainb/view/screens/chatlist_view_screen.dart';
import 'package:bargainb/view/screens/contact_profile_screen.dart';
import 'package:bargainb/models/user_info.dart' as UserInfo;
import 'package:bargainb/view/screens/register_screen.dart';
import 'package:bargainb/view/widgets/chat_card.dart';
import 'package:bargainb/view/widgets/create_list_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/components/dotted_container.dart';

import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:bargainb/view/widgets/store_list_widget.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/tracking_utils.dart';
import '../components/generic_field.dart';


class ChatlistsScreen extends StatefulWidget {
  const ChatlistsScreen({Key? key}) : super(key: key);

  @override
  State<ChatlistsScreen> createState() => _ChatlistsScreenState();
}

class _ChatlistsScreenState extends State<ChatlistsScreen> {
  late Future<QuerySnapshot> getListItemsFuture;
  var isFabPressed = false;
  bool isAdding = false;

  bool canCreate = false;

  @override
  void initState() {
    TrackingUtils().trackPageVisited("All chatlists screen", FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var chatlistsProvider = context.watch<ChatlistsProvider>();
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 247, 254, 1),
      appBar: SearchAppBar(isBackButton: false,),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            chatlistsProvider.notifyListeners();
            return Future.value();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  LocaleKeys.myChatlists.tr(),
                  style: TextStylesInter.textViewSemiBold26.copyWith(color: blackSecondary),
                ),
              ),
              Expanded(
                child: Consumer<ChatlistsProvider>(builder: (context, provider, _) {
                  var allLists = provider.chatlists;
                  // List<ChatList> allLists = [];
                  if (FirebaseAuth.instance.currentUser == null) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          chatlistBackground,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            50.ph,
                            DottedContainer(text: "Sign In to Use Chatlists"),
                            SizedBox(
                              height: 100.h,
                            ),
                            GenericButton(
                              borderRadius: BorderRadius.circular(6),
                              color: mainYellow,
                              height: 60.h,
                              width: 158.w,
                              onPressed: () => pushNewScreen(context, screen: RegisterScreen(), withNavBar: false),
                              child: Text(
                                "Sign in",
                                style: TextStyles.textViewSemiBold16.copyWith(color: white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  if (allLists.isEmpty) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          chatlistBackground,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            50.ph,
                            DottedContainer(text: LocaleKeys.createYourFirstList.tr()),
                            SizedBox(
                              height: 45.h,
                            ),
                            getFab(),
                          ],
                        ),
                      ],
                    );
                  }
                  return Stack(
                    children: [
                      Image.asset(
                        chatlistBackground,
                        height: double.infinity,
                        fit: BoxFit.fitHeight,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: ListView.separated(
                          separatorBuilder: (ctx, i) => 10.ph,
                          itemCount: allLists.length,
                          itemBuilder: (ctx, i) {
                            return Column(
                              children: [
                                GestureDetector(
                                    // onTap: () => pushNewScreen(context,
                                    //     screen: ChatListViewScreen(
                                    //       listId: allLists[i].id,
                                    //     ),
                                    //     withNavBar: true
                                    // ),
                                    child: ChatCard(allLists, i)),
                                if (i == allLists.length - 1) ...[
                                  30.ph,
                                  getFab(),
                                  15.ph,
                                ]
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getFab() {
    return GenericButton(
      width: 60,
      height: 60,
      onPressed: () async {
        showDialog(
            context: context,
            builder: (ctx) => CreateListDialog());
      },
      color: yellow,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(20),
      child: const Icon(
        Icons.add,
        color: Colors.black,
        size: 50,
      ),
    );
  }
}

class FriendChatLists {
  String name;
  String imageURL;
  String email;
  String id;
  String phone;
  List<QueryDocumentSnapshot> chatlists;

  FriendChatLists(
      {required this.imageURL,
      required this.name,
      required this.id,
      required this.phone,
      required this.chatlists,
      required this.email});
}
