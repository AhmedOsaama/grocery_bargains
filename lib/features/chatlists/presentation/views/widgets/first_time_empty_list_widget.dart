import 'package:bargainb/features/chatlists/presentation/views/widgets/quick_item_text_field.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../utils/style_utils.dart';

class FirstTimeEmptyListWidget extends StatelessWidget {
  final TextEditingController quickItemController;
  final String listId;
  const FirstTimeEmptyListWidget({Key? key, required this.quickItemController, required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          QuickItemTextField(quickItemController: quickItemController, listId: listId),
          20.ph,
          Text(
            LocaleKeys.buildYourChatlist.tr(),
            style: TextStyles.textViewRegular10,
          ),
        ],
      ),
    );
  }
}
