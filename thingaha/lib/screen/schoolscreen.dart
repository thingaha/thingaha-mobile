import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/util/style_constants.dart';
import 'package:thingaha/widgets/appbar.dart';

class SchoolsScreen extends StatefulWidget {
  @override
  _SchoolsScreenState createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  ScrollController _scrollController;

  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
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
    return Consumer(builder: (context, ref, child) {
      final appTheme = ref(appThemeProvider);
      return Container(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              ThingahaAppBar(
                appTheme: appTheme,
                isScrolled: _isScrolled,
                screenIndex: 3,
                title: "Schools",
              ),
            ];
          },
          body: Consumer(
            builder: (context, watch, child) {
              return watch(schoolPageCount).when(
                  loading: () => Container(
                        child: Center(
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: LoadingIndicator(
                              indicatorType: Indicator.triangleSkewSpin,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                  error: (err, stack) {
                    print(stack);
                    return Container(
                      child: Text(err),
                    );
                  },
                  data: (itemCount) {
                    return Container(
                      child: ListView(
                        children: List.generate(itemCount, (schoolPageIndex) {
                          return Consumer(builder: (context, wololo, child) {
                            return wololo(schoolPage(schoolPageIndex)).when(
                              error: (err, stack) {
                                print(stack);
                                return Container(
                                  child: Text(err),
                                );
                              },
                              loading: () => Container(),
                              data: (data) {
                                var schools = data.data.schools.toList();
                                return Column(
                                  children: List.generate(
                                      schools.length,
                                      (index) => _schoolListItem(context,
                                          schools[index].name, appTheme)),
                                );
                              },
                            );
                          });
                        }),
                      ),
                    );
                  });
            },
          ),
        ),
      );
    });
  }

  _schoolListItem(context, String schoolTitle, appTheme) {
    return Container(
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
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      padding: EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              schoolTitle,
              style:
                  TextStyle(color: Theme.of(context).textTheme.subtitle2.color),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: searchIconColor(context, appTheme),
          ),
        ],
      ),
    );
  }
}
