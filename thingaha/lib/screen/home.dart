import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:thingaha/helper/logout.dart';
import 'package:thingaha/helper/slivertabs.dart';
import 'package:thingaha/model/donatordonations.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/model/student_donation_status.dart';
import 'package:thingaha/screen/all_students.dart';
import 'package:thingaha/screen/attendance_tab.dart';
import 'package:thingaha/screen/profile.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _screenIndex = 0;
  String displayName = "";
  var screens = [
    Container(),
    AttendanceScreen(),
    AllStudents(),
    Profile(),
  ];

  var titles = [
    txt_donations,
    "Attendance",
    txt_all_students,
    txt_acc,
  ];

  ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    context.read(fetchDisplayNamefromLocalProvider);
    context.read(fetchDonationList);
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appTheme = ref(appThemeProvider);
        return Scaffold(
          bottomNavigationBar: _bottomNavigationBar(appTheme),
          body: Consumer(
            builder: (context, watch, child) {
              AsyncValue<DonatorDonations> donatorDonations =
                  watch(fetchDonationList);

              if (donatorDonations != null) {
                return donatorDonations?.when(
                    loading: () => Scaffold(
                            body: Center(
                          child: Column(
                            children: [
                              SvgPicture.asset('images/loading.svg',
                                  semanticsLabel: 'Reading from memory card.'),
                              SizedBox(
                                width: 36,
                                height: 36,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballBeat,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Text(
                                "Reading from memory card.\nPlease do not remove memory card.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ],
                          ),
                        )),
                    error: (err, stack) {
                      String assetName = 'images/bug.svg';
                      print(stack);
                      return Scaffold(
                          body: Center(
                              child: SvgPicture.asset(assetName,
                                  semanticsLabel:
                                      'Oops! Something went wrong.')));
                    },
                    data: (donatorDonations) {
                      List<Donation> donations =
                          donatorDonations.data.donations;
                      //print(donations);
                      if (donations.isEmpty) {
                        String assetName = 'images/blank.svg';
                        return Scaffold(
                            body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: SizedBox(
                                height: 500,
                                width: 500,
                                child: SvgPicture.asset(assetName,
                                    semanticsLabel:
                                        'Oops! Something went wrong.'),
                              ),
                            ),
                            Container(
                                child: Text("There's no data... hmmm...")),
                            ElevatedButton.icon(
                              onPressed: logout,
                              label: Text("Logout"),
                              icon: Icon(Icons.login_rounded),
                            ),
                          ],
                        ));
                      }

                      var studentListInfo = groupBy(donations, (e) {
                        return e.student.name;
                      });

                      var studentNameList = studentListInfo.keys.toList();

                      return (_screenIndex == 0)
                          ? _buildHomeShell(
                              studentNameList, donations, appTheme)
                          : screens[_screenIndex];
                    });
              } else {
                return Scaffold();
              }
            },
          ),
        );
      },
    );
  }

  _buildHomeShell(studentNameList, donations, appTheme) {
    return DefaultTabController(
        length: studentNameList.length,
        child: Builder(
          builder: (BuildContext context) {
            return NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                      backwardsCompatibility: false,
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor:
                            appBarColor(context, _isScrolled, appTheme),
                        statusBarIconBrightness:
                            appStatusBarIconBrightness(context, appTheme),
                      ),
                      backgroundColor:
                          appBarColor(context, _isScrolled, appTheme),
                      pinned: true,
                      expandedHeight: 100,
                      title: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _isScrolled ? 1.0 : 0.0,
                        curve: Curves.ease,
                        child: Text(titles[_screenIndex],
                            style: Theme.of(context).textTheme.headline5),
                      ),
                      automaticallyImplyLeading: false,
                      elevation: (_screenIndex == 0)
                          ? 0
                          : (_isScrolled)
                              ? 1.5
                              : 0,
                      flexibleSpace: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _isScrolled ? 0.0 : 1.0,
                        curve: Curves.ease,
                        child: Container(
                          padding: EdgeInsets.only(left: 32.0, top: 92.0),
                          child: Text(titles[_screenIndex],
                              style: Theme.of(context).textTheme.headline4),
                        ),
                      )),
                  (_screenIndex == 0)
                      ? SliverPersistentHeader(
                          delegate: SliverAppBarDelegate(
                            TabBar(
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: MD2Indicator(
                                  //it begins here
                                  indicatorHeight: 3,
                                  indicatorColor:
                                      Theme.of(context).primaryColor,
                                  indicatorSize: MD2IndicatorSize
                                      .normal //3 different modes tiny-normal-full
                                  ),
                              tabs: List.generate(
                                  studentNameList.length,
                                  (index) => Tab(
                                          child: Text(
                                        studentNameList[index],
                                        style: TextStyle(
                                            fontFamilyFallback: ['Sanpya'],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .color),
                                      ))),
                            ),
                          ),
                          pinned: true,
                        )
                      : SliverToBoxAdapter(
                          child: Container(),
                        ),
                ];
              },
              body: TabBarView(
                children: List.generate(
                  studentNameList.length,
                  (index) => SingleChildScrollView(
                    child: _buildHomeContent(
                        context, donations, studentNameList, appTheme),
                  ),
                ),
              ),
            );
          },
        ));
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

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Widget _buildHomeContent(context, donations, studentNameList, appTheme) {
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
    var birthday, age, addressDivision, photoURL;
    print(donationsForCurrentPage[0].student.birthDate);
    if (donationsForCurrentPage != null) {
      print(donationsForCurrentPage[0].student.birthDate);
      if (donationsForCurrentPage[0].student.birthDate != null &&
          donationsForCurrentPage[0].student.birthDate != "") {
        birthday = DateFormat.yMMMMd('en_US')
            .format(
                DateTime.parse(donationsForCurrentPage[0].student.birthDate))
            .toString();
        age = calculateAge(
                DateTime.parse(donationsForCurrentPage[0].student.birthDate))
            .toString();
      } else {
        birthday = "";
        age = "";
      }

      addressDivision = donationsForCurrentPage[0].student.address.division;
      photoURL = donationsForCurrentPage[0].student.photo;
    }

    print("Photo is $photoURL");
    return Container(
      child: Column(
        children: [
          //StudentInfo
          Container(
            height: 200,
            width: double.infinity,
            margin: EdgeInsets.all(32.0),
            decoration: BoxDecoration(
                color: cardBackgroundColor(context, appTheme),
                border: Border.all(color: borderColor(context, appTheme)),
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: boxShadowColor(context, appTheme),
                    offset: Offset(0, 1),
                  )
                ]),
            child: Row(
              children: [
                Container(
                  width: 120,
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: (photoURL != "")
                          ? Colors.transparent
                          : studentPhotoDummyColor(context, appTheme),
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: (photoURL != "")
                      ? ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(photoURL),
                        )
                      : Center(
                          child: Text("Student Photo"),
                        ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text(
                        donationsForCurrentPage[0].student.name,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle2.color,
                            fontFamilyFallback: ['Sanpya'],
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Text((age == "") ? "" : "$age years old.\n(born $birthday)",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle2.color,
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text(
                          "from ${addressDivision.toString()[0].toUpperCase()}${addressDivision.toString().substring(1)}",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle2.color,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),

          Container(
            child: Table(
                defaultColumnWidth: FlexColumnWidth(1.0),
                border: TableBorder(
                    horizontalInside: BorderSide(
                  color: borderColor(context, appTheme),
                )),
                children:
                    List.generate(donationsForCurrentPage.length + 1, (index) {
                  if (index == 0) {
                    return TableRow(
                        decoration: BoxDecoration(
                            color: cardBackgroundColor(context, appTheme),
                            boxShadow: [
                              BoxShadow(
                                color: boxShadowColor(context, appTheme),
                                offset: Offset(0, 1),
                              )
                            ]),
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 16.0, left: 32.0, top: 16.0),
                            child: Text(
                              "Month",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.subtitle2.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 16.0, top: 16.0),
                            child: Text(
                              "MMK Amount",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.subtitle2.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 16.0, right: 32.0, top: 16.0),
                            child: Text(
                              "Status",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.subtitle2.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]);
                  } else {
                    return TableRow(children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 12.0, left: 32.0, bottom: 12.0),
                        child: Text(
                          //This capitalizes the first letter.
                          "${donationsForCurrentPage[index - 1].month.toString()[0].toUpperCase()}${donationsForCurrentPage[index - 1].month.toString().substring(1)}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle2.color,
                          ),
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
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text(
                          donationsForCurrentPage[index - 1]
                              .mmkAmount
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle2.color,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 12.0, right: 32.0, bottom: 12.0),
                        child: Text(
                          donationsForCurrentPage[index - 1].status,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle2.color,
                          ),
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

  Widget _bottomNavigationBar(appTheme) {
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
                    bottomAppBarIcon(itemIndex, _screenIndex),
                    // This changes the icon color when user selected the tab.
                    color: bottomAppBarIconColor(
                        context, itemIndex, _screenIndex, appTheme),
                  ),
                  Text(
                    titles[itemIndex],
                    style: TextStyle(
                      color: (_screenIndex == itemIndex)
                          ? Theme.of(context).primaryColor
                          : (appTheme == ThemeMode.light ||
                                  appTheme == ThemeMode.system &&
                                      MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.light)
                              ? Colors.black
                              : cloudColor,
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
        height: 57, //Bottom AppBar Height is 56 ... as per material guideline.
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: (appTheme == ThemeMode.light ||
                        appTheme == ThemeMode.system &&
                            MediaQuery.of(context).platformBrightness ==
                                Brightness
                                    .light) // Light Theme Or System Light theme)
                    ? Colors.transparent
                    : darkAppBarShadowColor,
                width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // this places icons evenly across the screen.
          children: [
            // My Student Tab Icon.

            Expanded(child: bottomAppBarItem(0)),
            Expanded(child: bottomAppBarItem(1)),
            Expanded(child: bottomAppBarItem(2)),
            Expanded(child: bottomAppBarItem(3)),

            // All Students Tab Icon.
          ],
        ),
      ),
    );
  }
}
