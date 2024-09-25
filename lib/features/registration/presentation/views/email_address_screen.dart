import 'dart:developer';

import 'package:bargainb/providers/user_provider.dart';
import 'package:bargainb/services/hubspot_service.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/utils/tracking_utils.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:segment_analytics/event.dart';

import '../../../../config/routes/app_navigator.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/assets_manager.dart';
import '../../../../utils/validator.dart';
import '../../../../view/components/button.dart';
import '../../../onboarding/presentation/views/welcome_screen.dart';

class EmailAddressScreen extends StatefulWidget {
  const EmailAddressScreen({super.key});

  @override
  State<EmailAddressScreen> createState() => _EmailAddressScreenState();
}

class _EmailAddressScreenState extends State<EmailAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailAddressController = TextEditingController();
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your email address".tr(),
                style: TextStylesPaytoneOne.textViewRegular24,
              ),
              15.ph,
              Text(
                "Add your email to aid in recovery".tr(),
                style: TextStylesInter.textViewMedium12,
              ),
              25.ph,
              Text(
                "Email address*".tr(),
                style: TextStylesInter.textViewMedium12,
              ),
              15.ph,
              GenericField(
                controller: _emailAddressController,
                hintText: "jan.jansen@example.com",
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validation: (value) => Validator.email(value),
              ),
              30.ph,
              GenericButton(
                  height: 50,
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(6),
                  width: double.infinity,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        var email = _emailAddressController.text.trim();
                        Provider.of<UserProvider>(context,listen: false).email = email;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          'email': email,
                        });
                        TrackingUtils.segment.identify(userId: FirebaseAuth.instance.currentUser!.uid, userTraits: UserTraits(email: email));
                      } catch (e) {
                        log("email_address_screen Error: $e");
                      }
                      AppNavigator.push(context: context, screen: const WelcomeScreen());
                    }
                  },
                  child: Text(
                    "Next".tr(),
                    style: TextStyles.textViewMedium16,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
