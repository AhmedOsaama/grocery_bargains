import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:bargainb/providers/products_provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/assets_manager.dart';
import '../../utils/style_utils.dart';

class SearchItem extends StatelessWidget {
  final String name;
  final String store;
  final String size;
  final String currentPrice;
  final String imageURL;
  const SearchItem({Key? key, required this.name, required this.store, required this.size, required this.currentPrice, required this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(10),
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
          Image.network(
              imageURL,
            width: 80.w,height: 80.h,
          ),
          SizedBox(width: 5.w,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,style: TextStyles.textViewMedium13.copyWith(color: gunmetal),maxLines: 2,),
                SizedBox(height: 10.h,),
                Image.asset(Provider.of<ProductsProvider>(context,listen: false).getImage(store),height: 25.h,),
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(size,style: TextStyles.textViewLight10.copyWith(color: gunmetal),),
                    Text("€$currentPrice",style: TextStyles.textViewBold20.copyWith(color: verdigris),),
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


