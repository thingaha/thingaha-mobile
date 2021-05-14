// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  UserInfo({
    this.data,
  });

  Data data;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.user,
  });

  User user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}

class User {
  User({
    this.address,
    this.country,
    this.displayName,
    this.donationActive,
    this.email,
    this.formattedAddress,
    this.id,
    this.role,
    this.username,
  });

  Address address;
  String country;
  String displayName;
  bool donationActive;
  String email;
  String formattedAddress;
  int id;
  String role;
  String username;

  factory User.fromJson(Map<String, dynamic> json) => User(
        address: Address.fromJson(json["address"]),
        country: json["country"],
        displayName: json["display_name"],
        donationActive: json["donation_active"],
        email: json["email"],
        formattedAddress: json["formatted_address"],
        id: json["id"],
        role: json["role"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "country": country,
        "display_name": displayName,
        "donation_active": donationActive,
        "email": email,
        "formatted_address": formattedAddress,
        "id": id,
        "role": role,
        "username": username,
      };
}

class Address {
  Address({
    this.district,
    this.division,
    this.id,
    this.streetAddress,
    this.township,
    this.type,
  });

  String district;
  String division;
  int id;
  String streetAddress;
  String township;
  String type;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        district: json["district"],
        division: json["division"],
        id: json["id"],
        streetAddress: json["street_address"],
        township: json["township"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "district": district,
        "division": division,
        "id": id,
        "street_address": streetAddress,
        "township": township,
        "type": type,
      };
}
