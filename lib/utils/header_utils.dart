import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HeaderUtils {
  static defaultHeader(BuildContext context) {
    return {
      "Accept": "application/json",
      "Accept-Language": "application/json",
      "Content-Type": "application/json"
    };
  }

  static dynamicHeaders(BuildContext context, String token) {
    var currentLocal = Localizations.localeOf(context).languageCode;

    return {
      "Accept": "application/json",
      "Accept-Language": "application/json",
      "Api-Lang": currentLocal == "ar" ? "ar" : "en",
      "Authorization": "Bearer $token",
      "Timezone": DateTime.now().timeZoneName,
      "Content-Type": "application/json"
    };
  }
}
