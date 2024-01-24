import 'package:audioplayers/audioplayers.dart';
import 'package:bargainb/core/utils/bot_service.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/providers/user_provider.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/utils/sounds_manager.dart';
import 'package:bargainb/view/widgets/message_bubble.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';

class SecondOnboarding extends StatefulWidget {
  final Function disableFAB;
  final Function showFAB;
  const SecondOnboarding({Key? key, required this.disableFAB, required this.showFAB}) : super(key: key);

  @override
  State<SecondOnboarding> createState() => _SecondOnboardingState();
}

class _SecondOnboardingState extends State<SecondOnboarding> {
  String _selectedStore = "None";
  late Future botFuture;
  late Future userMessageFuture;
  final player = AudioPlayer();


  final Map stores = {
    "Albert Heijn": albert,
    "Jumbo": jumbo,
    "Dirk": dirkLogo,
    "Hoogvliet": hoogLogo,
    "Spar": spar_store,
    "Coop": coop_store,
    "Lidl": lidle_store,
    "Aldi": aldi,
  };

  @override
  void initState() {
    widget.disableFAB();
    userMessageFuture = Future.delayed(Duration(milliseconds: 500));
    TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "Second onboarding screen");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print(context.locale.languageCode);
    // botFuture = BotService(Dio()).post(message: context.locale.languageCode == "en" ? '@BB show me the top deals from $_selectedStore'
    // : "@BB laat me de beste deals van $_selectedStore zien");
    super.didChangeDependencies();
  }


  Future<void> playSound() async {
    await player.play(AssetSource(messageSound));
    // player.stop();
  }

  @override
  Widget build(BuildContext context) {
    var botMessage = context.locale.languageCode == "en" ? '@BB show me the top deals from $_selectedStore'
    : "@BB laat me de beste deals van $_selectedStore zien";
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Text(
            "Let’s show you".tr(),
            style: TextStylesInter.textViewBold26,
          ),
          10.ph,
          Text(
            "What’s your preferred grocery store?".tr(),
            style: TextStylesInter.textViewSemiBold16,
          ),
          10.ph,
          AnimatedOpacity(
            opacity: 1,
            duration: Duration(seconds: 1),
            child: Text(
              "Choose one".tr(),
              style: TextStylesInter.textViewLight15,
            ),
          ),
          40.ph,
          Container(
            width: 324.w,
            height: 130.h,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: stores.entries
                  .map((entry) => GestureDetector(
                onTap: () async {
                  setState(() {
                    _selectedStore = entry.key;
                  botFuture = BotService(Dio()).post(message: botMessage);
                  });
                  Provider.of<UserProvider>(context, listen: false).setOnboardingStore(_selectedStore);
                  botFuture.whenComplete(() => playSound());
                  userMessageFuture.whenComplete(() => playSound());
                  TrackingUtils().trackFavouriteStores("Guest", DateTime.now().toUtc().toString(), "Second onboarding screen", _selectedStore);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: _selectedStore == entry.key ? Border.all(color: Color(0xFF3463ED)) : null,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 15,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ]),
                  child: Image.asset(
                    entry.value,
                    width: 28,
                    height: 28,
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
          50.ph,
          if(_selectedStore != "None")
            FutureBuilder(
              future: userMessageFuture,
              builder: (context, snapshot) {
                var loading = snapshot.connectionState == ConnectionState.waiting;
                return Container(
                  height: loading ? 0.h : 70.h,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        top: loading ? 50 : 0,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: loading ? 0 : 1,
                          child: SimpleMessageBubble(message: botMessage, isBot: false,),
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),

          _selectedStore == "None" ? Image.asset(onboarding2) : FutureBuilder(
              future: botFuture,
              builder: (context, snapshot) {
                var loading = snapshot.connectionState == ConnectionState.waiting;
                Map botResponse = snapshot.data ?? {};
                var message = loading ? "" : (botResponse.containsKey('text') ? botResponse['text'] : "");
                if(loading) return Column(
                  children: [
                    50.ph,
                    Image.asset(loadingIndicator, width: 50,),
                  ],
                    );
                if(!loading)
                  Future.delayed(Duration(seconds: 2), (){
                  widget.showFAB();
                });
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      20.ph,
                      Container(
                        height: loading ? 200.h : 1500.h,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              top: loading ? 50 : 0,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: loading ? 0 : 1,
                                child: SimpleMessageBubble(message: message, isBot: true,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
          )
        ],
      ),
    );
  }
}

class SimpleMessageBubble extends StatelessWidget {
  const SimpleMessageBubble({
    super.key, required this.message, required this.isBot,
  });

  final String message;
  final bool isBot;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if(isBot && message.isNotEmpty) Image.asset(bee1, width: 30, height: 30,),
        Container(
          width: message.length > 30 ? MediaQuery.of(context).size.width * 0.6 : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: const Radius.circular(18),
              topLeft: const Radius.circular(18),
              bottomLeft: Radius.circular( isBot ? 0 : 18) ,
              bottomRight: Radius.circular(isBot ? 18 : 0),
            ),
            color: isBot ? Colors.white : mainPurple,
            boxShadow: [
              BoxShadow(
                color: Color(0x263463ED),
                blurRadius: 28,
                offset: Offset(0, 10),
                spreadRadius: 0,
              )
            ]
          ),
          child: Text(
            message,
            style: TextStyles.textViewRegular16.copyWith(color: isBot ? Color(0xFF868889) : Colors.white ),
            softWrap: true,
            // textAlign: isBot ? TextAlign.right : TextAlign.left,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}