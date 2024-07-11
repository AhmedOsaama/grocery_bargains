import 'package:flutter/material.dart';

import 'search_widget.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackButton;
  const SearchAppBar({Key? key, required this.isBackButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      foregroundColor: Colors.white,
      elevation: 0,
      // leading: Icon(Icons.abc_sharp,color: Colors.black,),
      leading: null,
      leadingWidth: 0,
      title: SearchWidget(isBackButton: isBackButton,),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
