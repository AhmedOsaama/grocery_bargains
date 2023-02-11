import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swaav/generated/locale_keys.g.dart';
import 'package:swaav/utils/app_colors.dart';

import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';
import '../../utils/utils.dart';

class StoreList extends StatefulWidget {
  final String listName;
  final String storeImagePath;
  final List<Map> storeItems;
  final String? userImages;
  const StoreList(
      {Key? key,
      required this.listName,
      required this.storeImagePath,
      required this.storeItems, this.userImages})
      : super(key: key);

  @override
  State<StoreList> createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  String getTotalListPrice(){
    var total = 0.0;
    for (var item in widget.storeItems) {
      total += double.tryParse(item['itemPrice']) ?? 99999;
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: Color.fromRGBO(222, 222, 222, 1), width: 0.5),
          boxShadow: Utils.boxShadow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                widget.storeImagePath,
                width: 30,
                height: 30,
              ),
              widget.userImages != null ? SvgPicture.asset(widget.userImages!) : Container(),
            ],
          ),
          Text(
            widget.listName,
            style: TextStylesDMSans.textViewSemiBold14
                .copyWith(color: const Color.fromRGBO(37, 37, 37, 1)),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 10.h,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.storeItems.length > 4 ? 4 : widget.storeItems.length,
              itemBuilder: (ctx, i) {
                var isChecked = widget.storeItems[i]['isChecked'];
                var itemName = widget.storeItems[i]['itemName'];
                var itemPrice = widget.storeItems[i]['itemPrice'];
                if (i > 2) return const Text("...");
                return Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          widget.storeItems[i]['isChecked'] = !isChecked;
                        });
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    SizedBox(
                      width: 70.w,
                      child: Text(
                        itemName,
                        style:
                            TextStyles.textViewLight8.copyWith(color: prussian),
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

                //   CheckboxListTile(
                //   contentPadding: EdgeInsets.zero,
                //   controlAffinity: ListTileControlAffinity.leading,value: isChecked, onChanged: (value){
                //   setState(() {
                //     widget.storeItems[i]['isChecked'] = !isChecked;
                //   });
                // },
                //   dense: true,
                //   visualDensity: VisualDensity.compact,
                //   title: Text(itemName,style: TextStyles.textViewLight8.copyWith(color: prussian),),
                //   secondary: Text(itemPrice,style: TextStyles.textViewLight12.copyWith(color: prussian),),
                //   );
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
              Text("€ ${getTotalListPrice()}",
                  style: TextStyles.textViewMedium10.copyWith(color: prussian)),
            ],
          )
        ],
      ),
    );
  }
}
