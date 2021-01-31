import 'package:flutter/material.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/helper/reusable_widget.dart';
import 'package:thingaha/model/student.dart';
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
      body: SingleChildScrollView(
        child: _buildStudentInfo(context),
      )
    );
  }

  Widget _buildStudentInfo(context) {
    //Get data from API
    Student student = getStudent();

    Widget photoWidget = Center(
      child: Container(
        width: 100.0,
        height: 100.0,
        child: Image.asset("images/ic_person.png"),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
          border: new Border.all(
            color: Colors.grey,
            width: 4.0,
          ),
        ),
      ),
    )
    ;

    return CustomCardView(
      cardView: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            photoWidget,
            SizedBox(height: 20.0),

            _buildInfo(txt_name, student.name),
            _buildInfo(txt_grade, student.grade),
            _buildInfo(txt_date_of_birth, student.dateOfBirth),
            _buildInfo(txt_school, student.school),
            _buildInfo(txt_parent, student.parent),
            _buildInfo(txt_parentOccupation, student.parentOccupation),
            _buildInfo(txt_address, student.address),

          ],
        ),
      ),
    )
    ;
  }

  Widget _buildInfo(title, text) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text("  :  ", style: TextStyle(fontSize: 16)),
          Expanded(
              child: Text(
                  text,
                  style: TextStyle(fontSize: 16)
              )
          )
        ],
      ),
    )
    ;
  }
  
  Student getStudent() {
    Student student = Student();
    student.name = "Mg Kyaw kyaw";
    student.grade = "7th Grade";
    student.dateOfBirth = "23 April 1997";
    student.school = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
    student.parent = "U Ba Zaw + Daw Nu Nu";
    student.parentOccupation = "General workers";
    student.address = "Nyaung Tone City";
    student.photoUrl = "";

    return student;
  }
}