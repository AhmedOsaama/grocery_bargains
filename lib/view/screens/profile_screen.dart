import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/screens/invite_screen.dart';
import 'package:swaav/view/widgets/backbutton.dart';

import '../../utils/assets_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<DocumentSnapshot<Map<String, dynamic>>>? getUserDataFuture;
  @override
  void initState() {
    getUserDataFuture = FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    super.initState();
  }
  bool isEditingPicture = false;
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            SizedBox(
              height: 70.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const MyBackButton(),
                if (isEditingPicture)
                  Column(
                    children: [
                      GenericButton(
                          onPressed: () {},
                          borderRadius: BorderRadius.circular(10),
                          height: 31.h,
                          width: 165.w,
                          child: Text(
                            "View Profile Picture",
                            style: TextStyles.textViewBold12,
                          )),
                      SizedBox(
                        height: 10.h,
                      ),
                      GenericButton(
                          onPressed: () async {
                              final picker = ImagePicker();
                              final pickedImage = await picker.pickImage(source: ImageSource.gallery,
                              );
                              final pickedImageFile = File(pickedImage!.path);

                            final userImageRef = FirebaseStorage.instance.ref().child('user_image').child('${FirebaseAuth.instance.currentUser?.uid}.jpg');
                            await userImageRef.putFile(pickedImageFile).whenComplete(() => null);
                            final url = await userImageRef.getDownloadURL();
                             await FirebaseFirestore.instance.collection('/users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                                "imageURL": url,
                              });
                             setState(() {
                              isEditingPicture = false;
                             });
                          },
                          borderRadius: BorderRadius.circular(10),
                          height: 31.h,
                          width: 165.w,
                          child: Text(
                            "Change Profile Picture",
                            style: TextStyles.textViewBold12,
                          )),
                      SizedBox(height: 10.h,),
                      GenericButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            AppNavigator.pop(context: context);
                          },
                          borderRadius: BorderRadius.circular(10),
                          height: 31.h,
                          width: 165.w,
                          child: Text(
                            "Log out",
                            style: TextStyles.textViewBold12,
                          )),
                    ],
                  ),
                Column(
                  children: [
                    // isEditingPicture ? Container(
                    //     decoration: BoxDecoration(
                    //         border: Border.all(
                    //             color: Colors.black, width: 5),
                    //         shape: BoxShape.circle),
                    //     child: Container()) :
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditingPicture = true;
                        });
                      },
                      child: FutureBuilder(
                        future: getUserDataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 5),
                                    shape: BoxShape.circle),
                                child: Container());
                          }
                          return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 5),
                                  shape: BoxShape.circle),
                              child: snapshot.data!['imageURL'] != "" ? CircleAvatar(backgroundImage: NetworkImage(snapshot.data!['imageURL']),radius: 30,) : SvgPicture.asset(personIcon));
                        }
                      ),
                    ),
                    FutureBuilder(
                      future: getUserDataFuture,
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator());
                        }
                        return Text(
                          snapshot.data!['username'],
                          style: TextStyles.textViewBold15
                              .copyWith(color: Colors.black),
                        );
                      }
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
            Row(
              children: [
                GenericButton(
                  onPressed: () {},
                  child: Text(
                    "My Friends",
                    style: TextStyles.textViewBold15,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  height: 40.h,
                ),
                SizedBox(
                  width: 11.w,
                ),
                GestureDetector(
                  onTap: () => AppNavigator.push(
                      context: context, screen: InviteScreen()),
                  child: Container(
                    width: 21.w,
                    height: 21.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: buttonColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.25),
                          )
                        ]),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 73.h,
            ),
            GenericButton(
                onPressed: () {},
                child: Text(
                  "Favourites",
                  style: TextStyles.textViewBold15,
                ),
                width: 270.w,
                borderRadius: BorderRadius.circular(5),
                height: 40.h),
            SizedBox(
              height: 37.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100.w,
                  height: 137.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Color.fromRGBO(217, 217, 217, 1)),
                ),
                Container(
                  width: 100.w,
                  height: 137.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Color.fromRGBO(217, 217, 217, 1)),
                ),
                Container(
                  width: 100.w,
                  height: 137.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Color.fromRGBO(217, 217, 217, 1)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
