import 'package:flutter/material.dart';
import 'package:thingaha/screen/splash.dart';
import 'package:thingaha/util/constants.dart';
import 'package:thingaha/util/style_constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primaryColor: kPrimaryColor
      ),
      home: Splash()
    );
  }
}
