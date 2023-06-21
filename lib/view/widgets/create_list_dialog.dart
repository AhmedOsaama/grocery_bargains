import 'package:bargainb/providers/chatlists_provider.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../config/routes/app_navigator.dart';
import '../../generated/locale_keys.g.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets_manager.dart';
import '../../utils/style_utils.dart';
import '../components/button.dart';
import '../components/generic_field.dart';
import '../screens/chatlist_view_screen.dart';

class CreateListDialog extends StatefulWidget {
  const CreateListDialog({Key? key}) : super(key: key);

  @override
  State<CreateListDialog> createState() => _CreateListDialogState();
}

class _CreateListDialogState extends State<CreateListDialog> {
  bool canCreate = false;

  TextEditingController chatlistNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              groceryList,
              height: 150.h,
              fit: BoxFit.fitHeight,
            ),
            // 20.ph,
            Text(
              LocaleKeys.createAList.tr(),
              style: TextStylesInter.textViewSemiBold28.copyWith(color: blackSecondary),
            ),
            15.ph,
            GenericField(
              controller: chatlistNameController,
              hintStyle: TextStylesInter.textViewRegular12.copyWith(color: Color.fromRGBO(13, 1, 64, 0.6)),
              hintText: LocaleKeys.enterChatListName.tr(),
              onChanged: (text) {
                if (text!.isNotEmpty && !canCreate) {
                  setState(() {
                    canCreate = true;
                  });
                } else if (canCreate && text.isEmpty) {
                  setState(() {
                    canCreate = false;
                  });
                }
              },
            ),
            16.ph,
            Text(
              LocaleKeys.didYouKnowWhenYouShareChatlists.tr(),
              style: TextStylesInter.textViewRegular12.copyWith(color: blackSecondary),
            ),
            15.ph,
            Row(
              children: [
                Expanded(
                    child: GenericButton(
                  height: 60.h,
                  onPressed: () => AppNavigator.pop(context: context),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  borderColor: grey,
                  child: Text(
                    LocaleKeys.back.tr(),
                    style: TextStyles.textViewSemiBold16.copyWith(color: darkGrey),
                  ),
                )),
                10.pw,
                Expanded(
                    child: GenericButton(
                  height: 60.h,
                  onPressed: () async {
                    var id = await Provider.of<ChatlistsProvider>(context, listen: false)
                        .createChatList([], name: chatlistNameController.text.trim());
                    await pushNewScreen(context,
                        screen: ChatListViewScreen(
                          listId: id,
                        ),
                        withNavBar: false);
                    AppNavigator.pop(context: context);
                  },
                  color: canCreate ? mainOrange : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  borderColor: grey,
                  child: Text(
                    LocaleKeys.create.tr(),
                    style: TextStyles.textViewSemiBold16.copyWith(color: canCreate ? Colors.white : darkGrey),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
