import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/style_utils.dart';
import '../../../../../view/components/button.dart';

class FourthOnboardingSurvey extends StatefulWidget {
  final PageController pageController;
  final Function saveFourthScreenResponses;
  const FourthOnboardingSurvey({super.key, required this.pageController, required this.saveFourthScreenResponses});

  @override
  State<FourthOnboardingSurvey> createState() => _FourthOnboardingSurveyState();
}

class _FourthOnboardingSurveyState extends State<FourthOnboardingSurvey> {
  final Map stores = {
    "Albert Heijn": albert,
    "Jumbo": jumbo,
    "Dirk": dirkLogo,
    "Hoogvliet": hoogLogo,
    "Spar": spar,
    "Coop": coop,
    "Lidl": lidle_store,
    "Aldi": aldi,
    "more": moreStores,
  };

  List<String> selectedStores = [];

  bool showErrorText = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Where do you like to shop ?".tr(),
          style: TextStylesPaytoneOne.textViewRegular24,
        ),
        10.ph,
        Text(
          "Select the stores where you usually shop. You can choose multiple options.".tr(),
          style: TextStylesInter.textViewMedium12,
        ),
        25.ph,
        Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 20,
            children: stores.entries.map((store) {
              return GestureDetector(
                onTap: () {
                  if(store.key == "more") return;
                  setState(() {
                    if (!selectedStores.contains(store.key)) {
                      selectedStores.add(store.key);
                    }else{
                      selectedStores.remove(store.key);
                    }
                    if (showErrorText) showErrorText = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: selectedStores.contains(store.key) ? Border.all(color: primaryGreen) : null,
                      boxShadow:  selectedStores.contains(store.key) ? [
                        BoxShadow(
                          color: Color.fromRGBO(0, 31, 143, 0.1),
                          blurRadius: 6,
                          spreadRadius: -1,
                          offset: Offset(0, 4),
                        ),
                        BoxShadow(
                            color: Color.fromRGBO(0, 31, 143, 0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                            spreadRadius: -2
                        )
                      ] : [
                        BoxShadow(
                          color: Color(0xff00B207).withOpacity(0.1),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                        BoxShadow(
                          color: Color(0xff2C742F).withOpacity(0.1),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: -1
                        )
                      ]),
                  child: Image.asset(
                    store.value,
                    width: 40,
                    height: 40,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        30.ph,
        if (showErrorText)
          Text(
            "Please select at least one goal to proceed.".tr(),
            style: TextStylesInter.textViewRegular10.copyWith(color: Colors.red),
          ),
        Spacer(),
        GenericButton(
            onPressed: () {
              if (selectedStores.isEmpty) {
                setState(() {
                  showErrorText = true;
                });
              } else {
                widget.saveFourthScreenResponses(selectedStores);
                widget.pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
              }
            },
            width: double.infinity,
            height: 48,
            color: primaryGreen,
            borderRadius: BorderRadius.circular(6),
            child: Text(
              "Next".tr(),
              style: TextStylesInter.textViewMedium16,
            ))
      ],
    );
  }
}
