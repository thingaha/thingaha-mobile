// To parse this JSON data, do
//
//     final donatorDonations = donatorDonationsFromJson(jsonString);

import 'dart:convert';

DonatorDonations donatorDonationsFromJson(String str) =>
    DonatorDonations.fromJson(json.decode(str));

String donatorDonationsToJson(DonatorDonations data) =>
    json.encode(data.toJson());

class DonatorDonations {
  DonatorDonations({
    this.data,
  });

  Data data;

  factory DonatorDonations.fromJson(Map<String, dynamic> json) =>
      DonatorDonations(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.currentPage,
    this.donations,
    this.nextPage,
    this.pages,
    this.prevPage,
    this.totalCount,
  });

  int currentPage;
  List<Donation> donations;
  dynamic nextPage;
  int pages;
  dynamic prevPage;
  int totalCount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        donations: List<Donation>.from(
            json["donations"].map((x) => Donation.fromJson(x))),
        nextPage: json["next_page"],
        pages: json["pages"],
        prevPage: json["prev_page"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "donations": List<dynamic>.from(donations.map((x) => x.toJson())),
        "next_page": nextPage,
        "pages": pages,
        "prev_page": prevPage,
        "total_count": totalCount,
      };
}

class Donation {
  Donation({
    this.attendanceId,
    this.id,
    this.jpyAmount,
    this.mmkAmount,
    this.month,
    this.paidAt,
    this.status,
    this.student,
    this.transferId,
    this.user,
    this.year,
  });

  int attendanceId;
  int id;
  double jpyAmount;
  double mmkAmount;
  String month;
  dynamic paidAt;
  String status;
  Student student;
  dynamic transferId;
  User user;
  int year;

  factory Donation.fromJson(Map<String, dynamic> json) => Donation(
        attendanceId: json["attendance_id"],
        id: json["id"],
        jpyAmount: json["jpy_amount"],
        mmkAmount: json["mmk_amount"],
        month: json["month"],
        paidAt: json["paid_at"],
        status: json["status"],
        student: Student.fromJson(json["student"]),
        transferId: json["transfer_id"],
        user: User.fromJson(json["user"]),
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "attendance_id": attendanceId,
        "id": id,
        "jpy_amount": jpyAmount,
        "mmk_amount": mmkAmount,
        "month": month,
        "paid_at": paidAt,
        "status": status,
        "student": student.toJson(),
        "transfer_id": transferId,
        "user": user.toJson(),
        "year": year,
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
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "district": district,
        "division": division,
        "id": id,
        "street_address": streetAddress,
        "township": township,
        "type": type == null ? null : type,
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
