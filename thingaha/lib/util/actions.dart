import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/screen/login.dart';
import 'package:thingaha/util/keys.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';

setAppTheme(context, appTheme, appThemeSelection, ThemeMode result,
    bool isThemeChooser) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var themeString;

  if (result == ThemeMode.light) {
    themeString = StaticStrings.themeLight;

    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   //statusBarBrightness: Brightness.dark,
    //   systemNavigationBarColor: Color(0xfff7f7f7),
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.light,
    //   systemNavigationBarIconBrightness: Brightness.dark,
    // ));
  } else if (result == ThemeMode.dark) {
    themeString = StaticStrings.themeDark;
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   //statusBarBrightness: Brightness.dark,
    //   systemNavigationBarColor: Color(0xff0e0d0f),
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.light,
    //   systemNavigationBarIconBrightness: Brightness.light,
    // ));
  } else if (result == ThemeMode.system) {
    themeString = StaticStrings.themeSystem;
  }
  localStorage.setString(StaticStrings.keyAppTheme, themeString);
  appThemeSelection.setTheme(result);
  if (isThemeChooser) {
    print("previous theme is $appTheme and updated theme is $result");

    Future.delayed(const Duration(milliseconds: 500), () {
      SetStatusBarAndNavBarColor().themeChooser(context, result);
    });
  } else
    SetStatusBarAndNavBarColor().mainUI(context, result);
}

logoutFromBottomSheet(context, rootcontext, appTheme, navKey) async {
  // print("This works");
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.setString(StaticStrings.keyAccessToken, "");
  localStorage.setBool(StaticStrings.keyLogInStatus, false);
  localStorage.setInt(StaticStrings.keyUserID, 0);

  Navigator.of(rootcontext).popUntil((route) => route.isFirst);
  navKey.currentState.pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => Login()));
  SetStatusBarAndNavBarColor().mainUI(context, appTheme);
}

logoutNormally() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.setString(StaticStrings.keyAccessToken, "");
  localStorage.setBool(StaticStrings.keyLogInStatus, false);
  localStorage.setInt(StaticStrings.keyUserID, 0);

  navKey.currentState
      .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
}
