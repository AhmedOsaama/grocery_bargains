import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/fonts_utils.dart';

ThemeData appTheme() {
  return ThemeData(
      canvasColor: Colors.transparent,
      primaryColor: primary,
      hintColor: hintColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: fontFamily,
      appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.w500, color: black, fontSize: 20)),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
            height: 1.3,
            fontSize: 22,
            color: black,
            fontWeight: FontWeight.bold),
      ),
      scrollbarTheme: const ScrollbarThemeData().copyWith(
        thumbColor: MaterialStateProperty.all(const Color(0xffff8297)),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primary));
}
