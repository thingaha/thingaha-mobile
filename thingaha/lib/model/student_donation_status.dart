class StudentDonationStatus {
  String name;
  String grade;
  String dateOfBirth;
  String profileUrl;
  List<DonationStatus> donationStatus;

  StudentDonationStatus({
    this.name,
    this.grade,
    this.dateOfBirth,
    this.profileUrl,
    this.donationStatus,
  });

  StudentDonationStatus.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    grade = json['grade'];
    dateOfBirth = json['date_of_birth'];
    profileUrl = json['photo'];
    if (json['donation_status'] != null) {
      donationStatus = new List<DonationStatus>();
      json['donation_status'].forEach((v) {
        donationStatus.add(new DonationStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['grade'] = this.grade;
    data['date_of_birth'] = this.dateOfBirth;
    data['photo'] = this.profileUrl;
    if (this.donationStatus != null) {
      data['donation_status'] =
          this.donationStatus.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DonationStatus {
  String month;
  String amount;
  String date;
  String donated;
  bool status;

  DonationStatus(
      {this.month, this.amount, this.date, this.donated, this.status});

  DonationStatus.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    amount = json['amount'];
    date = json['date'];
    donated = json['donated'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['donated'] = this.donated;
    data['status'] = this.status;
    return data;
  }
}
