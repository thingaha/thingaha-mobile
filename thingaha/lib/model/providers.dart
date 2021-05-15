import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/model/userinfo.dart';
import 'package:thingaha/util/api_strings.dart';
import 'package:thingaha/util/network.dart';
import 'package:thingaha/util/string_constants.dart';

final userIDProvider = StateNotifierProvider((_) => UserIDState());

class UserIDState extends StateNotifier<int> {
  UserIDState() : super(0);

  void setID(int value) => state = value;
}

final fetchDisplayNamefromLocalProvider = FutureProvider<String>((ref) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();

  var name = localStorage.getString(StaticStrings.keyDisplayName);

  return name;
});

final fetchUserDetail = FutureProvider<UserInfo>((ref) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  int userID = localStorage.getInt(StaticStrings.keyUserID);
  var userInfoResponse = await Network().getData("${APIs.getUserByID}$userID");
  var body = json.decode(utf8.decode(userInfoResponse.bodyBytes));
  print(utf8.decode(userInfoResponse.bodyBytes));

  var displayName = body['data']['user']['display_name'];
  localStorage.setString(StaticStrings.keyDisplayName, displayName);

  final userInfo = userInfoFromJson(utf8.decode(userInfoResponse.bodyBytes));

  return userInfo;
});