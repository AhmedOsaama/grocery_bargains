import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class SwitchButton extends StatelessWidget {
  Function(bool) onChanged;
  bool value;
  SwitchButton({Key? key, required this.onChanged, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Switch(
        // thumb color (round icon)
        activeColor: blue,
        activeTrackColor: grey,
        inactiveThumbColor: white,
        inactiveTrackColor: Colors.grey.shade400,
        splashRadius: 50.0,
        // boolean variable value
        value: value,
        // changes the state of the switch
        onChanged: onChanged,
      );
    } else {
      return CupertinoSwitch(
        // overrides the default green color of the track
        activeColor: blue,
        // color of the round icon, which moves from right to left
        thumbColor: darkGrey,
        // when the switch is off
        trackColor: grey,
        // boolean variable value
        value: value,
        // changes the state of the switch
        onChanged: onChanged,
      );
    }
  }
}
