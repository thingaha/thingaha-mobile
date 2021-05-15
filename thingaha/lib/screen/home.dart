import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/helper/custom_carousel.dart';
import 'package:thingaha/helper/slivertabs.dart';
import 'package:thingaha/model/donatordonations.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/model/student_donation_status.dart';
import 'package:thingaha/helper/drawer_item.dart';
import 'package:thingaha/screen/all_students.dart';
import 'package:thingaha/screen/history.dart';
import 'package:thingaha/screen/profile.dart';
import 'package:thingaha/util/api_strings.dart';
import 'package:thingaha/util/constants.dart';
import 'package:thingaha/util/network.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';
import 'package:thingaha/helper/monthly_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _screenIndex = 0;
  String displayName = "";
  int _selectedTabIndex = 0;
  var screens = [
    Container(),
    AllStudents(),
    History(),
    Profile(),
  ];

  var titles = [
    txt_donations,
    txt_all_students,
    txt_history,
    txt_settings,
  ];

  ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read(fetchDisplayNamefromLocalProvider);
    context.read(fetchDonationList);
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        AsyncValue<DonatorDonations> donatorDonations =
            watch(fetchDonationList);

        if (donatorDonations != null) {
          return donatorDonations?.when(
              loading: () => Scaffold(
                  body: Center(child: const CircularProgressIndicator())),
              error: (err, stack) => Text('Error: $err'),
              data: (donatorDonations) {
                List<Donation> donations = donatorDonations.data.donations;
                var studentListInfo = groupBy(donations, (e) {
                  return e.student.name;
                });
                var studentItem = [];
                var studentNameList = studentListInfo.keys.toList();
                studentListInfo.keys.forEach((key) {
                  studentItem = donations
                      .where((data) => data.student.name == key)
                      .toList();
                });
                List.generate(studentItem.length,
                    (index) => print(studentItem[index].student.name));
                return DefaultTabController(
                    length: studentNameList.length,
                    child: Builder(
                      builder: (BuildContext context) {
                        return Scaffold(
                            backgroundColor: Colors.white,
                            //drawer: _buildDrawerLayout(),
                            bottomNavigationBar: _bottomNavigationBar(),
                            body: NestedScrollView(
                              controller: _scrollController,
                              headerSliverBuilder: (context, value) {
                                return [
                                  SliverAppBar(
                                      pinned: true,
                                      expandedHeight: 100,
                                      title: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        opacity: _isScrolled ? 1.0 : 0.0,
                                        curve: Curves.ease,
                                        child: Text(titles[_screenIndex],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  GoogleFonts.lato().fontFamily,
                                            )),
                                      ),
                                      automaticallyImplyLeading: false,
                                      // elevation: (_isScrolled) ? 1.5 : 0,
                                      elevation: 0,
                                      flexibleSpace: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        opacity: _isScrolled ? 0.0 : 1.0,
                                        curve: Curves.ease,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 32.0, top: 92.0),
                                          child: Text(titles[_screenIndex],
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                              )),
                                        ),
                                      )),
                                  (_screenIndex == 0)
                                      ? SliverPersistentHeader(
                                          delegate: SliverAppBarDelegate(
                                            TabBar(
                                              isScrollable: true,
                                              indicatorSize:
                                                  TabBarIndicatorSize.label,
                                              indicatorColor: kPrimaryColor,
                                              tabs: List.generate(
                                                  studentNameList.length,
                                                  (index) => Tab(
                                                      child: Text(
                                                          studentNameList[
                                                              index]))),
                                            ),
                                          ),
                                          pinned: true,
                                        )
                                      : SliverToBoxAdapter(
                                          child: Container(),
                                        ),
                                ];
                              },
                              body: (_screenIndex == 0)
                                  ? TabBarView(
                                      children: [
                                        SingleChildScrollView(
                                          // TODO: Completely Redesign this screen. -_-
                                          child: _buildHome(context, donations,
                                              studentNameList),
                                        ),
                                        SingleChildScrollView(
                                          // TODO: Completely Redesign this screen. -_-
                                          child: _buildHome(context, donations,
                                              studentNameList),
                                        ),
                                      ],
                                    )
                                  : screens[_screenIndex],
                            ));
                      },
                    ));
              });
        } else {
          return Scaffold();
        }
      },
    );
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 48.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  Widget _buildHome(context, donations, studentNameList) {
    int _currentPageIndex;
    var donationsForCurrentPage;

    _currentPageIndex = DefaultTabController.of(context).index;
    donationsForCurrentPage = donations
        .where(
            (data) => data.student.name == studentNameList[_currentPageIndex])
        .toList();
    DefaultTabController.of(context).addListener(() {
      setState(() {});
    });

    return Container(
      child: Column(
        children: [
          //StudentInfo
          Container(
            height: 200,
            width: double.infinity,
            margin: EdgeInsets.all(32.0),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    offset: Offset(0, 1),
                  )
                ]),
          ),

          Container(
            child: Table(
                defaultColumnWidth: FlexColumnWidth(1.0),
                border: TableBorder.symmetric(
                    inside: BorderSide(
                  color: Colors.grey[200],
                )),
                children:
                    List.generate(donationsForCurrentPage.length + 1, (index) {
                  if (index == 0) {
                    return TableRow(children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0, left: 32.0),
                        child: Text(
                          "Month",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "MMK Amount",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0, right: 32.0),
                        child: Text(
                          "Status",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]);
                  } else {
                    return TableRow(children: [
                      Container(
                        padding: EdgeInsets.only(top: 5.0, left: 32.0),
                        child: Text(
                          donationsForCurrentPage[index - 1].month,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      // Container(
                      //   child: Text(
                      //     donationsForCurrentPage[index - 1].student.name,
                      //     //donations[index].mmkAmount.toString(),
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                      Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          donationsForCurrentPage[index - 1]
                              .mmkAmount
                              .toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5.0, right: 32.0),
                        child: Text(
                          donationsForCurrentPage[index - 1].status,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ]);
                  }
                })),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return Consumer(
      builder: (context, ref, child) {
        AsyncValue<DonatorDonations> donatorDonations = ref(fetchDonationList);

        // Honestly, I don't know why I wrote like this either. But it works. ¯\_(ツ)_/¯
        if (donatorDonations != null) {
          return donatorDonations?.when(
              loading: () => Center(child: const CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
              data: (donatorDonations) {
                List<Donation> donations = donatorDonations.data.donations;
                var months = donations.map((e) => e.month).toList();
                var mmk = donations.map((e) => e.mmkAmount).toList();
                var status = donations.map((e) => e.status).toList();
                var studentName = donations.map((e) => e.student.name).toList();

                var studentListInfo = groupBy(donations, (e) {
                  return e.student.name;
                });

                //
                var studentList =
                    studentListInfo.keys.map((key) => key).toList();
                print(studentList);
                return Container(
                  child: Column(
                    children: List.generate(
                      months.length,
                      (index) {
                        return Container(
                          child: Card(
                            child: Column(
                              children: [
                                Text(donations[index].month),
                                Text(months[index]),
                                Text(mmk[index].toString()),
                                Text(status[index]),
                                Text(studentName[index]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              });
        } else {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
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
    bottomAppBarItem(itemIndex) {
      return SizedBox(
        width: 168,
        child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 7.0, bottom: 7.5),
              child: Column(
                children: [
                  Icon(
                    // This changes icon from outlined to filled when user selected the tab.
                    (itemIndex == 0)
                        ? (_screenIndex == 0)
                            ? Icons.dns_rounded
                            : Icons.dns_outlined
                        : (itemIndex == 1)
                            ? (_screenIndex == 1)
                                ? Icons.people_alt_rounded
                                : Icons.people_alt_outlined
                            : (itemIndex == 2)
                                ? (_screenIndex == 2)
                                    ? Icons.history_edu_rounded
                                    : Icons.history_edu_outlined
                                : (_screenIndex == 3)
                                    ? Icons.account_circle_rounded
                                    : Icons.account_circle_outlined,
                    // This changes the icon color when user selected the tab.
                    color: (_screenIndex == itemIndex)
                        ? kPrimaryColor
                        : Colors.black,
                  ),
                  Text(
                    titles[itemIndex],
                    style: TextStyle(
                      color: (_screenIndex == itemIndex)
                          ? kPrimaryColor
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                _screenIndex = itemIndex;
              });
            }),
      );
    }

    return BottomAppBar(
      child: Container(
        height: 56, //Bottom AppBar Height is 56 ... as per material guideline.
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // this places icons evenly across the screen.
          children: [
            // My Student Tab Icon.
            Container(
              width: 20,
            ),
            Expanded(child: bottomAppBarItem(0)),
            Expanded(child: bottomAppBarItem(1)),
            Expanded(child: bottomAppBarItem(2)),
            Expanded(child: bottomAppBarItem(3)),
            Container(
              width: 20,
            ),
            // All Students Tab Icon.
          ],
        ),
      ),
    );
  }
}
