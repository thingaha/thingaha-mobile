import 'package:flutter/material.dart';
import 'package:thingaha/helper/reusable_widget.dart';
import 'package:thingaha/util/string_constants.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableWidgets.getAppBar(txt_profile),
      body: Center(
        child: Text(txt_profile),
      ),
    );
  }

}