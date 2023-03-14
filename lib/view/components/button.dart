import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bargainb/utils/app_colors.dart';

class GenericButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Color color;
  final Color borderColor;
  final Color shadowColorButton;
  final Color? disabledBackgroundColor;
  final double elevationButton;
  final EdgeInsets? padding;
  final List<BoxShadow>? shadow;

  final VoidCallback? onPressed;
  final Widget child;

  const GenericButton({
    Key? key,
    required this.onPressed,
    required this.child,

    this.borderRadius,
    this.width,
    this.height,
    this.color = Colors.blue,
    this.borderColor = Colors.transparent,
    this.shadowColorButton = Colors.transparent,
    this.elevationButton = 0.0, this.shadow, this.disabledBackgroundColor, this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: shadow
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding,
          side: BorderSide(color: borderColor),
          backgroundColor: color,
          // shadowColor: shadowColorButton,
          elevation: 0,
          disabledBackgroundColor: disabledBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: child,
      ),
    );
  }
}
