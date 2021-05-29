// To parse this JSON data, do
//
//     final schools = schoolsFromJson(jsonString);

import 'dart:convert';

Schools schoolsFromJson(String str) => Schools.fromJson(json.decode(str));

String schoolsToJson(Schools data) => json.encode(data.toJson());

class Schools {
  Schools({
    this.data,
  });

  Data data;

  factory Schools.fromJson(Map<String, dynamic> json) => Schools(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.totalCount,
    this.currentPage,
    this.nextPage,
    this.pages,
    this.prevPage,
    this.schools,
  });

  int totalCount;
  int currentPage;
  dynamic nextPage;
  int pages;
  dynamic prevPage;
  List<School> schools;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalCount: json["total_count"],
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        pages: json["pages"],
        prevPage: json["prev_page"],
        schools:
            List<School>.from(json["schools"].map((x) => School.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "current_page": currentPage,
        "next_page": nextPage,
        "pages": pages,
        "prev_page": prevPage,
        "schools": List<dynamic>.from(schools.map((x) => x.toJson())),
      };
}

class School {
  School({
    this.address,
    this.contactInfo,
    this.id,
    this.name,
  });

  Address address;
  String contactInfo;
  int id;
  String name;

  factory School.fromJson(Map<String, dynamic> json) => School(
        address: Address.fromJson(json["address"]),
        contactInfo: json["contact_info"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "contact_info": contactInfo,
        "id": id,
        "name": name,
      };
}

class Address {
  Address({
    this.district,
    this.division,
    this.id,
    this.streetAddress,
    this.township,
  });

  String district;
  String division;
  int id;
  String streetAddress;
  String township;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        district: json["district"],
        division: json["division"],
        id: json["id"],
        streetAddress: json["street_address"],
        township: json["township"],
      );

  Map<String, dynamic> toJson() => {
        "district": district,
        "division": division,
        "id": id,
        "street_address": streetAddress,
        "township": township,
      };
}
