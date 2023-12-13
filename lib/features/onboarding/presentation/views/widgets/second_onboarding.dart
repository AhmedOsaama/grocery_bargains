import 'package:bargainb/core/utils/bot_service.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/widgets/message_bubble.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';

class SecondOnboarding extends StatefulWidget {
  const SecondOnboarding({Key? key}) : super(key: key);

  @override
  State<SecondOnboarding> createState() => _SecondOnboardingState();
}

class _SecondOnboardingState extends State<SecondOnboarding> {
  String _selectedStore = "None";

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
    TrackingUtils().trackPageView("Guest", DateTime.now().toUtc().toString(), "Second onboarding screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              onTap: () {
                setState(() {
                  _selectedStore = entry.key;
                });
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
        _selectedStore == "None" ? Image.asset(onboarding2) : FutureBuilder(
          future: BotService(Dio()).post(message: '@BB show me the top deals from $_selectedStore'),
          builder: (context, snapshot) {
            // if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
            var loading = snapshot.connectionState == ConnectionState.waiting;
            Map botResponse = snapshot.data ?? {};
            var message = loading ? "" : (botResponse.containsKey('text') ? botResponse['text'] : "");
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: loading ? 100.h : 70.h,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 500),
                          top: loading ? 50 : 0,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: loading ? 0 : 1,
                            child: SimpleMessageBubble(message: '@BB show me the top deals from $_selectedStore', isBot: false,),
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.ph,
                  Container(
                    height: loading ? 300.h : 280.h,
                    child: Stack(
                      alignment: Alignment.centerRight,
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


                  // Text('@BB show me the top deals from $_selectedStore', style: TextStylesInter.textViewRegular14,),
                ],
              ),
            );
          }
        )
      ],
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
            style: TextStyles.textViewRegular15.copyWith(color: isBot ? Color(0xFF868889) : Colors.white ),
            softWrap: true,
            textAlign: isBot ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }
}