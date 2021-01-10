import 'package:flutter/material.dart';
import 'package:thingaha/util/style_constants.dart';

class ReusableWidgets {

  static getAppBar(String title) {
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

  static Widget getDivider() {
    return Divider(height: 1);
  }
}