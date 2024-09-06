import 'dart:io';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/registration/presentation/views/signup_screen.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../models/bargainb_user.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/style_utils.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/validator.dart';
import '../../../../view/components/button.dart';
import '../../data/repos/register_repo_impl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key,});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNumber = '';
  bool rememberMe = true;
  final registerRepo = RegisterRepoImpl();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(loginCover, width: double.infinity, fit: BoxFit.cover,),
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xff081609)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 60.ph,
              Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(loginBeeLine,)),
              50.ph,
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(bbIconNew,),
                  Text("Login", style: TextStylesPaytoneOne.textViewRegular24.copyWith(color: Colors.white),),
                  10.ph,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(
                      "Login to get the latest discounts, create lists, and share the discounts or shopping with family and friends",
                      style: TextStylesInter.textViewRegular12.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  20.ph,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Phone number*",
                      style:
                      TextStylesInter.textViewBold12.copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  IntlPhoneField(
                    disableLengthCheck: false,
                    initialCountryCode: "NL",
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "789 123 456",
                        hintStyle: TextStylesInter.textViewRegular16),
                    // inputFormatters: [],
                    onSaved: (phone) {
                      // print(phone?.completeNumber);
                      phoneNumber = phone!.completeNumber;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return Validator.phoneValidator(value!.number);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              checkColor: Colors.green,
                              fillColor: MaterialStateProperty.all(
                                  Colors.white),
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              }),
                          Text(
                            "Remember me",
                            style: TextStylesInter.textViewRegular12.copyWith(
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GenericButton(
                      height: 70.h,
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(6),
                      width: double.infinity,
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                        BargainbUser user = BargainbUser(phoneNumber: phoneNumber);
                        await registerRepo.authenticateUser(context: context, formKey: _formKey, user: user, isLogin: true, rememberMe: rememberMe);
                        }
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyles.textViewMedium16,
                      )),
                  20.ph,
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          // indent: 20.0,
                          endIndent: 10.0,
                          thickness: 1,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(color: Color(0xffE0F3E1)),
                      ),
                      Expanded(
                        child: Divider(
                          indent: 10.0,
                          // endIndent: 20.0,
                          thickness: 1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account ? ", style: TextStylesInter.textViewRegular14.copyWith(color: Colors.white),),
                      TextButton(onPressed: (){
                        AppNavigator.push(context: context, screen: SignupScreen());
                      }, child: Text("Signup", style: TextStylesInter.textViewRegular14.copyWith(color: const Color(0xffFF8A00)),))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}