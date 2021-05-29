import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:thingaha/util/style_constants.dart';
import 'package:thingaha/widgets/bottom_sheet.dart';

class ThingahaAppBar extends StatelessWidget {
  final bool isScrolled;
  final ThemeMode appTheme;
  final String title;
  final int screenIndex;

  ThingahaAppBar(
      {Key key, this.isScrolled, this.appTheme, this.title, this.screenIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        //backwardsCompatibility: false,
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarColor:
        //       appBarColor(context, _isScrolled, appTheme),
        //   statusBarIconBrightness:
        //       appStatusBarIconBrightness(context, appTheme),
        // ),
        backgroundColor: appBarColor(context, isScrolled, appTheme),
        pinned: true,
        expandedHeight: 100,
        title: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: isScrolled ? 1.0 : 0.0,
          curve: Curves.ease,
          child: Container(
              margin: EdgeInsets.only(left: (Platform.isAndroid ? 16.0 : 0)),
              child: Text(title, style: Theme.of(context).textTheme.headline5)),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: IconButton(
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: searchIconColor(context, appTheme),
                ),
                onPressed: () {
                  // (Platform.isIOS)
                  //     ? CupertinoScaffold.showCupertinoModalBottomSheet(
                  //         context: context,
                  //         //enableDrag: false,
                  //         builder: (context) => ProfileAndSettings(),
                  //       )
                  //     : showMaterialModalBottomSheet(
                  //         context: context,
                  //         // enableDrag: false,
                  //         builder: (context) => ProfileAndSettings());

                  SetStatusBarAndNavBarColor().accountScreen(context, appTheme);

                  CupertinoScaffold.showCupertinoModalBottomSheet(
                    context: context,
                    enableDrag: (Platform.isAndroid) ? false : true,
                    builder: (context) => ProfileAndSettings(),
                  );
                }),
          ),
        ],
        automaticallyImplyLeading: false,
        elevation: (screenIndex == 0 || screenIndex == 1)
            ? 0
            : (isScrolled)
                ? 1.5
                : 0,
        flexibleSpace: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: isScrolled ? 0.0 : 1.0,
          curve: Curves.ease,
          child: Container(
            padding: EdgeInsets.only(left: 32.0, top: 92.0),
            child: Text(title, style: Theme.of(context).textTheme.headline4),
          ),
        ));
  }
}
