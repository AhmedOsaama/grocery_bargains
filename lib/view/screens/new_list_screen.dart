import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swaav/view/components/generic_menu.dart';
import 'package:swaav/view/components/my_scaffold.dart';
import 'package:swaav/view/components/plus_button.dart';
import 'package:swaav/view/widgets/backbutton.dart';
class NewListScreen extends StatefulWidget {
  const NewListScreen({Key? key}) : super(key: key);

  @override
  State<NewListScreen> createState() => _NewListScreenState();
}

class _NewListScreenState extends State<NewListScreen> {
  bool isAddingItem = false;
  bool isChoosingCategory = false;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body:
    Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: Column(
      children: [
        SizedBox(height: 62.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyBackButton(),
            Spacer(),
            Container(
              width: 200.w,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)
                    )
                  ),
                )),
            Spacer(),
          ],
        ),
        Spacer(),
        if(!isAddingItem) PlusButton(onTap: (){
          setState(() {
            isAddingItem = true;
          });
        }),
        if(isAddingItem && !isChoosingCategory)
          GenericMenu(margin: 10.w,option1Text: "Add item", option2Text: "Categories", option1Func: (){}, option2Func: (){
            setState(() {
              isChoosingCategory = true;
            });
          }),
        if(isChoosingCategory)
          Row(
            children: [
              MyBackButton(
                onTap: (){
                  setState(() {
                    isChoosingCategory = false;
                  });
                },
              ),
              SizedBox(width: 10.w,),
              Expanded(
                child: GenericMenu(margin: 0.w,option1Text: "Grocery", option2Text: "Clothing", option1Func: (){
                  //goto grocery tab
                }, option2Func: (){
                  //goto clothing tab
                }),
              ),
            ],
          )
      ],
    ),
    )
    );
  }
}
