import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/utils/app_colors.dart';
import 'package:swaav/utils/assets_manager.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/utils/validator.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/components/generic_field.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String confirmPassword = "";
  bool _isLoading = false;

  Future<void> _submitAuthForm(String email, String username, File? pickedImage,
      String password, BuildContext ctx) async {
    UserCredential userCredential;
    try {
      if (!isLogin) {
        setState(() {
          _isLoading = true;
        });
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // final userImageRef = FirebaseStorage.instance.ref().child('user_image').child(userCredential.user!.uid + '.jpg');
        // await userImageRef.putFile(pickedImage!).whenComplete(() => null);
        // final url = await userImageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          "email": email,
          "username": username,
          // 'imageURL': url,
        });
      } else {
        setState(() {
          _isLoading = true;
        });
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
    } on FirebaseAuthException catch (error) {
      var message = "An error occurred, please check your credentials";

      if (error.message != null) {
        message = error.message!;
      }
      print(message);
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 165.h,
                ),
                SvgPicture.asset(splashImage),
                SizedBox(
                  height: 65.h,
                ),
                Text(
                  !isLogin ? "Sign up with: " : "Log in",
                  style: TextStyles.textViewBold20,
                ),
                SizedBox(
                  height: 40.h,
                ),
                GenericField(
                  borderRaduis: 10,
                  hintText: "Email",
                  isFilled: true,
                  colorStyle: borderColor,
                  validation: (value) => Validator.email(value),
                  onSaved: (value) {
                    email = value!;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                GenericField(
                  borderRaduis: 10,
                  hintText: "Password",
                  isFilled: true,
                  colorStyle: borderColor,
                  obscureText: true,
                  validation: (value) => Validator.password(value),
                  onSubmitted: (value) {
                    password = value;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                if (!isLogin)
                  GenericField(
                    borderRaduis: 10,
                    hintText: "Confirm Password",
                    isFilled: true,
                    colorStyle: borderColor,
                    obscureText: true,
                    validation: (value) =>
                        Validator.confirmPassword(value, password),
                    onSaved: (value) {
                      confirmPassword = value!;
                    },
                  ),
                SizedBox(
                  height: 20.h,
                ),
                !isLogin
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            isLogin = true;
                          });
                        },
                        child: Text.rich(TextSpan(
                            text: "Already have an account ? ",
                            children: [
                              TextSpan(
                                  text: "Login",
                                  style: TextStyles.textViewRegular15.copyWith(
                                      color: const Color.fromRGBO(
                                          77, 191, 163, 1)))
                            ],
                            style: TextStyles.textViewRegular15)))
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            isLogin = false;
                          });
                        },
                        child: Text.rich(TextSpan(
                            text: "Don't have an account ? ",
                            children: [
                              TextSpan(
                                  text: "Register",
                                  style: TextStyles.textViewRegular15.copyWith(
                                      color: const Color.fromRGBO(
                                          77, 191, 163, 1)))
                            ],
                            style: TextStyles.textViewRegular15)),
                      ),
                SizedBox(
                  height: 30.h,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : GenericButton(
                        onPressed: () {
                          var isValid = _formKey.currentState?.validate();
                          FocusScope.of(context).unfocus();
                          if (isValid!) {
                            _formKey.currentState?.save();
                            _submitAuthForm(
                                email, "username", null, password, context);
                          }
                        },
                        height: 32.h,
                        // width: 95.w,
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        borderRadius: BorderRadius.circular(10),
                        child: Text(isLogin ? "Login" : "Register",
                            style: TextStyles.textViewRegular18
                                .copyWith(color: Colors.black)),
                      ),
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  "Or continue with: ",
                  style: TextStyles.textViewBold15,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(twitter),
                    Image.asset(fbIcon),
                    Image.asset(google),
                    Image.asset(apple),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
