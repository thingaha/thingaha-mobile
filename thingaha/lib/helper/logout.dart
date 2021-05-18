import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/screen/login.dart';
import 'package:thingaha/util/keys.dart';
import 'package:thingaha/util/string_constants.dart';

logout() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.setString(StaticStrings.keyAccessToken, "");
  localStorage.setBool(StaticStrings.keyLogInStatus, false);
  localStorage.setInt(StaticStrings.keyUserID, 0);

  navKey.currentState
      .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
}
