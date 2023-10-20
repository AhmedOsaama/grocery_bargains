import 'package:bargainb/utils/assets_manager.dart';
import 'package:bargainb/utils/empty_padding.dart';
import 'package:bargainb/view/widgets/size_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalSavedScreen extends StatelessWidget {
  const TotalSavedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Text("Total Saved",),
              16.ph,
              Row(
                children: [
                  Text("October Overview",),
                  Spacer(),
                  Text("Oct 1 - Oct. 31"),
                  5.pw,
                  Icon(Icons.calendar_month_outlined)
                ],
              ),
              Container(
                height: 230.h,
              ),
              16.ph,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x263463ED),
                      blurRadius: 28,
                      offset: Offset(0, 10),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text("Top Products Spent On"),
                    10.ph,
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: 2,
                      separatorBuilder: (ctx, i) => Divider(),
                      itemBuilder: (ctx, i) => Container(
                        width: 167.w,
                        child: Row(
                          children: [
                            Image.asset(avocado),
                            34.pw,
                            Column(
                              children: [
                                Text("Avocado"),
                                5.ph,
                                Text("Chocolate bar 5-pack"),
                                Row(
                                  children: [
                                    SizeContainer(itemSize: "1/2 KG"),
                                    5.pw,
                                    Text("€1.55",),
                                    5.pw,
                                    Text("€0.30 less"),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
                            Text("€1.25"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
