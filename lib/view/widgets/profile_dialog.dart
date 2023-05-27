// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bargainb/view/screens/profile_screen.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../providers/google_sign_in_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';
import '../screens/register_screen.dart';

class ProfileDialog extends StatelessWidget {
  final String title;
  final String body;
  final String buttonText;
  final bool isSigningOut;
  const ProfileDialog(
      {Key? key,
      required this.title,
      required this.body,
      required this.buttonText,
      required this.isSigningOut})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, top: 16, right: 14, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title?',
              style: TextStyles.textViewSemiBold28.copyWith(color: black2),
            ),
            10.ph,
            Text(
              body,
              style: TextStyles.textViewRegular16
                  .copyWith(color: Color.fromRGBO(72, 72, 72, 1)),
            ),
            10.ph,
            Row(
              children: [
                Expanded(
                    child: GenericButton(
                        color: Colors.white,
                        height: 60.h,
                        borderColor: Color.fromRGBO(237, 237, 237, 1),
                        borderRadius: BorderRadius.circular(6),
                        onPressed: () => AppNavigator.pop(context: context),
                        child: Text(
                          LocaleKeys.cancel.tr(),
                          style: TextStyles.textViewSemiBold16
                              .copyWith(color: black2),
                        ))),
                10.pw,
                Expanded(
                    child: GenericButton(
                        color: yellow,
                        height: 60.h,
                        borderRadius: BorderRadius.circular(6),
                        onPressed: () async {
                          if (isSigningOut) {
                            var pref = await SharedPreferences.getInstance();
                            pref.setBool("rememberMe", false);
                            var isGoogleSignedIn =
                                await Provider.of<GoogleSignInProvider>(context,
                                        listen: false)
                                    .googleSignIn
                                    .isSignedIn();
                            if (isGoogleSignedIn) {
                              await Provider.of<GoogleSignInProvider>(context,
                                      listen: false)
                                  .logout();
                            } else {
                              FirebaseAuth.instance.signOut();
                            }
                            print("SIGNED OUT...................");
                          } else {
                            await FirebaseAuth.instance.currentUser?.reload();
                            await FirebaseFirestore.instance
                                .collection('/users')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .delete();

                            await FirebaseAuth.instance.currentUser?.delete();
                          }
                          AppNavigator.pushReplacement(
                              context: context, screen: RegisterScreen());
                        },
                        child: Text(
                          buttonText,
                          style: TextStyles.textViewSemiBold16
                              .copyWith(color: black2),
                        ))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
