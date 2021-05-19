import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:thingaha/helper/custom_appbar.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/model/attendances.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/screen/student_per_year.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';

//TODO: Get data from API
List<String> years = ["2017", "2018", "2019", "2020"];

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  ScrollController _scrollController;
  StickyHeaderController _stickyController;
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return watch(attendancePageCount).when(
          loading: () => _attendanceLoading("Swapping Time and Space ..."),
          error: (err, stack) => _attendanceError(err, stack),
          data: (itemCount) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildSliverAppBar(),
                // We Put a dummy DataTable to display only the Header
                // becuase we want the header to be sticky when user scrolled.
                SliverStickyHeader(
                  overlapsContent: true,
                  header: Container(
                      decoration: BoxDecoration(
                          color: _isScrolled ? kAppBarLightColor : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.transparent,
                              offset: Offset(0, 1.5),
                            )
                          ]),
                      child: DataTable(
                        dataRowHeight: 0,
                        columns: [
                          DataColumn(
                            label: Text(
                              'Year',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Name',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Grade',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                        rows: [
                          // These had to be added to extend the width of the DataTable to Screen Width.
                          DataRow(cells: [
                            DataCell(
                              Text("2020"),
                            ),
                            DataCell(
                              Text("မောင်ချမ်းမြဆန်းလှ"), // :P
                            ),
                            DataCell(
                              Text("G-11"),
                            ),
                          ])
                        ],
                      )),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Consumer(
                        builder: (context, watch, child) {
                          return watch(attendancePage(index)).when(
                              loading: () => Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: _attendanceLoading(
                                        "Were Ross and Rachel on a break? ..."),
                                  ),
                              error: (err, stack) =>
                                  _attendanceError(err, stack),
                              data: (att) {
                                var list = att.data.attendances.toList();
                                return DataTable(
                                  headingRowHeight: (index == 0) ? 56 : 0,
                                  columns: (index == 0)
                                      ? [
                                          DataColumn(
                                            label: Text(
                                              'Year',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Name',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Grade',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ]
                                      : [
                                          DataColumn(label: Container()),
                                          DataColumn(label: Container()),
                                          DataColumn(label: Container()),
                                        ],
                                  rows: List.generate(
                                      list.length,
                                      (listIndex) => DataRow(
                                            cells: [
                                              DataCell(
                                                Text(list[listIndex]
                                                    .year
                                                    .toString()),
                                              ),
                                              DataCell(
                                                Text(list[listIndex]
                                                    .student
                                                    .name),
                                              ),
                                              DataCell(
                                                Text(list[listIndex].grade),
                                              ),
                                            ],
                                          )),
                                );
                              });
                        },
                      );
                    }, childCount: itemCount),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  _attendanceLoading(String message) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: LoadingIndicator(
                indicatorType: Indicator.orbit,
                color: kPrimaryColor,
              ),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  _attendanceError(err, stack) {
    print(stack);
    String assetName = 'images/bug.svg';
    return Center(
      child: SvgPicture.asset(assetName,
          semanticsLabel: 'Oops! Something went wrong.'),
    );
  }

  _buildSliverAppBar() {
    return SliverAppBar(
        pinned: true,
        backgroundColor: _isScrolled ? kAppBarLightColor : Colors.white,
        expandedHeight: 100,
        title: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _isScrolled ? 1.0 : 0.0,
          curve: Curves.ease,
          child: Text("Attendances",
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.lato().fontFamily,
              )),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _isScrolled ? 0.0 : 1.0,
          curve: Curves.ease,
          child: Container(
            padding: EdgeInsets.only(left: 32.0, top: 92.0, right: 32.0),
            child: Text("Attendances",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: GoogleFonts.lato().fontFamily,
                )),
          ),
        ));
  }
}
