import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingaha/helper/custom_appbar.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/helper/title_and_text_with_column.dart';
import 'package:thingaha/model/student.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/screen/student_info.dart';

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
                      return _buildStudentUI(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildStudentUI(context) {
    Student student = getStudent();

    Widget photoWidget = Center(
      child: Container(
        width: 90.0,
        height: 90.0,
        child: Image.asset("images/ic_person.png"),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
          border: new Border.all(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.all(10.0),
      child: CustomCardView(
        onPress: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => StudentInfo()));
        },
        cardView: Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              photoWidget,
              SizedBox(width: 25.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TitleAndTextWithColumn(title: txt_name, text: student.name),
                    TitleAndTextWithColumn(title: txt_grade, text: student.grade),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Student getStudent() {
    Student student = Student();
    student.name = "Mg Zaw Zaw";
    student.grade = "7";
    return student;
  }
}
