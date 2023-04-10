// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:swaav/config/routes/app_navigator.dart';
// import 'package:swaav/generated/locale_keys.g.dart';
// import 'package:swaav/utils/app_colors.dart';
// import 'package:swaav/utils/assets_manager.dart';
// import 'package:swaav/utils/style_utils.dart';
// import 'package:swaav/utils/utils.dart';
// import 'package:swaav/view/components/button.dart';
//
// import 'add_store_items_screen.dart';
//
// class ChooseStoreScreen extends StatefulWidget {
//   const ChooseStoreScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ChooseStoreScreen> createState() => _ChooseStoreScreenState();
// }
//
// class _ChooseStoreScreenState extends State<ChooseStoreScreen> {
//   var stores = [
//     {
//      "name" :"Albert Heinz",
//       "image" : albert,
//       "isComingSoon": false,
//     },{
//      "name" :"Jumbo",
//       "image" : jumbo,
//       "isComingSoon": false,
//     },{
//      "name" :"Spar1",
//       "image" : spar,
//       "isComingSoon": true,
//     },
//   ];
//
//   var selectedStoreIndex;
//   var selectedStoreName = '';
//   var selectedStoreImage = '';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Opacity(
//           opacity: selectedStoreIndex != null ? 1.0 : 0.5,
//           child: GenericButton(
//             width: double.infinity,
//             height: 60.h,
//             onPressed: (){
//               AppNavigator.push(context: context, screen: AddStoreItemsScreen(storeName: selectedStoreName,storeImageURL: selectedStoreImage));
//             },
//             color: verdigris,
//             borderRadius: BorderRadius.circular(6),
//             shadow: [
//               BoxShadow(
//                 offset: Offset(0, 10),
//                 blurRadius: 9,
//                 color: verdigris.withOpacity(0.25)
//               )
//             ],
//             child: Text(LocaleKeys.createListForStore.tr(),style: TextStyles.textViewMedium15,),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 90.h,),
//             Text(LocaleKeys.chooseAStore.tr(),style: TextStyles.textViewSemiBold34.copyWith(color: prussian),),
//             SizedBox(height: 20.h,),
//             Expanded(
//               child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 16 ,
//                 crossAxisSpacing: 10,
//               ),itemCount: stores.length,
//                   itemBuilder: (ctx,i){
//                 var name = stores[i]['name'] as String;
//                 var image = stores[i]['image'] as String;
//                 var isComingSoon = stores[i]['isComingSoon'] as bool;
//                   return Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       InkWell(
//                         onTap: (){
//                           if(!isComingSoon) {
//                             selectedStoreName = name;
//                             selectedStoreImage = image;
//                             setState(() {
//                             selectedStoreIndex = i;
//                           });
//                           }
//                         },
//                         child: Opacity(
//                           opacity: isComingSoon ? 0.6 : 1.0,
//                           child: Ink(
//                             width: 174,
//                             height: 174,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(color: selectedStoreIndex == i ? verdigris : Colors.transparent),
//                               boxShadow: Utils.boxShadow
//                             ),
//                             child: Image.asset(image),
//                           ),
//                         ),
//                       ),
//                       if(isComingSoon)
//                       Text(LocaleKeys.comingSoon.tr(),style: TextStyles.textViewMedium13,),
//                     ],
//                   );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
