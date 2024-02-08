import 'package:bargainb/utils/empty_padding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/products_provider.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../../view/components/button.dart';

class SeeMoreButton extends StatefulWidget {
  SeeMoreButton({Key? key}) : super(key: key);

  @override
  State<SeeMoreButton> createState() => _SeeMoreButtonState();
}

class _SeeMoreButtonState extends State<SeeMoreButton> {
  bool isFetching = false;
  int pageNumber = 1;


  @override
  Widget build(BuildContext context) {
    return isFetching ? const Center(child: CircularProgressIndicator(),) :
      GenericButton(
        borderRadius: BorderRadius.circular(10),
        borderColor: mainPurple,
        color: Colors.white,
        onPressed: () async {
          var productsProvider = Provider.of<ProductsProvider>(context, listen: false);
          setState(() {
            isFetching = true;
          });
          try {
            pageNumber = pageNumber + 1;
            print("Page Number: $pageNumber");
            await productsProvider.getProducts(pageNumber);
          } catch (e) {
            print(e);
          }
          setState(() {
            isFetching = false;
          });
          try {
            TrackingUtils().trackButtonClick(
                FirebaseAuth.instance.currentUser!.uid, "See more", DateTime.now().toUtc().toString(), "Home screen");
          } catch (e) {
            print(e);
            TrackingUtils().trackButtonClick("Guest", "See more", DateTime.now().toUtc().toString(), "Home screen");
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SEE MORE",
              style: TextStyles.textViewMedium12.copyWith(color: blackSecondary),
            ),
            10.pw,
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
            ),
          ],
        ));
  }
}
