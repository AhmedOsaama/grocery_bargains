import 'dart:developer';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/onboarding/presentation/views/policy_screen.dart';
import 'package:bargainb/features/onboarding/presentation/views/terms_of_service_screen.dart';
import 'package:bargainb/features/registration/presentation/views/otp_screen.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../models/bargainb_user.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/assets_manager.dart';
import '../../../../utils/validator.dart';
import '../../../../view/components/button.dart';
import '../../data/repos/register_repo_impl.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  var phoneNumber = "";
  final registerRepo = RegisterRepoImpl();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Image.asset(
          bargainbLogo,
          width: 90.w,
          height: 24.h,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Enter your mobile number to get OTP", style: TextStylesPaytoneOne.textViewRegular24,),
              20.ph,
              IntlPhoneField(
                disableLengthCheck: false,
                initialCountryCode: "NL",
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
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
                  phoneNumber = phone!.completeNumber;
                  print(phoneNumber);
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  return Validator.phoneValidator(value!.number);
                },
              ),
              10.ph,
              GenericButton(
                  height: 50,
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(6),
                  width: double.infinity,
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                    BargainbUser user = BargainbUser(phoneNumber: phoneNumber);
                    await registerRepo.authenticateUser(context: context, formKey: _formKey, user: user, isLogin: false, rememberMe: true);
                    }
                  },
                  child: Text(
                    "Get OTP",
                    style: TextStyles.textViewMedium16,
                  )),
              10.ph,
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                    text: "By logging or registering you agree to our ",
                    style: TextStylesInter.textViewRegular12,
                    children: [
                      TextSpan(
                          text: "Terms of Service",
                          style: TextStyle(color: Colors.orange),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => AppNavigator.push(context: context, screen: TermsOfServiceScreen())),
                      const TextSpan(
                        text: " and ",
                      ),
                      TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(color: Colors.orange),
                          recognizer: TapGestureRecognizer()..onTap = () => AppNavigator.push(context: context, screen: PolicyScreen()))
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}