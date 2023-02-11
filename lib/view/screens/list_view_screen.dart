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
  final List<Map> items;
  final String? storeName;
  final String? storeImage;
  final bool isUsingDynamicLink;
  const ListViewScreen({Key? key,required this.listId, required this.listName, this.isUsingDynamicLink = false, this.storeName, this.storeImage, required this.items}) : super(key: key);

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

  String getTotalListPrice(){
    var total = 0.0;
    for (var item in widget.items) {
      total += double.tryParse(item['itemPrice']) ?? 99999;
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100.h,),
            BackButton(),
            Row(
              children: [
                Image.asset(brand),
                SizedBox(width: 10.w,),
                widget.storeName != null ? Text(widget.storeName!,style: TextStyles.textViewMedium16.copyWith(color: prussian),) : Container(),
                widget.storeImage != null ? Image.asset(widget.storeImage!) : Container(),
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
                IconButton(onPressed: (){}, icon: Icon(Icons.message_outlined)),
                Spacer(),
                Text("${widget.items.length} items",style: TextStyles.textViewMedium10.copyWith(color: Color.fromRGBO(204, 204, 203, 1)),),
                SizedBox(width: 10.w,),
                Text(LocaleKeys.total.tr(),style: TextStyles.textViewMedium15.copyWith(color: prussian),),
                SizedBox(width: 10.w,),
                Text("€ ${getTotalListPrice()}",
                    style: TextStyles.textViewSemiBold18.copyWith(color: prussian)),              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: widget.items.length,
                  separatorBuilder: (ctx,_) => const Divider(),
                  itemBuilder: (ctx,i) {
                  var isChecked = widget.items[i]['isChecked'];
                  var itemName = widget.items[i]['itemName'];
                  var itemPrice = widget.items[i]['itemPrice'];
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
                                    widget.items[i]['isChecked'] = !isChecked;
                                  });
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
        ),
      ),
    );
  }
}
