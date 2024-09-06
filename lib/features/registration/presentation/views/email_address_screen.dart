
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/utils/style_utils.dart';
import 'package:bargainb/view/components/generic_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  var _formKey = GlobalKey<FormState>();
  TextEditingController _emailAddressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
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
              Text("Enter your email address", style: TextStylesPaytoneOne.textViewRegular24,),
              15.ph,
              Text("Add your email to aid in recovery", style: TextStylesInter.textViewMedium12,),
              25.ph,
              Text("Email address*", style: TextStylesInter.textViewMedium12,),
              15.ph,
              GenericField(
                controller: _emailAddressController,
                hintText: "jan.jansen@example.com",
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validation: (value) => Validator.text(value),
              ),
              30.ph,
              GenericButton(
                  height: 50,
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(6),
                  width: double.infinity,
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      //TODO: store email in hubspot
                      //TODO: store email in user collection
                      AppNavigator.push(context: context, screen: WelcomeScreen());
                    }
                  },
                  child: Text(
                    "Next",
                    style: TextStyles.textViewMedium16,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
