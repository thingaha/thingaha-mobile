import 'package:flutter/material.dart';
import 'package:thingaha/helper/reusable_widget.dart';
import 'package:thingaha/util/string_constants.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableWidgets.getAppBar(txt_history),
      body: Center(
        child: Text(txt_history),
      ),
    );
  }

}