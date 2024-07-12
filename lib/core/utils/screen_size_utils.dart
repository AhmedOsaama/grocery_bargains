import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool isMobileScreen(BuildContext context){
  var screenWidth = MediaQuery.of(context).size.width;
  return screenWidth < 600;
}

// ScreenUtil().screenHeight < 850 ||