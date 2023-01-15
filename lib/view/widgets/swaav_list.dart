import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/icons_manager.dart';
import '../../utils/style_utils.dart';

class SwaavList extends StatelessWidget {
  final String listName;
  const SwaavList({Key? key, required this.listName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18.w,
          ),
          SvgPicture.asset(
            cartIcon,
          ),
          SizedBox(
            width: 27.w,
          ),
          Text(
            listName,
            style: TextStyles.textViewBold15
                .copyWith(color: Colors.black),
          ),
          const Spacer(),
          SvgPicture.asset(peopleIcon),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
    );
  }
}
