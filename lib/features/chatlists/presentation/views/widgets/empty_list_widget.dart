import 'package:bargainb/features/chatlists/presentation/views/widgets/quick_item_text_field.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/style_utils.dart';
import 'chat_view_widget.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    super.key,
    required this.quickItemController,
    required this.widget,
  });

  final TextEditingController quickItemController;
  final ChatView widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuickItemTextField(quickItemController: quickItemController, listId: widget.listId),
          // 10.ph,
          Text(
            LocaleKeys.addYourFirstItem.tr(),
            style: TextStylesInter.textViewSemiBold20.copyWith(color: blackSecondary),
          ),
          15.ph,
          Text(
            LocaleKeys.addItemsToYourChatlist.tr(),
            style: TextStylesInter.textViewRegular10.copyWith(color: greyText),
          ),
          // 15.ph,
        ],
      ),
    );
  }
}
