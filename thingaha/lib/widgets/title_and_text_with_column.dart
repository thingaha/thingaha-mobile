import 'package:flutter/material.dart';

class TitleAndTextWithColumn extends StatelessWidget {
  final String title;
  final String text;

  TitleAndTextWithColumn({@required this.title, @required this.text});

  @override
  Widget build(BuildContext context) {
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

}