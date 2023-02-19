import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/fonts_utils.dart';
import 'package:swaav/view/components/generic_appbar.dart';
import 'package:swaav/view/components/my_scaffold.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/screens/category_items_screen.dart';
import 'package:swaav/view/screens/chat_view_screen.dart';

import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';

class ListViewScreen extends StatefulWidget {
  final String listId;
  final String listName;
  final String? storeName;
  final String? storeImage;
  final bool isUsingDynamicLink;
  final Function? updateList;
  const ListViewScreen({Key? key,required this.listId, required this.listName, this.isUsingDynamicLink = false, this.storeName, this.storeImage, this.updateList}) : super(key: key);

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  bool isDeleting = false;

  @override
  void initState() {
    if(widget.isUsingDynamicLink){
      var currentUserId = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore.instance.collection('/lists').doc(widget.listId).get().then((listSnapshot) {
        final List userIds = listSnapshot.data()!['userIds'];
        if(!userIds.contains(currentUserId)){
          userIds.add(currentUserId);
          FirebaseFirestore.instance.collection('/lists').doc(widget.listId).update(
              {
                "userIds": userIds
              }
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User added successfully to list ${widget.listName}")));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Already Exists in the list")));
        }
      });
    }
    super.initState();
  }

  String getTotalListPrice(List items){
    var total = 0.0;
    for (var item in items) {
      total += item['item_price'] ?? 99999;
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('/lists/${widget.listId}/items').where('message',isEqualTo: '')
              .get(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
            var items = snapshot.data?.docs ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h,),
                BackButton(),
                Row(
                  children: [
                    widget.storeImage != null ? Image.asset(widget.storeImage!) : Container(),
                    SizedBox(width: 10.w,),
                    widget.storeName != null ? Text(widget.storeName!,style: TextStyles.textViewMedium16.copyWith(color: prussian),) : Container(),
                    SizedBox(width: 10.w,),
                    // widget.storeImage != null ? Image.asset(widget.storeImage!) : Container(),
                    Spacer(),
                    SvgPicture.asset(peopleIcon),
                    IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
                  ],
                ),
                Text(widget.listName,style: TextStyles.textViewSemiBold30.copyWith(color: prussian),),
                Divider(height: 10.h,),
                Row(
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.share_outlined)),
                    IconButton(onPressed: (){}, icon: Icon(Icons.store_outlined)),
                    IconButton(onPressed: () => AppNavigator.push(context: context, screen: ChatViewScreen(listName: widget.listName, listId: widget.listId)), icon: Icon(Icons.message_outlined)),
                    Spacer(),
                    Text("${items.length} items",style: TextStyles.textViewMedium10.copyWith(color: Color.fromRGBO(204, 204, 203, 1)),),
                    SizedBox(width: 10.w,),
                    Text(LocaleKeys.total.tr(),style: TextStyles.textViewMedium15.copyWith(color: prussian),),
                    SizedBox(width: 10.w,),
                    Text("€ ${getTotalListPrice(items)}",
                        style: TextStyles.textViewSemiBold18.copyWith(color: prussian)),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                      separatorBuilder: (ctx,_) => const Divider(),
                      itemBuilder: (ctx,i) {
                      var isChecked = items[i]['item_isChecked'];
                      var itemName = items[i]['item_name'];
                      var itemPrice = items[i]['item_price'];
                      var doc = items[i];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Opacity(
                              opacity: isChecked ? 0.6 : 1,
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        isChecked = !isChecked;
                                      });
                                      FirebaseFirestore.instance.collection("/lists/${doc.reference.parent.parent?.id}/items").doc(doc.id).update({
                                        "item_isChecked": isChecked,
                                      }).catchError((e) {
                                        print(e);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This operation couldn't be done please try again")));
                                      });
                                      widget.updateList != null ? widget.updateList!() : (){};
                                    },
                                  ),
                                  Image.asset(milk,width: 55,height: 55,),
                                  SizedBox(width: 12.w,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(itemName,style: TextStyles.textViewSemiBold14.copyWith(color: prussian,decoration: isChecked ? TextDecoration.lineThrough : null) ,),
                                      Text("0,331",style: TextStyles.textViewLight12.copyWith(color: prussian,decoration: isChecked ? TextDecoration.lineThrough : null),),
                                    ],
                                  ),
                                  Spacer(),
                                  Text("€ $itemPrice",style: TextStyles.textViewMedium13.copyWith(color: prussian,decoration: isChecked ? TextDecoration.lineThrough : null,),),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w,),
                          IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert)),
                        ],
                      );
                      }),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
