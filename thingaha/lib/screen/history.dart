import 'package:flutter/material.dart';
import 'package:thingaha/helper/custom_appbar.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/screen/student_per_year.dart';
import 'package:thingaha/util/string_constants.dart';

//TODO: Get data from API
List<String> years = ["2017", "2018", "2019", "2020"];

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: txt_history),
      body: ListView.builder(
          itemCount: years.length,
          itemBuilder: (context, index) {
            return _buildYearWidget(years[index]);
          }
      )
    );
  }

  Widget _buildYearWidget(year) {
    return CustomCardView(
      onPress: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => StudentPerYear()));
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