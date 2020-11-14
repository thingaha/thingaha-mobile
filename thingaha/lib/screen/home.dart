import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thingaha/util/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),  // onBackPress => exit the app
      child: Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
          leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
          ),
        ),
        body: Center(
          child: Text('Welcome'),
        ),
      ),
    );
  }
}
