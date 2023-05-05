import 'dart:developer';

import 'package:bargainb/config/routes/app_navigator.dart';
import 'package:bargainb/view/screens/profile_screen.dart';
import 'package:country_picker/country_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import '../../utils/style_utils.dart';

class NewContactScreen extends StatefulWidget {
  NewContactScreen({Key? key}) : super(key: key);

  @override
  State<NewContactScreen> createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
  String name = "",
      surname = "",
      phone = "",
      countryCode = "31",
      country = "Netherlands";
  bool valid = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    valid = name.isNotEmpty && surname.isNotEmpty && phone.isNotEmpty;
    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: lightPurple,
        foregroundColor: Colors.black,
        // leading: backButt,
        title: Text(
          "New contact",
          style: TextStyles.textViewSemiBold16.copyWith(color: black1),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                log(phone);
                // Insert new contact
                final newContact = Contact()
                  ..name.first = name
                  ..name.last = surname
                  ..phones = [Phone(phone)];
                try {
                  await newContact.insert();
                  AppNavigator.pop(context: context);
                } catch (e) {
                  log(e.toString());
                }
              },
              child: Text(
                "Save",
                style:
                    TextStyles.textViewSemiBold16.copyWith(color: mainPurple),
              ))
        ],
      ),
      body: Column(
        children: [
          20.ph,
          Container(
            color: white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle:
                        TextStyles.textViewRegular16.copyWith(color: hintText),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: grey),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      surname = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Surname",
                    border: InputBorder.none,
                    hintStyle:
                        TextStyles.textViewRegular16.copyWith(color: hintText),
                  ),
                ),
              ]),
            ),
          ),
          25.ph,
          Container(
            color: white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  10.ph,
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        useSafeArea: false,
                        onSelect: (Country c) {
                          setState(() {
                            countryCode = c.phoneCode;
                            country = c.name;
                          });
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Phone",
                              style: TextStyles.textViewSemiBold16
                                  .copyWith(color: black1),
                            ),
                            10.pw,
                            Text(
                              country,
                              style: TextStyles.textViewRegular16
                                  .copyWith(color: hintText),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: mainPurple,
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: grey,
                    height: 20.h,
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      Text(
                        "Mobile",
                        style: TextStyles.textViewSemiBold16
                            .copyWith(color: black1),
                      ),
                      5.pw,
                      Icon(
                        Icons.arrow_forward_ios,
                        color: mainPurple,
                        size: 15.sp,
                      ),
                      10.pw,
                      Text(
                        "+" + countryCode,
                        style: TextStyles.textViewRegular17
                            .copyWith(color: black1),
                      ),
                      10.pw,
                      SizedBox(
                        width: 200.w,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              phone = "+" + countryCode + value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintStyle: TextStyles.textViewRegular16
                                  .copyWith(color: hintText),
                              hintText: "phone...",
                              border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                  10.ph
                ],
              ),
            ),
          ),
          25.ph,
          Container(
            color: white,
            height: 55.h,
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Add field",
                      style: TextStyles.textViewRegular16
                          .copyWith(color: mainPurple),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
