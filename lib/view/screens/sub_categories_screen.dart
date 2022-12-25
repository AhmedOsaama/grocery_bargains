import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swaav/config/routes/app_navigator.dart';
import 'package:swaav/utils/fonts_utils.dart';
import 'package:swaav/utils/style_utils.dart';
import 'package:swaav/view/components/button.dart';
import 'package:swaav/view/components/my_scaffold.dart';
import 'package:swaav/view/screens/category_items_screen.dart';

import '../widgets/backbutton.dart';

class SubCategoriesScreen extends StatelessWidget {
  final List<String> subCategories;
  final String listId;
  final String listName;
  const SubCategoriesScreen({Key? key, required this.subCategories, required this.listId, required this.listName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 62.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyBackButton(),
                Spacer(),
                Container(
                    width: 200.w,
                    child: Text(listName,style: TextStyles.textViewMedium20.copyWith(color: Color.fromRGBO(61, 62, 59, 1)),)),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GenericButton(
                onPressed: () {},
                child: Text(
                  "Filter",
                  style: TextStyles.textViewBold15,
                ),
                borderRadius: BorderRadius.circular(6),
                width: 95.w,
                height: 35.h,
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 22,
                    crossAxisSpacing: 13,
                    childAspectRatio: 158 / 122),
                children: subCategories
                    .map((category) => GestureDetector(
                          onTap: () => AppNavigator.push(
                              context: context, screen: CategoryItemsScreen(listId: listId,)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(217, 217, 217, 1),
                                borderRadius: BorderRadius.circular(7)),
                            child: Center(
                                child: Text(
                              category,
                              textAlign: TextAlign.center,
                              style: TextStyles.textViewBold20.copyWith(
                                  color: Color.fromRGBO(122, 122, 122, 1)),
                            )),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
