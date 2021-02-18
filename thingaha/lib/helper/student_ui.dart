import 'package:flutter/material.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/helper/title_and_text_with_column.dart';
import 'package:thingaha/model/student.dart';
import 'package:thingaha/screen/student_info.dart';
import 'package:thingaha/util/string_constants.dart';

class StudentUI extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Student student = getStudent();

    Widget photoWidget = Center(
      child: Container(
        width: 90.0,
        height: 90.0,
        child: Image.asset(student.photoUrl),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
          border: new Border.all(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
      ),
    );

    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(10.0),
      child: CustomCardView(
        onPress: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => StudentInfo()));
        },
        cardView: Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              photoWidget,
              SizedBox(
                width: 25.0,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TitleAndTextWithColumn(title: txt_name, text: student.name),
                  TitleAndTextWithColumn(title: txt_grade, text: student.grade),
                ],
              ))
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
    student.photoUrl="images/ic_person.png";
    return student;
  }
}
