import 'dart:convert';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/utils/validator.dart';
import 'package:bargainb/view/components/search_appBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/utils/utils.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:http/http.dart';

import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  var _formKey = GlobalKey<FormState>();

  var userName = "";
  var userEmail = "";
  var userMessage = "";

  @override
  void initState() {
    TrackingUtils().trackPageView(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Support Screen");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: LocaleKeys.support.tr(),),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                70.ph,
                Text(
                  LocaleKeys.yourName.tr(),
                  style: TextStylesInter.textViewBold12.copyWith(color: black1),
                ),
                10.ph,
                GenericField(
                  hintText: "Dina Tairovic",
                  onSaved: (value){
                    userName = value!;
                  },
                  boxShadow: null,
                  validation: (value) => Validator.text(value),
                  // colorStyle: Color.fromRGBO(237, 237, 237, 1),
                ),
                20.ph,
                Text(
                  LocaleKeys.email.tr(),
                  style: TextStylesInter.textViewBold12.copyWith(color: black1),
                ),
                10.ph,
                GenericField(
                  hintText: "dina@me.com",
                  onSaved: (value){
                    userEmail = value!;
                  },
                  validation: (value) => Validator.email(value),
                  // colorStyle: Color.fromRGBO(237, 237, 237, 1),
                ),
                20.ph,
                Text(
                  LocaleKeys.yourMessage.tr(),
                  style: TextStylesInter.textViewBold12.copyWith(color: black1),
                ),
                10.ph,
                GenericField(
                  hintText: "Your message",
                  maxLines: 5,
                  onSaved: (value){
                    userMessage = value!;
                  },
                  validation: (value) => Validator.defaultValidator(value),
                  // colorStyle: Color.fromRGBO(237, 237, 237, 1),
                ),
                30.ph,
                Spacer(),
                GenericButton(
                  onPressed: () {
                    var isValid = _formKey.currentState?.validate();
                    if(isValid!) {
                      _formKey.currentState!.save();
                      sendSupportEmail();
                    }
                  },
                  width: double.infinity,
                  height: 60.h,
                  borderRadius: BorderRadius.circular(6),
                  color: brightOrange,
                  child: Text(
                    LocaleKeys.submit.tr(),
                    style:
                        TextStylesInter.textViewSemiBold16.copyWith(color: Colors.white),
                  ),
                ),
                20.ph
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendSupportEmail() {
    var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    post(url,
        headers: {
      "Content-Type": "Application/json",
      'origin': "http://localhost",
        },
        body: jsonEncode({
      'service_id': 'service_in1p4en',
      'template_id': 'template_8kagjcv',
      'user_id': 'oVDOMhMkZ5BgtIH4g',
      'template_params': {
        'user_name': userName,
        'user_email': userEmail,
        'user_subject': "BargainB Customer Message",
        'user_message': userMessage,
      }
    })).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.messageSentSuccessfully.tr())));
      AppNavigator.pop(context: context);
    }
    ).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.somethingWentWrong.tr())));
    });
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final bool centerTitle;
  const MyAppBar({
    super.key,
    this.height = kToolbarHeight,
    required this.title,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      iconTheme: IconThemeData(
        color: mainPurple
      ),
      title: Text(title, style: TextStylesInter.textViewBold26.copyWith(color: Colors.black),),
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
