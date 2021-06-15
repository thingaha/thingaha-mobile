import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/screen/home.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // Future.delayed(
    //     Duration(seconds: delay),
    //     () => Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => Login())));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isLoggedIn = ref(isLoggedInProvider.notifier);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          // executes after build
          checkAuth(isLoggedIn);
        });

        return child;
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Image.asset('images/logo.png'),
        ),
      ),
    );
  }

  checkAuth(isLoggedIn) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var accessToken = localStorage.getString(StaticStrings.keyAccessToken);

    if (accessToken == null || accessToken == "") {
      // Not Logged In
      isLoggedIn.setStatus(false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      isLoggedIn.setStatus(true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }
}
