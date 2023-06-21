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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Quantity",
          style: TextStyles.textViewMedium12
              .copyWith(color: Colors.grey),
        ),
        Container(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (quantity > 0) {
                   decreaseQuantity();
                  }
                },
                icon: Icon(Icons.remove),
                color: verdigris,
              ),
              VerticalDivider(),
              Text(
                quantity.toString(),
                style: TextStyles.textViewMedium18,
              ),
              VerticalDivider(),
              IconButton(
                  onPressed: () {
                   increaseQuantity();
                  },
                  icon: Icon(Icons.add),
                  color: verdigris),
            ],
          ),
        ),
      ],
    );
  }
}
