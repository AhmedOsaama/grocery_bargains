import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class GenericField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validation;
  final void Function(String)? onSubmitted;
  final String? labeltext;
  final String? hintText;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isProfile;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool? isFilled;
  final Color? colorStyle;
  final double? borderRaduis;

  const GenericField({
    super.key,
    this.controller,
    this.validation,
    this.labeltext,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.isFilled = false,
    this.readOnly = false,
    this.isProfile = false,
    this.autoFocus = false,
    this.maxLines = 1,
    this.colorStyle = lightGrey,
    this.borderRaduis = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 55.h,
      child: TextFormField(
        focusNode: focusNode,
        // textInputAction: TextInputAction.done,
        autofocus: autoFocus!,
        onFieldSubmitted: onSubmitted,
        readOnly: readOnly,
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        autocorrect: true,
        validator: validation,
        style: const TextStyle(
          color: black,
          fontSize: 16,
        ),

        decoration: InputDecoration(
          filled: isFilled,

          // contentPadding: const EdgeInsets.only(left: 5, right: 5),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          labelText: labeltext,
          fillColor: Color.fromRGBO(188, 188, 188, 1),
          labelStyle: const TextStyle(fontSize: 16, color: Color(0xff343434)),
          hintStyle: const TextStyle(fontSize: 16, color: grey),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: isFilled == true ? Colors.transparent : colorStyle!,
              ),
              borderRadius: BorderRadius.circular(borderRaduis!.sp)),

          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isFilled == true ? Colors.transparent : colorStyle!,
              ),
              borderRadius: BorderRadius.circular(borderRaduis!.sp)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isFilled == true ? Colors.transparent : colorStyle!),
              borderRadius: BorderRadius.circular(borderRaduis!.sp)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: primary,
              ),
              borderRadius: BorderRadius.circular(borderRaduis!.sp)),
          // border: const OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black, width: 1.0),
          // ),
          // focusedBorder: const OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black, width: 1.0),
          // ),
        ),
      ),
    );
  }
}
