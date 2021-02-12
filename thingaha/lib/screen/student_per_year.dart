import 'package:flutter/material.dart';
import 'package:thingaha/helper/custom_appbar.dart';

class StudentPerYear extends StatefulWidget {
  @override
  _StudentPerYearState createState() => _StudentPerYearState();
}

class _StudentPerYearState extends State<StudentPerYear> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "2020 - All Students"), // year name which was passed from all students year list
      body: Center(
        child: Text("2020 - All Students"),
      ),
    );
  }
  
}