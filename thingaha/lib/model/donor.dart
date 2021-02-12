class Donor {
  String name;
  String email;
  String country;
  String address;

  Donor({this.name, this.email, this.country, this.address});

  Donor.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    country = json['country'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['country'] = this.country;
    data['address'] = this.address;
    return data;
  }
}