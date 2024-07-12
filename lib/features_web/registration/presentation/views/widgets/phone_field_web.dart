import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../../../utils/style_utils.dart';
import '../../../../../utils/validator.dart';

class PhoneFieldWeb extends StatelessWidget {
  final void Function(PhoneNumber?) onSaved;
  final Color borderColor;
  const PhoneFieldWeb({super.key, required this.onSaved, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      disableLengthCheck: false,
      initialCountryCode: "NL",
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(10)),
          fillColor: Colors.white,
          filled: true,
          hintText: "789 123 456",
          hintStyle: TextStylesInter.textViewRegular16),
      onSaved: onSaved,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return Validator.phoneValidator(value!.number);
      },
    );
  }
}
