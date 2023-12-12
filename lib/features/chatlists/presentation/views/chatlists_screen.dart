import 'package:bargainb/features/chatlists/presentation/views/widgets/sign_in_widget.dart';
import 'package:bargainb/models/chatlist.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/view/screens/register_screen.dart';
import 'package:bargainb/view/widgets/chat_card.dart';
import 'package:bargainb/view/widgets/create_list_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/button.dart';
import 'package:bargainb/view/components/dotted_container.dart';

import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';

import '../../../../utils/tracking_utils.dart';
import '../../../../view/components/search_widget.dart';
import '../../../onboarding/presentation/views/widgets/onboarding_stepper.dart';

class ChatlistsScreen extends StatefulWidget {
  const ChatlistsScreen({Key? key}) : super(key: key);

  @override
  State<ChatlistsScreen> createState() => _ChatlistsScreenState();
}

class _ChatlistsScreenState extends State<ChatlistsScreen> {
  @override
  void initState() {
    super.initState();
    trackPageView();
  }

  @override
  Widget build(BuildContext context) {
    var chatlistsProvider = Provider.of<ChatlistsProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            chatlistsProvider.notifyListeners();
            return Future.value();
          },
          child: Container(
            width: double.infinity,
            color: Color(0xFFEBEFFD),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(
                        LocaleKeys.myChatlists.tr(),
                        textAlign: TextAlign.start,
                        style: TextStylesInter.textViewBold26.copyWith(color: blackSecondary),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Consumer<ChatlistsProvider>(builder: (context, provider, _) {
                    var allLists = provider.chatlists;
                    if (allLists.isEmpty) {
                      return buildStack();
                    }
                    return buildAllChatlists(allLists);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void trackPageView() {
    try {
      TrackingUtils().trackPageView(
          FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "All chatlists screen");
    } catch (e) {}
  }

  Widget buildAllChatlists(List<ChatList> allLists) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: ListView.separated(
        separatorBuilder: (ctx, i) => 10.ph,
        itemCount: allLists.length,
        itemBuilder: (ctx, i) {
          return Column(
            children: [
              GestureDetector(child: ChatCard(allLists, i)),
              if (i == allLists.length - 1) ...[
                30.ph,
                getFab(),
                15.ph,
              ]
            ],
          );
        },
      ),
    );
  }

  Widget buildStack() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        50.ph,
        DottedContainer(text: LocaleKeys.createYourFirstList.tr()),
        SizedBox(
          height: 45.h,
        ),
        getFab(),
      ],
    );
  }

  Widget getFab() {
    return GenericButton(
      width: 60,
      height: 60,
      onPressed: () async {
        showDialog(context: context, builder: (ctx) => CreateListDialog());
        TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Create Chatlist",
            DateTime.now().toUtc().toString(), "Chatlist screen");
      },
      color: mainOrange,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(20),
      child: const Icon(
        Icons.add,
        color: Colors.white,
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
