class Student {
  String name;
  String grade;
  String dateOfBirth;
  String school;
  String parent;
  String parentOccupation;
  String address;
  String photoUrl;

  Student(
      {this.name,
        this.grade,
        this.dateOfBirth,
        this.school,
        this.parent,
        this.parentOccupation,
        this.address,
        this.photoUrl});

  Student.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    grade = json['grade'];
    dateOfBirth = json['date_of_birth'];
    school = json['school'];
    parent = json['parent'];
    parentOccupation = json['parent_occupation'];
    address = json['address'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['grade'] = this.grade;
    data['date_of_birth'] = this.dateOfBirth;
    data['school'] = this.school;
    data['parent'] = this.parent;
    data['parent_occupation'] = this.parentOccupation;
    data['address'] = this.address;
    data['photo_url'] = this.photoUrl;
    return data;
  }
}