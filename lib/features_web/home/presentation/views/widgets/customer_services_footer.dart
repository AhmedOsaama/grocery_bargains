import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/style_utils.dart';

class CustomerServicesFooter extends StatelessWidget {
  const CustomerServicesFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> services = {
      "About us": Container(),
      "Terms & Conditions": Container(),
      "FAQ": Container(),
      "Privacy Policy": Container(),
      "E-waste Policy": Container(),
      "Cancellation & Return Policy": Container(),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Customer Services",
          style: TextStylesInter.textViewMedium25,
        ),
        26.ph,
        ...services.entries.map((service) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: (){
              // AppNavigator.push(context: context, screen: service.value);
            },
            child: Text(service.key, style: TextStylesInter.textViewRegular16.copyWith(color: Color(0xff7C7C7C)),),
          ),
        )).toList(),
      ],
    );
  }
}
