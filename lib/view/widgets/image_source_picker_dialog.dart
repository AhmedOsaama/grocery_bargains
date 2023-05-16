import 'dart:io';

import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourcePickerSheet extends StatelessWidget {
  const ImageSourcePickerSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text(LocaleKeys.camera.tr()),
          onTap: () => Navigator.of(context).pop(ImageSource.camera),
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text(LocaleKeys.gallery.tr()),
          onTap: () => Navigator.of(context).pop(ImageSource.gallery),
        )
      ],
    ) : CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(onPressed: () => Navigator.of(context).pop(ImageSource.gallery), child: Text(LocaleKeys.gallery.tr())),
        CupertinoActionSheetAction(onPressed: () => Navigator.of(context).pop(ImageSource.camera), child: Text(LocaleKeys.camera.tr()))
      ],
    );
  }
}
