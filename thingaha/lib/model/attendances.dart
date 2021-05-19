// To parse this JSON data, do
//
//     final attendance = attendanceFromJson(jsonString);

import 'dart:convert';

Attendance attendanceFromJson(String str) =>
    Attendance.fromJson(json.decode(str));

String attendanceToJson(Attendance data) => json.encode(data.toJson());

class Attendance {
  Attendance({
    this.data,
  });

  Data data;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.attendances,
    this.currentPage,
    this.nextPage,
    this.pages,
    this.prevPage,
    this.totalCount,
  });

  List<AttendanceElement> attendances;
  int currentPage;
  dynamic nextPage;
  int pages;
  dynamic prevPage;
  int totalCount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        attendances: List<AttendanceElement>.from(
            json["attendances"].map((x) => AttendanceElement.fromJson(x))),
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        pages: json["pages"],
        prevPage: json["prev_page"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "attendances": List<dynamic>.from(attendances.map((x) => x.toJson())),
        "current_page": currentPage,
        "next_page": nextPage,
        "pages": pages,
        "prev_page": prevPage,
        "total_count": totalCount,
      };
}

class AttendanceElement {
  AttendanceElement({
    this.enrolledDate,
    this.grade,
    this.id,
    this.school,
    this.student,
    this.year,
  });

  String enrolledDate;
  String grade;
  int id;
  School school;
  Student student;
  int year;

  factory AttendanceElement.fromJson(Map<String, dynamic> json) =>
      AttendanceElement(
        enrolledDate: json["enrolled_date"],
        grade: json["grade"],
        id: json["id"],
        school: School.fromJson(json["school"]),
        student: Student.fromJson(json["student"]),
        year: json["year"] ?? 0000,
      );

  Map<String, dynamic> toJson() => {
        "enrolled_date": enrolledDate,
        "grade": grade,
        "id": id,
        "school": school.toJson(),
        "student": student.toJson(),
        "year": year,
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

class Student {
  Student({
    this.address,
    this.birthDate,
    this.deactivatedAt,
    this.fatherName,
    this.id,
    this.motherName,
    this.name,
    this.parentsOccupation,
  });

  Address address;
  String birthDate;
  String deactivatedAt;
  String fatherName;
  int id;
  String motherName;
  String name;
  String parentsOccupation;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        address: Address.fromJson(json["address"]),
        birthDate: json["birth_date"],
        deactivatedAt: json["deactivated_at"],
        fatherName: json["father_name"],
        id: json["id"],
        motherName: json["mother_name"],
        name: json["name"],
        parentsOccupation: json["parents_occupation"],
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "birth_date": birthDate,
        "deactivated_at": deactivatedAt,
        "father_name": fatherName,
        "id": id,
        "mother_name": motherName,
        "name": name,
        "parents_occupation": parentsOccupation,
      };
}
