import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swaav/utils/icons_manager.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/components/generic_menu.dart';
import 'package:swaav/view/components/nav_bar.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/widgets/backbutton.dart';

import '../../config/routes/app_navigator.dart';
import 'new_list_screen.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({Key? key}) : super(key: key);

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  bool isAdding = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 62.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyBackButton(),
                Spacer(
                  flex: 2,
                ),
                Text(
                  "Lists",
                  style:
                      TextStyles.textViewBold15.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                GenericButton(
                  onPressed: () {},
                  child: Text(
                    "Filter",
                    style: TextStyles.textViewBold15,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  width: 95.w,
                  height: 26.h,
                )
              ],
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18.w,
                    ),
                    SvgPicture.asset(
                      cartIcon,
                    ),
                    SizedBox(
                      width: 27.w,
                    ),
                    Text(
                      "Groceries",
                      style: TextStyles.textViewBold15
                          .copyWith(color: Colors.black),
                    ),
                    const Spacer(),
                    SvgPicture.asset(peopleIcon),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isAdding)
            PlusButton(onTap: () {
              setState(() {
                isAdding = true;
              });
            }),
          Spacer(),
          if (isAdding)
            GenericMenu(option1Text: "New list", option2Text: "Pre-made", option1Func: () => AppNavigator.push(context: context,screen: NewListScreen()), option2Func: (){})
        ],
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
