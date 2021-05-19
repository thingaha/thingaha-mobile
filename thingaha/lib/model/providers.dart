import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/helper/logout.dart';
import 'package:thingaha/model/attendances.dart';
import 'package:thingaha/model/donatordonations.dart';
import 'package:thingaha/model/userinfo.dart';
import 'package:thingaha/screen/login.dart';
import 'package:thingaha/screen/profile.dart';
import 'package:thingaha/util/api_strings.dart';
import 'package:thingaha/util/keys.dart';
import 'package:thingaha/util/network.dart';
import 'package:thingaha/util/string_constants.dart';
import 'student.dart' as std;

final isLoggedInProvider = StateNotifierProvider((ref) => LoggedInState());

class LoggedInState extends StateNotifier<bool> {
  LoggedInState() : super(false);

  void setStatus(bool value) => state = value;
}

// ------------------------------------------------------

final userIDProvider = StateNotifierProvider((_) => UserIDState());

class UserIDState extends StateNotifier<int> {
  UserIDState() : super(0);

  void setID(int value) => state = value;
}

// -------------------------------------------------------

final fetchDisplayNamefromLocalProvider = FutureProvider<String>((ref) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();

  var name = localStorage.getString(StaticStrings.keyDisplayName);

  return name;
});

// API calls ------------------------------------------

final fetchUserDetail = FutureProvider.autoDispose<UserInfo>((ref) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  int userID = localStorage.getInt(StaticStrings.keyUserID);
  var userInfoResponse = await Network().getData("${APIs.getUserByID}$userID");
  var body = json.decode(utf8.decode(userInfoResponse.bodyBytes));
  //print(utf8.decode(userInfoResponse.bodyBytes));
  ref.maintainState = true;
  var displayName = body['data']['user']['display_name'];
  localStorage.setString(StaticStrings.keyDisplayName, displayName);

  final userInfo = userInfoFromJson(utf8.decode(userInfoResponse.bodyBytes));

  return userInfo;
});

final fetchDonationList =
    FutureProvider.autoDispose<DonatorDonations>((ref) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  // int userID = localStorage.getInt(StaticStrings.keyUserID);
  var donatorDonationsResponse =
      await Network().getData(APIs.getDonatorDonations);
  //print(utf8.decode(donatorDonationsResponse.bodyBytes));
  var body = json.decode(utf8.decode(donatorDonationsResponse.bodyBytes));
  if (body['msg'] == "Token has expired") {
    logout();
  }

  final donatorDonations =
      donatorDonationsFromJson(utf8.decode(donatorDonationsResponse.bodyBytes));

  return donatorDonations;
});

final fetchAttendanceList = FutureProvider.autoDispose<Attendance>((ref) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  // int userID = localStorage.getInt(StaticStrings.keyUserID);
  var attendanceResponse = await Network().getData(APIs.getAttendance);
  ref.maintainState = true;
  print(utf8.decode(attendanceResponse.bodyBytes));
  var body = json.decode(utf8.decode(attendanceResponse.bodyBytes));

  if (body['msg'] == "Token has expired") {
    logout();
  }

  final attendance =
      attendanceFromJson(utf8.decode(attendanceResponse.bodyBytes));

  return attendance;
});

final attendancePageCount = FutureProvider<int>((ref) async {
  var attendanceResponse = await Network().getData(APIs.getAttendance);
  var body = json.decode(utf8.decode(attendanceResponse.bodyBytes));
  var pages = 0;
  if (body['msg'] == "Token has expired") {
    logout();
  } else {
    pages = body['data']['pages'];
    //print(pages);
  }
  return pages;
});

final attendancePage = FutureProvider.family<Attendance, int>((ref, id) async {
  var attendanceResponse =
      await Network().getData("${APIs.getAttendancebyPage}${id + 1}");
  //print("${APIs.getAttendancebyPage}${id + 1}");
  //print(attendanceResponse.body);
  var body = json.decode(utf8.decode(attendanceResponse.bodyBytes));
  //print(body);
  if (body['msg'] == "Token has expired") {
    logout();
  }

  return attendanceFromJson(utf8.decode(attendanceResponse.bodyBytes));
});

final studentPageCount = FutureProvider<int>((ref) async {
  var response = await Network().getData(APIs.getAllStudents);
  var body = json.decode(utf8.decode(response.bodyBytes));
  //print(utf8.decode(response.bodyBytes));
  var pages = 0;
  if (body['msg'] == "Token has expired") {
    logout();
  } else {
    pages = body['data']['pages'];
    //print(pages);
  }
  return pages;
});

final studentPage = FutureProvider.family<std.Students, int>((ref, id) async {
  var response = await Network().getData("${APIs.getStudentsByPage}${id + 1}");
  //print(attendanceResponse.body);
  var body = json.decode(utf8.decode(response.bodyBytes));
  //print(body);
  if (body['msg'] == "Token has expired") {
    logout();
  }

  return std.studentsFromJson(utf8.decode(response.bodyBytes));
});
