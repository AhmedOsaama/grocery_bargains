import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:bargainb/utils/style_utils.dart';

import '../../utils/app_colors.dart';

class GenericField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validation;
  final void Function(String)? onSubmitted;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final Function()? onTap;
  final String? labeltext;
  final String? hintText;
  final TextStyle? hintStyle;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isProfile;
  final bool obscureText;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool? isFilled;
  final Color? fillColor;
  final Color? colorStyle;
  final double borderRaduis;
  final List<BoxShadow>? boxShadow;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final bool? enabled;
  final AutovalidateMode? autoValidateMode;
  final double? width;
  final OutlineInputBorder? border;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;

  GenericField({
    super.key,
    this.onSaved,
    this.controller,
    this.validation,
    this.labeltext,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.isFilled = true,
    this.readOnly = false,
    this.isProfile = false,
    this.autoFocus = false,
    this.maxLines = 1,
    this.colorStyle,
    this.borderRaduis = 10,
    this.obscureText = false,
    this.onChanged,
    this.hintStyle,
    this.onTap,
    this.boxShadow,
    this.enabled,
    this.autoValidateMode,
    this.suffixConstraints,
    this.fillColor,
    this.contentPadding,
    this.width,
    this.border, this.enabledBorder, this.focusedBorder,
  });

  @override
  State<GenericField> createState() => _GenericFieldState();
}

class _GenericFieldState extends State<GenericField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        border: widget.colorStyle != null ? Border.all(color: widget.colorStyle!) : null,
          borderRadius: BorderRadius.circular(widget.borderRaduis),
          boxShadow: widget.boxShadow
      ),
      child: TextFormField(
        focusNode: widget.focusNode,
        autofocus: widget.autoFocus!,
        onFieldSubmitted: widget.onSubmitted,
        onSaved: widget.onSaved,
        readOnly: widget.readOnly,
        controller: widget.controller,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        autovalidateMode: widget.autoValidateMode,
        autocorrect: true,
        validator: widget.validation,
        obscureText: widget.obscureText,
        onTapOutside: (_) => FocusManager.instance.primaryFocus!.unfocus(),
        style: const TextStyle(
          color: black,
          fontSize: 16,
        ),
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        decoration: InputDecoration(
          isDense: true,
          filled: widget.isFilled,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText,
          labelText: widget.labeltext,
          fillColor: widget.fillColor ?? Colors.white,
          contentPadding: widget.contentPadding,
          suffixIconConstraints: widget.suffixConstraints,
          labelStyle: const TextStyle(fontSize: 16, color: Color(0xff343434)),
          hintStyle:
          widget.hintStyle ?? TextStylesInter.textViewRegular12.copyWith(color: Color.fromRGBO(13, 1, 64, 0.6)),
          border: widget.border,
          focusedBorder: widget.focusedBorder,
          enabledBorder: widget.enabledBorder,
          // focusedBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //       color: widget.colorStyle!,
          //     ),
          //     borderRadius: BorderRadius.circular(widget.borderRaduis.sp)),
          // enabledBorder: OutlineInputBorder(
          //     borderSide: BorderSide(color: widget.isFilled == true ? Colors.transparent : widget.colorStyle!),
          //     borderRadius: BorderRadius.circular(widget.borderRaduis.sp)),
          // errorBorder: OutlineInputBorder(
          //     borderSide: const BorderSide(
          //       color: Colors.green,
          //     ),
          // )
          //     borderRadius: BorderRadius.circular(widget.borderRaduis.sp)),
        ),
      ),
    );
  }
}