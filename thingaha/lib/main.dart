import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thingaha/screen/splash.dart';
import 'package:thingaha/util/constants.dart';
import 'package:thingaha/util/keys.dart';
import 'package:thingaha/util/style_constants.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navKey,
        title: APP_NAME,
        theme: ThemeData(
            primaryColor: kPrimaryColor,
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(color: kPrimaryColor))),
        home: Splash());
  }
}
