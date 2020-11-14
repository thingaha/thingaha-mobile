import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),  // onBackPress => exit the app
      child: Scaffold(
        body: Center(
          child: MaterialButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            },
            child: Text("Click me!"),
          ),
        ),
      )
    );
  }
}
