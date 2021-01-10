import 'package:flutter/material.dart';
import 'package:thingaha/helper/reusable_widget.dart';
import 'package:thingaha/util/string_constants.dart';

class StudentInfo extends StatefulWidget {
  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableWidgets.getAppBar(txt_student_info),
      body: Center(
        child: Text(txt_student_info),
      ),
    );
  }

}