import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/util/style_constants.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);
  bool isDarkTheme = false;

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer(builder: (context, ref, child) {
      final appTheme = ref(appThemeProvider);
      return new Container(
          decoration: BoxDecoration(
            color: appBarColor(context, overlapsContent, appTheme),
            border: Border(
              bottom: BorderSide(
                  width: (appTheme == ThemeMode.light ||
                          appTheme == ThemeMode.system &&
                              MediaQuery.of(context).platformBrightness ==
                                  Brightness.light)
                      ? 1.5
                      : 1,
                  color: borderColor(context, appTheme)),
            ),
          ),
          padding: EdgeInsets.only(left: 16.0),
          child: _tabBar);
    });
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
