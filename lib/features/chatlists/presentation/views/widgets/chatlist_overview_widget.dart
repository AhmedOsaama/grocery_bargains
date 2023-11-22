import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../../utils/utils.dart';

class ChatlistOverviewWidget extends StatefulWidget {
  ChatlistOverviewWidget(
      {Key? key,required this.pageNumber, required this.items, required this.isFirstTimeChatlist, required this.pageController})
      : super(key: key);

  List items = [];
  bool isFirstTimeChatlist = false;
  late PageController pageController;
  int pageNumber;

  @override
  State<ChatlistOverviewWidget> createState() => _ChatlistOverviewWidgetState();
}

class _ChatlistOverviewWidgetState extends State<ChatlistOverviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF979797)),
        color: Colors.white,
        boxShadow: Utils.boxShadow,
      ),
      child: Row(
        children: [
          Text.rich(TextSpan(
              text: "${LocaleKeys.chatlist.tr()} ",
              style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
              children: [
                TextSpan(
                    text: widget.isFirstTimeChatlist ? "9 items" : " ${widget.items.length} ${LocaleKeys.items.tr()}",
                    style: TextStylesInter.textViewBold12.copyWith(color: blackSecondary))
              ])),
          15.pw,
          Text.rich(TextSpan(
              text: "${LocaleKeys.total.tr()} ",
              style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
              children: [
                TextSpan(
                    text: widget.isFirstTimeChatlist ? "€17.32" : " €${getTotalListPrice(widget.items)}",
                    style: TextStylesInter.textViewBold12.copyWith(color: mainPurple))
              ])),
          15.pw,
          Text.rich(TextSpan(
              text: "${LocaleKeys.savings.tr()} ",
              style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
              children: [
                TextSpan(
                    text: widget.isFirstTimeChatlist ? "€4.32" : " €${getTotalListSavings(widget.items)}",
                    style: TextStylesInter.textViewBold12.copyWith(color: greenSecondary))
              ])),
          Spacer(),
          IconButton(
              onPressed: switchChatView,
              icon: widget.pageNumber == 0
                  ? Icon(
                      Icons.notes,
                      color: mainPurple,
                      // size: 45.sp,
                    )
                  : Icon(
                      Icons.chat_outlined,
                      color: mainPurple,
                      // size: 45.sp,
                    )),
        ],
      ),
    );
  }

  void switchChatView() {
              setState(() {
                widget.pageNumber == 0
                    ? widget.pageController
                        .animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut)
                    : widget.pageController
                        .animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
              });
              TrackingUtils().trackButtonClick(FirebaseAuth.instance.currentUser!.uid, "Switch chatlist View",
                  DateTime.now().toUtc().toString(), "Chatlist screen");
            }
}

String getTotalListPrice(List items) {
  var total = 0.0;
  for (var item in items) {
    try {
      total +=
          (item['item_price'].runtimeType == String ? double.parse(item['item_price']) : item['item_price'] ?? 99999) *
              item['item_quantity'];
    } catch (e) {
      total += 0.0;
    }
  }
  return total.toStringAsFixed(2);
}

String getTotalListSavings(List items) {
  var total = 0.0;
  for (var item in items) {
    try {
      total += (item['item_oldPrice'].runtimeType == String
              ? (double.parse(item['item_oldPrice']) - double.parse(item['item_price']))
              : (item['item_oldPrice'] - item['item_price'])) *
          item['item_quantity'];
    } catch (e) {
      total += 0.0;
    }
  }
  return total.toStringAsFixed(2);
}
