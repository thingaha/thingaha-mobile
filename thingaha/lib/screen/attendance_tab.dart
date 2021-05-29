import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/util/style_constants.dart';
import 'package:thingaha/widgets/appbar.dart';
import 'package:thingaha/widgets/bottom_sheet.dart';

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
          loading: () => _attendanceLoading("Swapping Time and Space ..."),
          error: (err, stack) => _attendanceError(err, stack),
          data: (itemCount) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                ThingahaAppBar(
                  appTheme: appTheme,
                  isScrolled: _isScrolled,
                  screenIndex: 1,
                  title: "Attendances",
                ),
                //_buildSliverAppBar(appTheme),
                // We Put a dummy DataTable to display only the Header
                // becuase we want the header to be sticky when user scrolled.
                SliverStickyHeader(
                  overlapsContent: true,
                  header: Container(
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
                              'Year',
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
                              'Name',
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
                              'Grade',
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
                                "မောင်ချမ်းမြဆန်းလှ",
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
                                                Text(
                                                    list[listIndex]
                                                        .year
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2
                                                            .color)),
                                              ),
                                              DataCell(
                                                Text(
                                                  list[listIndex].student.name,
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
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2
                                                            .color)),
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
              style: Theme.of(context).textTheme.subtitle2,
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
}
