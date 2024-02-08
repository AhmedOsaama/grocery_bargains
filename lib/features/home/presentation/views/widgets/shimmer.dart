import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../../utils/app_colors.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        List<Widget>.generate(
            20,
                (index) => Shimmer(
              duration: const Duration(seconds: 2),
              colorOpacity: 0.7,
              child: Container(
                height: 253.h,
                width: 174.w,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: purple10,
                ),
              ),
            )),
      ),
    );
  }
}
