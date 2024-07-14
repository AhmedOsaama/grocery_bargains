import 'package:bargainb/core/utils/screen_size_utils.dart';
import 'package:bargainb/features/registration/presentation/views/widgets/form_widget.dart';
import 'package:bargainb/features_web/registration/presentation/views/widgets/phone_field_web.dart';
import 'package:bargainb/models/bargainb_user.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/view/components/generic_field_web.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../features/registration/data/repos/register_repo_impl.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/icons_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/validator.dart';
import '../../../../../view/components/button.dart';

class RegisterFormWeb extends StatefulWidget {
  final bool isLogin;
  const RegisterFormWeb({super.key, required this.isLogin});

  @override
  State<RegisterFormWeb> createState() => _RegisterFormWebState();
}

class _RegisterFormWebState extends State<RegisterFormWeb> {
  bool isLogin = false;
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String email = "";
  String password = "";
  String phoneNumber = '';
  bool rememberMe = true;
  final registerRepo = RegisterRepoImpl();
  var greyColor = const Color(0xff7C7C7C);

  @override
  void initState() {
    isLogin = widget.isLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                isLogin ? LocaleKeys.welcomeBack.tr() : LocaleKeys.createAnAccount.tr(),
                style: TextStylesInter.textViewBold30,
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Center(
              child: Text(
                isLogin ? LocaleKeys.getTheLatestDiscounts.tr() : LocaleKeys.getTheLatestDiscounts.tr(),
                style: TextStylesInter.textViewRegular18.copyWith(color: greyColor),
                textAlign: TextAlign.center,
              ),
            ),
            40.ph,
            if (!isLogin) ...[
              FormWidget(
                title: "${LocaleKeys.fullName.tr()}*",
                textField: GenericFieldWeb(
                  width: 400,
                  hintText: "Brandone Louis",
                  borderColor: const Color(0xffEBEBEB),
                  borderRaduis: 6,
                  validation: (value) => Validator.text(value),
                  onSaved: (value) {
                    username = value!;
                  },
                ),
              ),
              25.ph,
              FormWidget(
                title: "${LocaleKeys.email.tr()}*",
                textField: GenericFieldWeb(
                  width: 400,
                  hintText: "Brandonelouis@gmail.com",
                  borderColor: const Color(0xffEBEBEB),
                  borderRaduis: 6,
                  validation: (value) => Validator.email(value),
                  onSaved: (value) {
                    email = value!;
                  },
                ),
              ),
            ],
            25.ph,
            FormWidget(
                title: "Phone Number*",
                textField: PhoneFieldWeb(
                  width: 400,
                  borderColor: const Color(0xffEBEBEB),
                  onSaved: (phone) {
                    phoneNumber = phone!.completeNumber;
                  },
                )),
            25.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    checkColor: const Color.fromRGBO(255, 146, 40, 1),
                    fillColor: MaterialStateProperty.all(const Color.fromRGBO(201, 242, 232, 1)),
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
                  style: TextStylesInter.textViewRegular12.copyWith(color: const Color.fromRGBO(170, 166, 185, 1)),
                ),
              ],
            ),
            25.ph,
            GenericButton(
                height: 70.h,
                color: const Color(0xff3463ED),
                borderRadius: BorderRadius.circular(6),
                width: 350,
                onPressed: () async {
                  BargainbUser user =
                      BargainbUser(username: username, email: email, imageURL: '', phoneNumber: phoneNumber);
                  await registerRepo.authenticateUser(
                      context: context, formKey: _formKey, user: user, isLogin: isLogin, rememberMe: rememberMe);
                },
                child: Text(
                  isLogin ? LocaleKeys.login.tr() : LocaleKeys.signUp.tr(),
                  style: TextStyles.textViewSemiBold16,
                )),
            25.ph,
            GenericButton(
                borderRadius: BorderRadius.circular(6),
                borderColor: borderColor,
                color: Colors.white,
                height: 70.h,
                width: 350,
                onPressed: () async {
                  try {
                    await registerRepo.loginWithSocial(context, false, rememberMe);
                  } catch (e) {
                    print("ERRROR WITH GOOGLE SIGN IN: $e");
                  }
                },
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(google2),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        !isLogin ? LocaleKeys.signUpWithGoogle.tr() : "Sign in with Google".tr(),
                        style: TextStyles.textViewSemiBold16.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                )),
            10.ph,
            GenericButton(
                borderRadius: BorderRadius.circular(6),
                borderColor: borderColor,
                color: Colors.black,
                height: 70.h,
                width: 350,
                onPressed: () async => await registerRepo.loginWithSocial(context, true, rememberMe),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(apple),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        !isLogin ? LocaleKeys.signUpWithApple.tr() : "Sign in with Apple".tr(),
                        style: TextStyles.textViewSemiBold16.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 30.h,
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
                      text: isLogin ? LocaleKeys.youDontHaveAnAccount.tr() : LocaleKeys.alreadyHaveAnAccount.tr(),
                      style: TextStylesInter.textViewRegular12.copyWith(
                        color: const Color.fromRGBO(82, 75, 107, 1),
                      ),
                      children: [
                        TextSpan(
                            text: " ${isLogin ? LocaleKeys.signUp.tr() : LocaleKeys.signIn.tr()}",
                            style: TextStyles.textViewRegular12.copyWith(
                                decoration: TextDecoration.underline, color: const Color.fromRGBO(255, 146, 40, 1)))
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
