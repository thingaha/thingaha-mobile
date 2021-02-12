import 'package:flutter/material.dart';
import 'package:thingaha/helper/custom_appbar.dart';
import 'package:thingaha/util/string_constants.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: txt_change_password), // year name which was passed from all students year list
      body: Center(
        child: Text(txt_change_password),
      ),
    );
  }

}