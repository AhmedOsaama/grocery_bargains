import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/assets_manager.dart';
import '../../utils/style_utils.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 28,
            offset: Offset(0,4),
            color: Color.fromRGBO(59, 59, 59, 0.12),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 9),
                decoration: BoxDecoration(
                    color: iris,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Text("1L",style: TextStyles.textViewBold10.copyWith(color: Colors.white),),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: verdigris,width: 2),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Icon(Icons.add,color: verdigris,size: 20,),
                ),
              ),
            ],
          ),
          Image.asset(
              milk
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Melkan long-life skimmed milk",style: TextStyles.textViewMedium13.copyWith(color: gunmetal),),
                SizedBox(height: 10.h,),
                Image.asset(brand),
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("1 Liter l Price per LT € 1.29",style: TextStyles.textViewLight12.copyWith(color: gunmetal),),
                    Text("1.29",style: TextStyles.textViewBold20.copyWith(color: verdigris),),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
