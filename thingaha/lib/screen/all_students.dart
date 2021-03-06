import 'package:flutter/material.dart';
import 'package:thingaha/helper/custom_appbar.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/screen/student_per_year.dart';
import 'package:thingaha/util/string_constants.dart';

//TODO: Get data from API
List<String> years = ["2017", "2018", "2019", "2020"];

class AllStudents extends StatefulWidget {
  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: txt_all_students),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: years.length,
          itemBuilder: (context, index) {
            return _buildYearWidget(years[index]);
          }
        ),
      )
    );
  }

  Widget _buildYearWidget(year) {
    return CustomCardView(
      onPress: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => StudentPerYear(year: year)));
      },
      cardView: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            Text(year, style: TextStyle(fontSize: 16.0)),
            new Spacer(),
            Icon(Icons.navigate_next, color: Colors.black54)
          ],
        ),
      ),
    )
    ;
  }
}