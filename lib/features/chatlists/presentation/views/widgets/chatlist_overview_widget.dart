import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/utils.dart';

class ChatlistOverviewWidget extends StatelessWidget {
   ChatlistOverviewWidget({Key? key, required this.items, required this.isFirstTimeChatlist}) : super(key: key);

   List items = [];
   bool isFirstTimeChatlist = false;

   String getTotalListPrice(List items) {
     var total = 0.0;
     for (var item in items) {
       try {
         total += (item['item_price'].runtimeType == String
             ? double.parse(item['item_price'])
             : item['item_price'] ?? 99999) *
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
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
                    text: isFirstTimeChatlist
                        ? "9 items"
                        : " ${items.length} ${LocaleKeys.items.tr()}",
                    style:
                    TextStylesInter.textViewBold12.copyWith(color: blackSecondary))
              ])),
          15.pw,
          Text.rich(TextSpan(
              text: "${LocaleKeys.total.tr()} ",
              style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
              children: [
                TextSpan(
                    text: isFirstTimeChatlist
                        ? "€17.32"
                        : " €${getTotalListPrice(items)}",
                    style: TextStylesInter.textViewBold12.copyWith(color: mainPurple))
              ])),
          15.pw,
          Text.rich(TextSpan(
              text: "${LocaleKeys.savings.tr()} ",
              style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
              children: [
                TextSpan(
                    text: isFirstTimeChatlist
                        ? "€4.32"
                        : " €${getTotalListSavings(items)}",
                    style:
                    TextStylesInter.textViewBold12.copyWith(color: greenSecondary))
              ])),
          // Spacer(),
          // IconButton(
          //     onPressed: () {
          //       setState(() {
          //         isExpandingChatlist = !isExpandingChatlist;
          //       });
          //       TrackingUtils().trackButtonClick(
          //           FirebaseAuth.instance.currentUser!.uid,
          //           "Expand chatlist",
          //           DateTime.now().toUtc().toString(),
          //           "Chatlist screen");
          //     },
          //     icon: isExpandingChatlist
          //         ? Icon(
          //       Icons.keyboard_arrow_up,
          //       color: mainPurple,
          //       size: 45.sp,
          //     )
          //         : Icon(
          //       Icons.keyboard_arrow_down,
          //       color: mainPurple,
          //       size: 45.sp,
          //     )),
        ],
      ),
    );
  }
}
