// To parse this JSON data, do
//
//     final students = studentsFromJson(jsonString);

import 'dart:convert';

Students studentsFromJson(String str) => Students.fromJson(json.decode(str));

String studentsToJson(Students data) => json.encode(data.toJson());

class Students {
  Students({
    this.data,
  });

  Data data;

  factory Students.fromJson(Map<String, dynamic> json) => Students(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.currentPage,
    this.nextPage,
    this.pages,
    this.prevPage,
    this.students,
    this.totalCount,
  });

  int currentPage;
  int nextPage;
  int pages;
  dynamic prevPage;
  List<Student> students;
  int totalCount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        pages: json["pages"],
        prevPage: json["prev_page"],
        students: List<Student>.from(
            json["students"].map((x) => Student.fromJson(x))),
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "next_page": nextPage,
        "pages": pages,
        "prev_page": prevPage,
        "students": List<dynamic>.from(students.map((x) => x.toJson())),
        "total_count": totalCount,
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
    this.photo,
  });

  Address address;
  String birthDate;
  String deactivatedAt;
  String fatherName;
  int id;
  String motherName;
  String name;
  String parentsOccupation;
  String photo;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        address: Address.fromJson(json["address"]),
        birthDate: json["birth_date"] == null ? null : json["birth_date"],
        deactivatedAt:
            json["deactivated_at"] == null ? null : json["deactivated_at"],
        fatherName: json["father_name"],
        id: json["id"],
        motherName: json["mother_name"],
        name: json["name"],
        parentsOccupation: json["parents_occupation"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "birth_date": birthDate == null ? null : birthDate,
        "deactivated_at": deactivatedAt == null ? null : deactivatedAt,
        "father_name": fatherName,
        "id": id,
        "mother_name": motherName,
        "name": name,
        "parents_occupation": parentsOccupation,
        "photo": photo,
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

class StudentByYear {
  final int id;
  final int year;

  StudentByYear({this.id, this.year});

  @override
  String toString() {
    return '{$id, $year}';
  }
}
