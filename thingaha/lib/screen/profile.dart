import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/helper/title_and_text_with_column.dart';
import 'package:thingaha/model/donor.dart';
import 'package:thingaha/model/providers.dart';
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
          var displayName =
              watch(fetchDisplayNamefromLocalProvider).data?.value;

          var userInfo = watch(fetchUserDetail).data?.value;
          var name = "";
          var email = "";
          var username = "";
          var country = "";
          var address = "";
          if (userInfo != null) {
            name = userInfo.data.user.displayName;
            email = userInfo.data.user.email;
            username = userInfo.data.user.username;
            country = userInfo.data.user.country;
            address = userInfo.data.user.formattedAddress;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: ListTile(
                    leading: CircleFlag(country, size: 38),
                    title: Text(
                      (displayName != null) ? "$name ($username)" : "",
                      style: TextStyle(
                          fontFamily: GoogleFonts.firaSans().fontFamily),
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
          );
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
          settingsListItem(Icons.vpn_key_rounded, Colors.green[50],
              Colors.green, "Password", "", false, null),
          settingsListItem(Icons.language_rounded, Colors.blue[50], Colors.blue,
              "Language", "English", false, null),
          settingsListItem(
              Icons.notifications_active_rounded,
              Colors.orange[50],
              Colors.orange,
              "Notificaions",
              "",
              false,
              null),
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
    print("This works");
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(StaticStrings.keyAccessToken, "");
    localStorage.setBool(StaticStrings.keyLogInStatus, false);
    localStorage.setInt(StaticStrings.keyUserID, 0);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}
