import 'package:bargainb/utils/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../providers/tutorial_provider.dart';
import '../../../../../utils/style_utils.dart';

class SkipTutorialButton extends StatelessWidget {
  const SkipTutorialButton({
    super.key,
    required this.tutorialProvider,
    required this.context,
  });

  final TutorialProvider tutorialProvider;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: TextButton(
        onPressed: () {
          tutorialProvider.stopTutorial(this.context);
        },
        child: Text(
          LocaleKeys.skip.tr(),
          style: TextStylesInter.textViewRegular14.copyWith(color: primaryGreen),
        ),
      ),
    );
  }
}
