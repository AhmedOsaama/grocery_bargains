import 'dart:io';

import 'package:bargainb/core/utils/firestore_utils.dart';
import 'package:bargainb/core/utils/user_utils.dart';
import 'package:bargainb/features/profile/data/models/User.dart';
import 'package:bargainb/features/profile/presentation/manager/user_provider.dart';
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
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../../utils/assets_manager.dart';
import '../../../../../utils/tracking_utils.dart';
import '../../../../../view/widgets/image_source_picker_dialog.dart';

class UserImageWidget extends StatelessWidget {
  final AuthUser user;
  const UserImageWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: getUserImage(user.imageURL!),
                  radius: 60,
                  child: Material(
                    shape: const CircleBorder(),
                    color: Colors.transparent,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => changeProfilePicture(context),
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
            user.username!,
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
          ),
          4.ph,
          Text(
            user.email!,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> changeProfilePicture(BuildContext context) async {
    ImageSource sourcePicker = await showImagePicker(context);
    try {
      final image = await ImagePicker().pickImage(source: sourcePicker);
      if (image == null) return;
      final imageFile = File(image.path);
      final userImageRef =
          FirebaseStorage.instance.ref().child('user_image').child('${FirebaseAuth.instance.currentUser!.uid}.jpg');
      await userImageRef.putFile(imageFile).whenComplete(() => null);
      final url = await userImageRef.getDownloadURL();
      if (!context.mounted) return;
      Provider.of<AuthUserProvider>(context, listen: false).updateUser({
        'imageURL': url
      });
      // widget.updateUserDataFuture();
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
    trackChangeProfilePicture();
  }

  Future<ImageSource> showImagePicker(BuildContext context) async {
    ImageSource sourcePicker = Platform.isAndroid
        ? await showModalBottomSheet(context: context, builder: (ctx) => const ImageSourcePickerSheet())
        : await showCupertinoModalPopup(context: context, builder: (ctx) => const ImageSourcePickerSheet());
    return sourcePicker;
  }

  dynamic getUserImage(String imageURL) {
    try {
      return imageURL != "" ? NetworkImage(imageURL) : const AssetImage(personImage);
    } catch (e) {
      print(e);
      Sentry.captureMessage(
          "Something went wrong while fetching the profile picture. \n UID: ${FirebaseAuth.instance.currentUser!.uid}");
      return const AssetImage(personImage);
    }
  }

  void trackChangeProfilePicture() {
    try {
      TrackingUtils().trackTextLinkClicked(FirebaseAuth.instance.currentUser!.uid, DateTime.now().toUtc().toString(),
          "Profile screen", "Change profile picture");
    } catch (e) {
      print(e);
    }
  }
}
