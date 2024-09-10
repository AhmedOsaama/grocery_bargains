import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/features/registration/presentation/views/email_address_screen.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/assets_manager.dart';
import '../../../../utils/style_utils.dart';
import '../../../../view/components/button.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter the 4-digit code sent to you at ${phoneNumber}",
              style: TextStylesPaytoneOne.textViewRegular24,
            ),
            TextButton(
                onPressed: () {
                  AppNavigator.pop(context: context);
                },

                child: Text(
                  "Change mobile number".tr(),
                  style: TextStylesInter.textViewMedium12.copyWith(decoration: TextDecoration.underline, color: Colors.grey),
                )),
            Pinput(
                validator: (s) {
                  return null;
                },
                length: 6,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) async {
                  // this.pin = pin;
                  print('PIN ENTERED: $pin');
                }),
            20.ph,
            GenericButton(
                height: 50,
                color: primaryGreen,
                borderRadius: BorderRadius.circular(6),
                width: double.infinity,
                onPressed: () {
                  //verify logic
                  AppNavigator.push(context: context, screen: EmailAddressScreen());
                },
                child: Text(
                  "Continue".tr(),
                  style: TextStyles.textViewMedium16,
                )),
            Row(
              children: [
                Text(
                  "Didn't receive it ?".tr(),
                  style: TextStylesInter.textViewRegular14,
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Resend Code".tr(),
                      style: TextStylesInter.textViewRegular14.copyWith(color: Color(0xffFF8A00)),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}