import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:thingaha/helper/custom_appbar.dart';
import 'package:thingaha/helper/student_ui.dart';

class HistoryPerYear extends StatefulWidget {
  final String historyYear;

  HistoryPerYear({Key key,@required this.historyYear}) :super(key:key);

  @override
  State<StatefulWidget> createState() => _HistoryPerYearState();
}

class _HistoryPerYearState extends State<HistoryPerYear> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            CustomAppBar(title: this.widget.historyYear + " - All Students"),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: 5,
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
