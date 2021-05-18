import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/helper/title_and_text_with_column.dart';
import 'package:thingaha/model/donor.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/model/userinfo.dart';
import 'package:thingaha/screen/change_password.dart';
import 'package:thingaha/screen/login.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';
import 'package:circle_flags/circle_flags.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  void initState() {
    // TODO: implement initState
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
    return Scaffold(
        // appBar: CustomAppBar(
        //    // title: txt_profile,
        //     actionButton: [
        //       IconButton(
        //         icon: Icon(Icons.edit, color: Colors.white),
        //         onPressed: () {
        //           Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
        //         })
        //     ],
        // ),
        backgroundColor: Colors.white,
        body: _buildProfile());
  }

  Widget _buildProfile() {
    //TODO: Get data from API
    Donor donor = Donor();
    donor.name = "Khine Khine";
    donor.email = "khinekhine123@gmail.com";
    donor.country = "Myanmar";
    donor.address = "Lorem ipsum dolor sit amet";

    Widget name = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 16.0, bottom: 32.0),
      child: Consumer(
        builder: (context, watch, child) {
          AsyncValue<UserInfo> userInfo = watch(fetchUserDetail).data;
          var name = "";
          var email = "";
          var username = "";
          var country = "";
          var address = "";
          if (userInfo != null) {
            return userInfo?.when(
              loading: () => Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineScale,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    "Waiting Daenerys say all her titles...",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              error: (err, stack) => Text('Error: $err'),
              data: (userInfo) {
                name = userInfo.data.user.displayName;
                email = userInfo.data.user.email;
                username = userInfo.data.user.username;
                country = userInfo.data.user.country;
                address = userInfo.data.user.formattedAddress;
                return Flexible(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                          pinned: true,
                          backgroundColor:
                              _isScrolled ? kAppBarLightColor : Colors.white,
                          expandedHeight: 120,
                          title: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: _isScrolled ? 1.0 : 0.0,
                            curve: Curves.ease,
                            child: Text("Settings",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                )),
                          ),
                          automaticallyImplyLeading: false,
                          elevation: (_isScrolled) ? 1.5 : 0,
                          flexibleSpace: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: _isScrolled ? 0.0 : 1.0,
                            curve: Curves.ease,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 32.0, top: 92.0, right: 32.0),
                              child: Text("Settings",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  )),
                            ),
                          )),
                      SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                              ),
                              child: ListTile(
                                  leading: CircleFlag(
                                      (country != "")
                                          ? country
                                          : "united_nations",
                                      size: 38),
                                  title: Text(
                                    (name != null) ? "$name ($username)" : "",
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.firaSans().fontFamily),
                                  ),
                                  trailing: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      color: Colors.grey[50],
                                      width: 50,
                                      height: 46,
                                      child: Icon(
                                        Icons.chevron_right_rounded,
                                        size: 30,
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineScale,
                      color: kPrimaryColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0),
                    child: Text(
                      "Waiting Daenerys say all her titles...",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );

    Widget info = Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: CustomCardView(
        cardView: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              TitleAndTextWithColumn(title: txt_email, text: donor.email),
              TitleAndTextWithColumn(title: txt_country, text: donor.country),
              TitleAndTextWithColumn(title: txt_address, text: donor.address)
            ],
          ),
        ),
      ),
    );

    Widget changePassword = Container(
      margin: EdgeInsets.symmetric(vertical: 25.0),
      child: MaterialButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChangePassword()));
        },
        color: kPrimaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            txt_change_password,
            textAlign: TextAlign.center,
            style: TextStyle().copyWith(color: Colors.white, fontSize: 16.0),
          ),
        ),
      ),
    );

    Widget settingsListItem(icon, iconBackgroundColor, iconColor, title, sub,
        bool isSwitch, String onTapEvent) {
      var _darkmode = false;
      return Padding(
        padding: EdgeInsets.only(left: 16.0, top: 12.0, right: 16.0),
        child: ListTile(
            onTap: () {
              final scaffold = ScaffoldMessenger.of(context);
              scaffold.showSnackBar(
                SnackBar(
                  content: Text('Pressed $title (* ^ ω ^)'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                  //action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
                ),
              );

              if (onTapEvent == "logout") logout();
            },
            leading: CircleAvatar(
              backgroundColor: iconBackgroundColor,
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style:
                      TextStyle(fontFamily: GoogleFonts.firaSans().fontFamily),
                ),
                Text(
                  sub,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: isSwitch
                ? Transform.scale(
                    scale: 0.9,
                    child: CupertinoSwitch(
                      value: _darkmode,
                      onChanged: (bool value) {
                        setState(() {
                          _darkmode = value;
                        });
                      },
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Colors.grey[50],
                      width: 50,
                      height: 46,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 30,
                      ),
                    ),
                  )),
      );
    }

    Widget settingsColumn = Container(
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 32.0, top: 32.0, bottom: 12.0),
              child: Text(txt_settings)),
          settingsListItem(Icons.info_rounded, Colors.pink[50], Colors.pink,
              "About Us", "", false, null),
          settingsListItem(Icons.language_rounded, Colors.blue[50], Colors.blue,
              "Language", "English", false, null),
          settingsListItem(Icons.vpn_key_rounded, Colors.green[50],
              Colors.green, "Password", "", false, null),
          settingsListItem(Icons.lightbulb_outlined, Colors.purple[50],
              Colors.purple, "DarkMode", "Off", true, null),
          settingsListItem(Icons.logout, Colors.cyan[50], Colors.cyan, "Logout",
              "", false, "logout"),
        ],
      ),
    );

    return Container(
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 32.0, top: 48.0),
              child: Text(txt_profile)),
          name,
          settingsColumn,
        ],
      ),
    );
  }

  logout() async {
    // print("This works");
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(StaticStrings.keyAccessToken, "");
    localStorage.setBool(StaticStrings.keyLogInStatus, false);
    localStorage.setInt(StaticStrings.keyUserID, 0);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}
