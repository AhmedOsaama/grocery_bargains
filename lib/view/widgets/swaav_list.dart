import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/fonts_utils.dart';
import 'package:swaav/utils/utils.dart';

import '../../utils/app_colors.dart';
import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';

class SwaavList extends StatefulWidget {
  final String listName;
  final String userImage;
  final List<Map> items;
  const SwaavList({Key? key, required this.listName, required this.items, required this.userImage}) : super(key: key);

  @override
  State<SwaavList> createState() => _SwaavListState();
}

class _SwaavListState extends State<SwaavList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      // margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromRGBO(222, 222, 222, 1),width: 0.5),
        boxShadow: Utils.boxShadow
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(widget.userImage),
          SizedBox(height: 10.h,),
          Text(widget.listName,style: TextStylesDMSans.textViewSemiBold14.copyWith(color: const Color.fromRGBO(37, 37, 37, 1)),),
          SizedBox(height: 10.h,),
          ListView.builder(
            shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.items.length > 5 ? 5 : widget.items.length,
              itemBuilder: (ctx,i) {
                var isChecked = widget.items[i]['isChecked'];
                var itemName = widget.items[i]['itemName'];
              if(i > 3) return const Text("...");
              return Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        widget.items[i]['isChecked'] = !isChecked;
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
                ],
              );
              }),
        ],
      ),
    );
  }
}
