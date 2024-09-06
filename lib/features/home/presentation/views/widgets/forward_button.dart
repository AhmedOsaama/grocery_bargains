import 'dart:io';

import 'package:bargainb/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ForwardButton extends StatelessWidget {
  final VoidCallback onTap;
  const ForwardButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: primaryGreen),
          ),
            child: Icon(Platform.isAndroid ? Icons.arrow_forward : Icons.arrow_forward_ios_outlined, size: 15,color: primaryGreen,)),
    );
  }
}
