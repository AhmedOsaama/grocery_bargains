import 'package:flutter/material.dart';

import 'search_widget.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  const SearchAppBar({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      foregroundColor: Colors.black,
      elevation: 0,
      // leading: null,
      // leadingWidth: 0,
      title: SearchWidget(searchController: controller,),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
