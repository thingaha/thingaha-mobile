import 'package:flutter/material.dart';
import 'package:thingaha/helper/reusable_widget.dart';
import 'package:thingaha/screen/student_per_year.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';

class AllStudents extends StatefulWidget {
  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableWidgets.getAppBar(txt_all_students),
      body: Center(
        child: MaterialButton(
          child: Text("Go to Student per year"),
          color: kPrimaryColor,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => StudentPerYear()));
          },
        ),
      ),
    );
  }

}