import 'dart:developer';

import 'package:bargainb/core/utils/screen_size_utils.dart';
import 'package:bargainb/features/registration/data/repos/register_repo_impl.dart';
import 'package:bargainb/features/registration/presentation/views/widgets/form_widget.dart';
import 'package:bargainb/features_web/registration/presentation/views/widgets/phone_field_web.dart';
import 'package:bargainb/features_web/registration/presentation/views/widgets/register_form_web.dart';
import 'package:bargainb/models/bargainb_user.dart';
import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/view/components/generic_field_web.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/icons_manager.dart';
import '../../../../utils/style_utils.dart';
import '../../../../utils/validator.dart';
import '../../../../view/components/button.dart';

class RegisterWebScreen extends StatefulWidget {
  RegisterWebScreen({super.key, required this.isLogin});
  bool isLogin;

  @override
  State<RegisterWebScreen> createState() => _RegisterWebScreenState();
}

class _RegisterWebScreenState extends State<RegisterWebScreen> {
  bool isLogin = false;
  @override
  void initState() {
    isLogin = widget.isLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("HEIGHT: ${ScreenUtil().screenHeight}");
    print("WIDTH: ${ScreenUtil().screenWidth}");
    return Scaffold(
      body: !isMobileScreen(context) ? Row(
        children: [
          Expanded(child: Image.asset(signupBg, fit: BoxFit.fill, height: ScreenUtil().screenHeight,)),
          RegisterFormWeb()
        ],
      ) : RegisterFormWeb()
    );
  }
}
