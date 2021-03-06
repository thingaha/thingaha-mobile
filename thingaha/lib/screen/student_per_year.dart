import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingaha/helper/custom_appbar.dart';
import 'package:thingaha/helper/student_ui.dart';

class StudentPerYear extends StatefulWidget {
  final String year;
  StudentPerYear({Key key,@required this.year}) :super(key:key);

  @override
  _StudentPerYearState createState() => _StudentPerYearState();
}

//TODO: Get data from API
List<String> students = ["stu1", "stu2", "stu3", "stu4","stu5"];

class _StudentPerYearState extends State<StudentPerYear> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: widget.year  + " - All Students"), // year name which was passed from all students year list
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return StudentUI();
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
