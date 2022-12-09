import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static bool isVideo(String resource) {
    String ext = resource.split('.').last;
    return ext == "mp4";
  }

  // static Future<String> getFileImageFromUint8List(Uint8List _uint8list) async {
  //   String baseDirectly = (await path_provider.getTemporaryDirectory()).path;
  //   var uuid = Uuid();
  //   final path = "$baseDirectly/${uuid.v4()}.jpg";

  //   final file = await new File(path).create();
  //   file.writeAsBytesSync(_uint8list);
  //   return path;
  // }

  static String toNormalizedValue(int value) {
    if (value < 1000) {
      return value.toString();
    }
    const units = <int, String>{
      1000000000: 'B',
      1000000: 'M',
      1000: 'K',
    };
    return units.entries
        .map((e) => '${value ~/ e.key}${e.value}')
        .firstWhere((e) => !e.startsWith('0'), orElse: () => '$value');
  }

  static String formateDate(String date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    return formatter.format(DateTime.parse(date).add(Duration(hours: 3)));
  }

  static String decodeBase64(String str) {
    //'-', '+' 62nd char of encoding,  '_', '/' 63rd char of encoding
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      // Pad with trailing '='
      case 0: // No pad chars in this case
        break;
      case 2: // Two pad chars
        output += '==';
        break;
      case 3: // One pad char
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static TextStyle textStyleblackBold({
    double size = 14,
    double height = 1,
  }) {
    return TextStyle(
        color: Colors.black,
        fontSize: size,
        fontWeight: FontWeight.bold,
        height: height);
  }

  static TextStyle textStyleColor(
      {double size =14,
      Color? color,
      double height = 1,
      FontWeight? fontWeight}) {
    return TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        height: height,
        fontFamily: "Tajawal");
  }
}
