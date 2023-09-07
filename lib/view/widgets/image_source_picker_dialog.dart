import 'dart:io';

import 'package:bargainb/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/tracking_utils.dart';

class ImageSourcePickerSheet extends StatefulWidget {
  const ImageSourcePickerSheet({Key? key}) : super(key: key);

  @override
  State<ImageSourcePickerSheet> createState() => _ImageSourcePickerSheetState();
}

class _ImageSourcePickerSheetState extends State<ImageSourcePickerSheet> {

  @override
  void initState() {
    try {
      TrackingUtils().trackPopPageView(
          FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(), "Choose profile picture popup");
    }catch(e){
      print(e);
    }
    super.initState();
  }

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
