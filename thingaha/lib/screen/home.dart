import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingaha/helper/custom_carousel.dart';
import 'package:thingaha/model/student_donation_status.dart';
import 'package:thingaha/helper/drawer_item.dart';
import 'package:thingaha/screen/all_students.dart';
import 'package:thingaha/screen/history.dart';
import 'package:thingaha/screen/profile.dart';
import 'package:thingaha/util/constants.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';
import 'package:thingaha/helper/monthly_status.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _screenIndex = 0;
  var screens = [
    Container(),
    AllStudents(),
    History(),
    Profile(),
  ];

  var titles = [
    APP_NAME,
    txt_all_students,
    txt_history,
    txt_profile,
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemChannels.platform
          .invokeMethod('SystemNavigator.pop'), // onBackPress => exit the app
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[_screenIndex],
              style: TextStyle(
                color: (_screenIndex == 0) ? kPrimaryColor : Colors.black,
                fontFamily: (_screenIndex == 0)
                    ? GoogleFonts.pacifico().fontFamily
                    : GoogleFonts.lato().fontFamily,
              )),
          iconTheme: new IconThemeData(color: Colors.white),
          leading: Builder(
              builder: (context) => IconButton(
                    icon: new Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  )),
        ),
        drawer: _buildDrawerLayout(),
        bottomNavigationBar: _bottomNavigationBar(),
        body: (_screenIndex == 0)
            ? SingleChildScrollView(
                // TODO: Completely Redesign this screen. -_-
                child: _buildCarousel(),
              )
            : screens[_screenIndex],
      ),
    );
  }

  Widget _buildCarousel() {
    //Get data from api
    List<StudentDonationStatus> studentDonationStatusList =
        getStudentDonationStatusList();

    //Create carousel widgets
    List<Widget> carouselItems = studentDonationStatusList
        .map((item) => MonthlyStatus(studentStatus: item))
        .toList();
    return CustomCarousel(items: carouselItems);
  }

  List<StudentDonationStatus> getStudentDonationStatusList() {
    DonationStatus month1 = DonationStatus();
    month1.month = "March";
    month1.amount = "35,000";
    month1.date = "-";
    month1.donated = "Not yet";
    month1.status = false;

    DonationStatus month2 = DonationStatus();
    month2.month = "February";
    month2.amount = "35,000";
    month2.date = "2 Feb 2021";
    month2.donated = "Donated";
    month2.status = true;

    DonationStatus month3 = DonationStatus();
    month3.month = "January";
    month3.amount = "35,000";
    month3.date = "1 Feb 2021";
    month3.donated = "Donated";
    month3.status = true;

    DonationStatus month4 = DonationStatus();
    month4.month = "December";
    month4.amount = "35,000";
    month4.date = "2 Dec 2020";
    month4.donated = "Donated";
    month4.status = true;

    DonationStatus month5 = DonationStatus();
    month5.month = "November";
    month5.amount = "35,000";
    month5.date = "1 Nov 2020";
    month5.donated = "Donated";
    month5.status = true;

    StudentDonationStatus student1 = StudentDonationStatus();
    student1.name = "Kyaw Kyaw";
    student1.grade = "7th Grade";
    student1.dateOfBirth = "23 April 1997";
    student1.donationStatus = [month1, month2, month3, month4, month5];
    student1.profileUrl =
        "https://i.pinimg.com/originals/a7/65/45/a7654580f501e9501e329978bebd051b.jpg";

    StudentDonationStatus student2 = StudentDonationStatus();
    student2.name = "Su Nandar";
    student2.grade = "3rd Grade";
    student2.dateOfBirth = "3 June 2015";
    student2.donationStatus = [month2, month3];
    student2.profileUrl =
        "https://i.pinimg.com/originals/a7/65/45/a7654580f501e9501e329978bebd051b.jpg";

    List<StudentDonationStatus> studentList = [student1, student2];
    return studentList;
  }

  Widget _buildDrawerLayout() {
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _buildDrawerHeader(),
            DrawerItem(title: txt_my_student, route: null),
            DrawerItem(title: txt_all_students, route: AllStudents()),
            DrawerItem(title: txt_history, route: History()),
            DrawerItem(title: txt_profile, route: Profile()),
            DrawerItem(title: txt_logout, route: null),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            txt_welcome,
            style: GoogleFonts.lobster(
                textStyle: TextStyle(color: Colors.white, fontSize: 50)),
          )
        ],
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [kPrimaryColor, Colors.lightGreen])),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomAppBar(
      child: Container(
        height: 56, //Bottom AppBar Height is 56 ... as per material guideline.
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // this places icons evenly across the screen.
          children: [
            // My Student Tab Icon.
            IconButton(
                icon: Icon(
                  // This changes icon from outlined to filled when user selected the tab.
                  (_screenIndex == 0)
                      ? Icons.home_rounded
                      : Icons.home_outlined,
                  // This changes the icon color when user selected the tab.
                  color: (_screenIndex == 0) ? kPrimaryColor : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _screenIndex = 0;
                  });
                }),

            // All Students Tab Icon.
            IconButton(
                icon: Icon(
                  (_screenIndex == 1)
                      ? Icons.people_alt_rounded
                      : Icons.people_alt_outlined,
                  color: (_screenIndex == 1) ? kPrimaryColor : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _screenIndex = 1;
                  });
                }),

            // History Tab Icon
            IconButton(
                icon: Icon(
                  (_screenIndex == 2)
                      ? Icons.history_edu_rounded
                      : Icons.history_edu_outlined,
                  color: (_screenIndex == 2) ? kPrimaryColor : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _screenIndex = 2;
                  });
                }),

            // Profile Tab Icon
            IconButton(
              icon: Icon(
                (_screenIndex == 3)
                    ? Icons.person_pin_circle_rounded
                    : Icons.person_pin_circle_outlined,
                color: (_screenIndex == 3) ? kPrimaryColor : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _screenIndex = 3;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
