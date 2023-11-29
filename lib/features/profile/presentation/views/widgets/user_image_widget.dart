import 'dart:io';

import 'package:bargainb/features/profile/presentation/views/profile_screen.dart';
import 'package:bargainb/utils/icons_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../../view/widgets/image_source_picker_dialog.dart';

class UserImageWidget extends StatefulWidget {
  final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userProfileSnapshot;
  final Function updateUserDataFuture;

  UserImageWidget({Key? key, required this.userProfileSnapshot, required this.updateUserDataFuture}) : super(key: key);

  @override
  State<UserImageWidget> createState() => _UserImageWidgetState();
}

class _UserImageWidgetState extends State<UserImageWidget> {
  var snapshot;
  @override
  void initState() {
   snapshot = widget.userProfileSnapshot;
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            color: Colors.red,
            ),
            child: Stack(
              children: [
                CircleAvatar(backgroundImage: getUserImage(snapshot), radius: 60,
                    child: Material(
                      shape: CircleBorder(),
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: changeProfilePicture,
                      ),
                    ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SvgPicture.asset(pictureEdit),
                  ),
                )
              ],
            ),
          ),
            Text(
              snapshot.data!['username'],
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
            ),
            4.ph,
            Text(
              snapshot.data!['email'],
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Future<void> changeProfilePicture() async {
    ImageSource sourcePicker = await showImagePicker(context);
    try {
      final image = await ImagePicker().pickImage(source: sourcePicker);
      if (image == null) return;
      final imageFile = File(image.path);
      final userImageRef = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
      await userImageRef.putFile(imageFile).whenComplete(() => null);
      final url = await userImageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'imageURL': url,
      });
        widget.updateUserDataFuture();
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
    trackChangeProfilePicture();
  }

  Future<ImageSource> showImagePicker(BuildContext context) async {
    ImageSource sourcePicker = Platform.isAndroid
        ? await showModalBottomSheet(
        context: context, builder: (ctx) => ImageSourcePickerSheet())
        : await showCupertinoModalPopup(
        context: context, builder: (ctx) => ImageSourcePickerSheet());
    return sourcePicker;
  }

  dynamic getUserImage(AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    try {
      return snapshot.data!['imageURL'] != "" ? NetworkImage(snapshot.data!['imageURL']) : AssetImage(personImage);
    } catch (e) {
      print(e);
      Sentry.captureMessage(
          "Something went wrong while fetching the profile picture. \n UID: ${FirebaseAuth.instance.currentUser!.uid}");
      return AssetImage(personImage);
    }
  }

  void trackChangeProfilePicture() {
    try {
      TrackingUtils().trackTextLinkClicked(FirebaseAuth.instance.currentUser!.uid,
          DateTime.now().toUtc().toString(), "Profile screen", "Change profile picture");
    } catch (e) {
      print(e);
    }
  }

}

