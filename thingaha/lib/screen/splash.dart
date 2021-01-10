import 'dart:async';
import 'package:flutter/material.dart';

import 'login.dart';

const delay = 1;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    /* Show logo for 1 seconds and go to login page */
    Future.delayed(
        Duration(seconds: delay),
            () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login())
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Image.asset(
          'images/logo.png'
        ),
      ),
    );
  }
}
