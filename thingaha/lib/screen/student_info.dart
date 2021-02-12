import 'package:flutter/material.dart';
import 'package:thingaha/helper/custom_appbar.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/helper/title_and_text_with_column.dart';
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
      appBar: CustomAppBar(title: txt_student_info),
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

    return Container(
      margin: EdgeInsets.all(10.0),
      child: CustomCardView(
        cardView: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              photoWidget,
              SizedBox(height: 20.0),

              TitleAndTextWithColumn(title: txt_name, text: student.name),
              TitleAndTextWithColumn(title: txt_grade, text: student.grade),
              TitleAndTextWithColumn(title: txt_date_of_birth, text: student.dateOfBirth),
              TitleAndTextWithColumn(title: txt_school, text: student.school),
              TitleAndTextWithColumn(title: txt_parent, text: student.parent),
              TitleAndTextWithColumn(title: txt_parentOccupation, text: student.parentOccupation),
              TitleAndTextWithColumn(title: txt_address, text: student.address),

            ],
          ),
        ),
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