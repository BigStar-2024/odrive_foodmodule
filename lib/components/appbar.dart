import 'package:flutter/material.dart';

import '../themes/theme.dart';

/*
*  MyAppBar
* */
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  MyAppBar({required this.titleText});
  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 3,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          // Action à effectuer lorsqu'on appuie sur la flèche de retour
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.headlineSmall
      ),
    );
  }
}