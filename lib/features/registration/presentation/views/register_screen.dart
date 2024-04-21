import 'dart:io';

import 'package:bargainb/features/registration/data/repos/register_repo_impl.dart';
import 'package:bargainb/models/bargainb_user.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/icons_manager.dart';
import '../../../../utils/style_utils.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/validator.dart';
import '../../../../view/components/button.dart';
import '../../../../view/components/generic_field.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key, required this.isLogin});
  bool isLogin;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLogin = false;
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String email = "";
  String password = "";
  String phoneNumber = '';
  bool rememberMe = true;
  final registerRepo = RegisterRepoImpl();

  @override
  void initState() {
    isLogin = widget.isLogin;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100.h,
                ),
                if (isLogin) Center(child: SvgPicture.asset(bargainbIcon)),
                30.ph,
                Center(
                  child: Text(
                    isLogin
                        ? LocaleKeys.welcomeBack.tr()
                        : LocaleKeys.createAnAccount.tr(),
                    style:
                    TextStyles.textViewSemiBold30.copyWith(color: prussian),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Text(
                    isLogin
                        ? LocaleKeys.getTheLatestDiscounts.tr()
                        : LocaleKeys.getTheLatestDiscounts.tr(),
                    style:
                    TextStyles.textViewRegular14.copyWith(color: gunmetal),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                if (!isLogin) ...[
                  Text(
                    LocaleKeys.fullName.tr(),
                    style: TextStylesInter.textViewBold12
                        .copyWith(color: gunmetal),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GenericField(
                    hintText: "Brandone Louis",
                    validation: (value) => Validator.text(value),
                    onSaved: (value) {
                      username = value!;
                    },
                  ),
                ],
                SizedBox(
                  height: 15.h,
                ),
                if (!isLogin) ...[
                  Text(
                    LocaleKeys.email.tr(),
                    style: TextStylesInter.textViewBold12
                        .copyWith(color: gunmetal),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GenericField(
                    hintText: "Brandonelouis@gmail.com",
                    validation: (value) => Validator.email(value),
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                ],
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  LocaleKeys.phone.tr(),
                  style:
                  TextStylesInter.textViewBold12.copyWith(color: gunmetal),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: Utils.boxShadow),
                  child: IntlPhoneField(
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
                      print(phone?.completeNumber);
                      phoneNumber = phone!.completeNumber;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return Validator.phoneValidator(value!.number);
                    },
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            checkColor: const Color.fromRGBO(255, 146, 40, 1),
                            fillColor: MaterialStateProperty.all(
                                const Color.fromRGBO(201, 242, 232, 1)),
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            }),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          LocaleKeys.rememberMe.tr(),
                          style: TextStylesInter.textViewRegular12.copyWith(
                              color: const Color.fromRGBO(170, 166, 185, 1)),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                GenericButton(
                    shadow: [
                      BoxShadow(
                          blurRadius: 9,
                          offset: const Offset(0, 10),
                          color: verdigris.withOpacity(0.25))
                    ],
                    height: 70.h,
                    color: brightOrange,
                    borderRadius: BorderRadius.circular(6),
                    width: double.infinity,
                    onPressed: () async {
                      BargainbUser user = BargainbUser(username: username, email: email, imageURL: '', phoneNumber: phoneNumber);
                      await registerRepo.authenticateUser(context: context, formKey: _formKey,user: user, isLogin: isLogin, rememberMe: rememberMe);
                    },
                    child: Text(
                      isLogin ? LocaleKeys.login.tr() : LocaleKeys.signUp.tr(),
                      style: TextStyles.textViewSemiBold16,
                    )),
                SizedBox(
                  height: 12.h,
                ),
                GenericButton(
                    borderRadius: BorderRadius.circular(6),
                    borderColor: borderColor,
                    color: Colors.white,
                    height: 70.h,
                    width: double.infinity,
                    onPressed: () async =>
                    await registerRepo.loginWithSocial(context, false, rememberMe),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(google2),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          !isLogin ? LocaleKeys.signUpWithGoogle.tr() : "Sign in with Google".tr(),
                          style: TextStyles.textViewSemiBold16
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    )),
                10.ph,
                if (Platform.isIOS)
                  GenericButton(
                      borderRadius: BorderRadius.circular(6),
                      borderColor: borderColor,
                      color: Colors.black,
                      height: 70.h,
                      width: double.infinity,
                      onPressed: () async =>
                      await registerRepo.loginWithSocial(context, true, rememberMe),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(apple),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            !isLogin ? LocaleKeys.signUpWithApple.tr() : "Sign in with Apple".tr(),
                            style: TextStyles.textViewSemiBold16
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      )),
                SizedBox(
                  height: 10.h,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text.rich(
                      TextSpan(
                          text: isLogin
                              ? LocaleKeys.youDontHaveAnAccount.tr()
                              : LocaleKeys.alreadyHaveAnAccount.tr(),
                          style: TextStylesInter.textViewRegular12.copyWith(
                            color: const Color.fromRGBO(82, 75, 107, 1),
                          ),
                          children: [
                            TextSpan(
                                text:
                                " ${isLogin ? LocaleKeys.signUp.tr() : LocaleKeys.signIn.tr()}",
                                style: TextStyles.textViewRegular12.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: const Color.fromRGBO(255, 146, 40, 1)))
                          ]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
