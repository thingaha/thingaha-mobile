import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/util/style_constants.dart';
import 'package:thingaha/widgets/appbar.dart';
import 'package:thingaha/widgets/error.dart';
import 'package:thingaha/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  ScrollController _scrollController;
  bool _isScrolled = false;
  bool isDarkTheme = false;

  @override
  void initState() {
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
        final appTheme = watch(appThemeProvider);
        return watch(attendancePageCount).when(
          loading: () =>
              AttendanceLoadingWidget(message: "Swapping Time and Space ..."),
          error: (err, stack) =>
              ErrorMessageWidget(errorMessage: err, log: stack),
          data: (itemCount) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                ThingahaAppBar(
                  appTheme: appTheme,
                  isScrolled: _isScrolled,
                  screenIndex: 1,
                  title: "page_title_attendance".tr(),
                ),
                //_buildSliverAppBar(appTheme),
                // We Put a dummy DataTable to display only the Header
                // becuase we want the header to be sticky when user scrolled.
                SliverStickyHeader(
                  overlapsContent: true,
                  header: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                          color: appBarColor(context, _isScrolled, appTheme),
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
                              'tab_title_year'.tr(),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .color),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'tab_title_name'.tr(),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .color),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'tab_title_grade'.tr(),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .color),
                            ),
                          ),
                        ],
                        rows: [
                          // These had to be added to extend the width of the DataTable to Screen Width.
                          DataRow(cells: [
                            DataCell(
                              Text("2020",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .color)),
                            ),
                            DataCell(
                              Text(
                                "မောင်ချမ်းမြဆန်းလှ", // :P
                                style: TextStyle(
                                    fontFamilyFallback: [
                                      'Sanpya',
                                    ],
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .color),
                              ), // :P
                            ),
                            DataCell(
                              Text(
                                "G-11",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .color),
                              ),
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
                                    child: AttendanceLoadingWidget(
                                        message:
                                            "Were Ross and Rachel on a break? ..."),
                                  ),
                              error: (err, stack) => ErrorMessageWidget(
                                  errorMessage: err, log: stack),
                              data: (att) {
                                var list = att.data.attendances.toList();
                                return Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: DataTable(
                                    headingRowHeight: (index == 0) ? 56 : 0,
                                    columns: (index == 0)
                                        ? [
                                            DataColumn(
                                              label: Text(
                                                'tab_title_year'.tr(),
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .color),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'tab_title_name'.tr(),
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .color),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'tab_title_grade'.tr(),
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .color),
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
                                                  Text(
                                                      DateFormat.y(
                                                              EasyLocalization.of(
                                                                      context)
                                                                  .locale
                                                                  .toString())
                                                          .format(DateTime(
                                                              list[
                                                                      listIndex]
                                                                  .year,
                                                              1,
                                                              7))
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontFamilyFallback: [
                                                            'Sanpya'
                                                          ],
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .subtitle2
                                                                  .color)),
                                                ),
                                                DataCell(
                                                  Text(
                                                    list[listIndex]
                                                        .student
                                                        .name,
                                                    style: TextStyle(
                                                        fontFamilyFallback: [
                                                          'Sanpya',
                                                        ],
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2
                                                            .color),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(list[listIndex].grade,
                                                      style: TextStyle(
                                                          fontFamilyFallback: [
                                                            'Sanpya'
                                                          ],
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .subtitle2
                                                                  .color)),
                                                ),
                                              ],
                                            )),
                                  ),
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

  // Widget build(BuildContext context) {
  //   return Consumer(
  //     builder: (context, watch, child) {
  //       final appTheme = watch(appThemeProvider);
  //       var attendancePageData = [];
  //       var studentPageData = [];
  //       var attendancePageNos;
  //       var studentPageNos;
  //       watch(attendancePageCount).when(
  //         data: (data) => attendancePageNos = data,
  //         loading: () => 0,
  //         error: (err, stack) => 0,
  //       );

  //       watch(studentPageCount).when(
  //         data: (data) => studentPageNos = data,
  //         loading: () => 0,
  //         error: (err, stack) => 0,
  //       );
  //       if (attendancePageNos != null && studentPageNos != null) {
  //         studentPageData = List.generate(
  //             studentPageNos,
  //             (index) => watch(studentPage(index)).when(
  //                   data: (stdData) => stdData.data.students,
  //                   loading: () => [],
  //                   error: (err, stack) => [],
  //                 )).expand((x) => x).toList();

  //         attendancePageData = List.generate(
  //             attendancePageNos,
  //             (index) => watch(attendancePage(index)).when(
  //                   data: (attData) => attData.data.attendances,
  //                   loading: () => [],
  //                   error: (err, stack) => [],
  //                 )).expand((x) => x).toList();

  //         if (attendancePageData != [] && studentPageData != []) {
  //           // // var attendanceData = attendancePageData
  //           // //     .map((pageData) => pageData.value.data)
  //           // //     .toList();
  //           // // var attendance =
  //           // //     attendancePageData.map((data) => data.attendances).toList();
  //           // var combinedList =
  //           //     attendancePageData[0].expand((element) => element).toList();

  //           //var curatedList = for(var item in attendancePageData) curatedList.add(item);

  //           print(attendancePageData);
  //           print(studentPageData.length);

  //           var numOfStudents = studentPageData.length;
  //           var studentIDs = studentPageData.map((data) => data.id).toList();
  //           print(studentIDs);

  //           Map<int, int> studentWithYear = {};
  //           var std = <st.StudentByYear>[];

  //           for (var studentData in studentPageData) {
  //             for (var attendanceData in attendancePageData) {
  //               int id = studentData.id;
  //               if (studentData.id == attendanceData.id) {
  //                 // Map<String, int> studentWithYear = {
  //                 //   "id": id,
  //                 //   "year": attendanceData.year,
  //                 // };
  //                 std.add(st.StudentByYear(id: id, year: attendanceData.year));
  //                 studentWithYear[id] = attendanceData.year;
  //               }
  //             }
  //           }
  //           //var students = st.StudentByYear();
  //           final groupedByYear = groupBy(std, (st.StudentByYear s) {
  //             return s.year;
  //           });

  //           print(studentWithYear);
  //           print(groupedByYear);
  //           child = Container(
  //             child: CustomScrollView(
  //               controller: _scrollController,
  //               slivers: [
  //                 ThingahaAppBar(
  //                   appTheme: appTheme,
  //                   isScrolled: _isScrolled,
  //                   screenIndex: 1,
  //                   title: "Attendances",
  //                 ),
  //                 SliverToBoxAdapter(
  //                   child: Container(
  //                     margin: EdgeInsets.all(32.0),
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                         "Since 2016, a total of $numOfStudents students have been supported."),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         } else {
  //           child = AttendanceLoadingWidget(message: "Just a little bit ...");
  //         }
  //       } else {
  //         child = AttendanceLoadingWidget(message: "Just a little bit ...");
  //       }

  //       return child;
  //     },
  //   );
  // }
}
