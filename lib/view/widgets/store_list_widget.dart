import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:bargainb/utils/app_colors.dart';

import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../../utils/utils.dart';

class StoreListWidget extends StatefulWidget {
  final String listName;
  final String listId;
  final String storeImagePath;
  // final List<QueryDocumentSnapshot> storeItems;
  final String? userImages;
  StoreListWidget(
      {Key? key,
      required this.listName,
      required this.storeImagePath,
      // required this.storeItems,
        this.userImages, required this.listId})
      : super(key: key);

  @override
  State<StoreListWidget> createState() => _StoreListWidgetState();
}

class _StoreListWidgetState extends State<StoreListWidget> {
  String getTotalListPrice(List storeItems){
    var total = 0.0;
    for (var item in storeItems) {
      if(item.data().containsKey('item_price') && item['item_price'].runtimeType == String) {
        total += double.parse(item['item_price']);
      } else if(item.data().containsKey('item_price') && item['item_price'].runtimeType == double) {
        total += item['item_price'] ?? 0;
      }else{
        total += 0;
      }
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: Color.fromRGBO(222, 222, 222, 1), width: 0.5),
          boxShadow: Utils.boxShadow),
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('/lists/${widget.listId}/items')
            .get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Center(child: CircularProgressIndicator(),);
          var storeItems = snapshot.data?.docs ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.userImages != null ? SvgPicture.asset(widget.userImages!) : Container(),
                  Image.asset(
                    widget.storeImagePath,
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
              Text(
                widget.listName,
                style: TextStylesDMSans.textViewSemiBold14
                    .copyWith(color: const Color.fromRGBO(37, 37, 37, 1)),
                overflow: TextOverflow.ellipsis,
              ),
              ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: storeItems.length > 4 ? 4 : storeItems.length,
                      itemBuilder: (ctx, i) {
                        var isChecked = storeItems[i]['item_isChecked'];
                        var itemName = storeItems[i].data().toString().contains('item_name') ? storeItems[i]['item_name'] : storeItems[i]['text'];
                        var itemPrice = storeItems[i].data().toString().contains('item_price') ? storeItems[i]['item_price'] : "0.0";
                        var doc = storeItems[i];
                        if (i > 2) return const Text("...");
                        return Row(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    FirebaseFirestore.instance.collection("/lists/${doc.reference.parent.parent?.id}/items").doc(doc.id).update({
                                      "item_isChecked": !isChecked,
                                    }).catchError((e) {
                                      print(e);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("This operation couldn't be done please try again")));
                                    });
                                    isChecked = !isChecked;
                                  });
                                },
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            SizedBox(
                              width: 70.w,
                              child: Text(
                                itemName,
                                style:
                                    TextStyles.textViewLight10.copyWith(color: prussian),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "€ $itemPrice",
                              style:
                                  TextStyles.textViewLight12.copyWith(color: prussian),
                            ),
                          ],
                        );
                      }),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.total.tr(),
                    style: TextStyles.textViewMedium10.copyWith(color: prussian),
                  ),
                  Text("€ ${getTotalListPrice(storeItems)}",
                      style: TextStyles.textViewMedium10.copyWith(color: prussian)),
                ],
              )
            ],
          );
        }
      ),
    );
  }
}
