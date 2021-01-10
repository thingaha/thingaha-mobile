import 'package:flutter/material.dart';
import 'package:thingaha/helper/reusable_widget.dart';

class StudentPerYear extends StatefulWidget {
  @override
  _StudentPerYearState createState() => _StudentPerYearState();
}

class _StudentPerYearState extends State<StudentPerYear> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableWidgets.getAppBar("2020 - All Students"), // year name which was passed from all students year list
      body: Center(
        child: Text("2020 - All Students"),
      ),
    );
  }
  
}