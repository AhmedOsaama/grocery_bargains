import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class QuantityCounter extends StatelessWidget {
  final int quantity;
  final Function increaseQuantity;
  final Function decreaseQuantity;
  const QuantityCounter({Key? key, required this.quantity, required this.increaseQuantity, required this.decreaseQuantity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (quantity > 0) {
             decreaseQuantity();
            }
          },
          icon: Icon(Icons.remove),
          color: primaryGreen,
        ),
        VerticalDivider(
          color: grey,
        ),
        Text(
          quantity.toString(),
          style: TextStyles.textViewMedium18,
        ),
        VerticalDivider(
          color: grey,
        ),
        IconButton(
            onPressed: () {
             increaseQuantity();
            },
            icon: Icon(Icons.add),
            color: primaryGreen),
      ],
    );
  }
}
