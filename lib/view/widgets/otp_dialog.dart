import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/style_utils.dart';
import '../../utils/tracking_utils.dart';

class OtpDialog extends StatefulWidget {
  final String phoneNumber;
  final bool isSignUp;
  final Function resendOtp;
  final bool canResend;
  OtpDialog(
      {Key? key,
      required this.phoneNumber,
      required this.resendOtp,
      required this.isSignUp, required this.canResend})
      : super(key: key);

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {

  @override
  void initState() {
    try {
      TrackingUtils().trackPopPageView(
          FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "OTP popup");
    }catch(e){
      print(e);
    }
    super.initState();
  }

  var pin = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            10.ph,
            Text(
              widget.isSignUp ? "LastStep".tr() : "",
              style: TextStylesInter.textViewBold44,
            ),
            30.ph,
            SvgPicture.asset(
              lock,
            ),
            30.ph,
            Text(
              "ConfirmCode".tr(),
              style: TextStylesInter.textViewMedium25,
            ),
            8.ph,
            Text("${"CodeIsSent".tr()}${widget.phoneNumber}"),
            30.ph,
            Pinput(
                validator: (s) {
                  return null;
                },
                length: 6,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) async {
                  this.pin = pin;
                  // print('PIN ENTERED: $pin');
                }),
            30.ph,
            ElevatedButton(
                onPressed: () async {
                  // print(pin);
                  await AppNavigator.pop(context: context, object: pin);
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(130, 60),
                    backgroundColor: yellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    foregroundColor: Colors.white),
                child: Text(
                  "submit".tr(),
                  style: TextStylesInter.textViewSemiBold15,
                )),
            30.ph,
            if(widget.canResend)
            GestureDetector(
              onTap: () async {
                AppNavigator.pop(context: context);
                await widget.resendOtp();
                // print("finish");
              },
              child: Text.rich(
                TextSpan(
                    text: "DidntGetCode".tr(),
                    style: TextStylesInter.textViewRegular18,
                    children: [
                      TextSpan(
                        text: "Resend".tr(),
                        style: TextStylesInter.textViewRegular18.copyWith(
                            decoration: TextDecoration.underline,
                            color: mainPurple),
                      )
                    ]),
              ),
            ),
            10.ph
          ],
        ),
      ),
    );
  }
}
