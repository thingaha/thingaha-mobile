class APIs {
  static var defaultAPIurl = 'https://app.thingaha.org/api/v1/';

  // POST
  // {
  //   "email_or_username": "moemoe@gmail.com",
  //   "password": "123"
  // }
  static var loginURL = 'login';
  // Output Sample
  // {
  //   "access_token": "eyJ0eXAiOXXXXX",
  //   "user": {
  //     "id": 1,
  //     "email": "moemoe@gmail.com",
  //     "username": "Moe Moe"
  //   }
  // }

  static var getDonationListByID = 'donations/'; // Donation by ID.
  static var getUserByID = 'users/';
  static var getDonatorDonations = "donator_donations";
  static var getAttendance = 'attendances';
  static var getAttendancebyPage = 'attendances?page=';
  static var getAllStudents = 'students';
  static var getStudentsByPage = 'students?page=';
  static var getAllSchools = 'schools';
  static var getSchoolsByPage = 'schools?page=';
}
