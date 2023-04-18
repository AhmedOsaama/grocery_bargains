import 'package:bargainb/utils/app_colors.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

import '../../config/routes/app_navigator.dart';
import '../../utils/style_utils.dart';

class OtpDialog extends StatelessWidget {
  final String phoneNumber;
  final Function resendOtp;
  OtpDialog({Key? key, required this.phoneNumber, required this.resendOtp}) : super(key: key);

  var pin = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            10.ph,
            Text(
              "Last step",
              style: TextStylesInter.textViewBold44,
            ),
            30.ph,
            SvgPicture.asset(
              lock,
            ),
            30.ph,
            Text(
              "Confirm code",
              style: TextStylesInter.textViewMedium25,
            ),
            8.ph,
            Text("Code is sent to ${phoneNumber}"),
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
                  print('PIN ENTERED: $pin');
                }),
            30.ph,
            ElevatedButton(
                onPressed: () async {
                  print(pin);
                  await AppNavigator.pop(context: context,object: pin);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(130, 60),
                    backgroundColor: yellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    foregroundColor: Colors.white),
                child: Text(
                  "Submit",
                  style: TextStylesInter.textViewSemiBold15,
                )),
            30.ph,
            GestureDetector(
              onTap: () async {
                AppNavigator.pop(context: context);
                await resendOtp();
                print("finish");
              },
              child: Text.rich(
                TextSpan(
                    text: "Didn't get the code ?  ",
                    style: TextStylesInter.textViewRegular18,
                    children: [
                      TextSpan(
                        text: "Resend",
                        style: TextStylesInter.textViewRegular18
                            .copyWith(decoration: TextDecoration.underline,color: mainPurple),
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
