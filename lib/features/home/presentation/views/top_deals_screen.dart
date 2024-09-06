// import 'package:bargainb/features/home/presentation/views/widgets/product_item.dart';
// import 'package:bargainb/features/search/presentation/views/widgets/search_appBar.dart';
// import 'package:bargainb/utils/empty_padding.dart';
// import 'package:bargainb/utils/style_utils.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
//
// import '../../../../utils/app_colors.dart';
// import '../../data/models/product.dart';
//
// class TopDealsScreen extends StatefulWidget {
//   const TopDealsScreen({super.key});
//
//   @override
//   State<TopDealsScreen> createState() => _TopDealsScreenState();
// }
//
// class _TopDealsScreenState extends State<TopDealsScreen> {
//   final PagingController<int, Product> _pagingController =
//   PagingController(firstPageKey: 1);
//
//   ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: white,
//         // floatingActionButton: buildFAB(),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//         appBar: SearchAppBar(),
//         // appBar: AppBar(
//         //   title: AlgoliaSearchBar(),
//         //   backgroundColor: Colors.transparent,
//         //   elevation: 0,
//         //   foregroundColor: Colors.black,
//         // ),
//         body: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 50.ph,
//               // AlgoliaSearchBar(),
//               10.ph,
//               Text("Top Deals", style: TextStylesPaytoneOne.textViewRegular24,),
//               10.ph,
//               Expanded(
//                 child: GridView.builder(gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                             maxCrossAxisExtent: 200.w,
//                             mainAxisExtent: 332.h,
//                             childAspectRatio: 0.67,
//                             crossAxisSpacing: 10,
//                             mainAxisSpacing: 10),
//                     itemBuilder: (ctx, item){
//                   // return ProductItem();
//                   return Container();
//                     },
//                 ),
//               )
//               // Expanded(
//               //   child: PagedGridView<int, Product>(
//               //     scrollController: scrollController,
//               //     // shrinkWrap: true,
//               //     gridDelegate:
//               //     SliverGridDelegateWithMaxCrossAxisExtent(
//               //         maxCrossAxisExtent: 200.w,
//               //         mainAxisExtent: 332.h,
//               //         childAspectRatio: 0.67,
//               //         crossAxisSpacing: 10,
//               //         mainAxisSpacing: 10),
//               //     pagingController: _pagingController,
//               //     showNewPageProgressIndicatorAsGridChild: false,
//               //     builderDelegate: PagedChildBuilderDelegate(
//               //         itemBuilder: ((context, item, index) {
//               //           // int nextPageKey = pageKey + 1;
//               //           _pagingController.appendPage([], 2);
//               //           return ProductItem();
//               //         })),
//               //   ),
//               // ),
//             ],
//           ),
//         ));
//   }
// }
