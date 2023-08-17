// import 'package:bargainb/view/screens/profile_screen.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
//
// import '../../generated/locale_keys.g.dart';
// import '../../utils/app_colors.dart';
// import '../../utils/assets_manager.dart';
// import '../../utils/style_utils.dart';
// import '../screens/chatlist_view_screen.dart';
//
// class ChatTile extends StatelessWidget {
//   final Function updateList;
//   final String listId;
//   final String listName;
//   final String size;
//   final String totalPrice;
//   final String lastMessageUserId;
//   final String lastMessageUserName;
//   final String lastMessage;
//   const ChatTile(
//       {Key? key,
//       required this.updateList,
//       required this.listId,
//       required this.listName,
//       required this.size,
//       required this.totalPrice,
//       required this.lastMessageUserId,
//       required this.lastMessageUserName,
//       required this.lastMessage})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => pushNewScreen(context,
//           screen: ChatListViewScreen(
//             // updateList: updateList,
//             listId: listId,
//           ),
//           withNavBar: false),
//       child: Row(
//         children: [
//           Image.asset(
//             storePlaceholder,
//             width: 45,
//             height: 45,
//           ),
//           18.pw,
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 listName,
//                 style:
//                     TextStylesInter.textViewSemiBold16.copyWith(color: black2),
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "${size} ${LocaleKeys.items.tr()}",
//                     style: TextStylesInter.textViewMedium10
//                         .copyWith(color: purple50),
//                   ),
//                   5.pw,
//                   Text(
//                     "€${totalPrice}",
//                     style: TextStylesInter.textViewMedium10
//                         .copyWith(color: black2),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     '${lastMessageUserId == FirebaseAuth.instance.currentUser?.uid ? LocaleKeys.you.tr() : lastMessageUserName}: ',
//                     style: TextStylesInter.textViewRegular14
//                         .copyWith(color: black2),
//                   ),
//                   Container(
//                     width: 150.w,
//                     child: Text(
//                       lastMessage,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStylesInter.textViewRegular14
//                           .copyWith(color: black2),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Spacer(),
//         ],
//       ),
//     );
//   }
// }
