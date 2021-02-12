import 'package:flutter/material.dart';
import 'package:thingaha/util/style_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget actionButton;

  CustomAppBar({@required this.title, this.actionButton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      iconTheme: new IconThemeData(color: Colors.white), //drawer icon color
      leading: Builder(
          builder: (context) =>
              IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              )
      ),
      title: Container(
          child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
              )
          )
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}