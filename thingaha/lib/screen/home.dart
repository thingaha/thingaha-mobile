import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingaha/helper/reusable_widget.dart';
import 'package:thingaha/screen/DrawerItem.dart';
import 'package:thingaha/screen/all_students.dart';
import 'package:thingaha/screen/history.dart';
import 'package:thingaha/screen/student_info.dart';
import 'package:thingaha/screen/profile.dart';
import 'package:thingaha/util/constants.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),  // onBackPress => exit the app
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              APP_NAME,
              style: TextStyle(color: Colors.white)
          ),
          iconTheme: new IconThemeData(color: Colors.white),
          leading: Builder(
              builder: (context) => IconButton(
                icon: new Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
          ),
        ),

        drawer: _buildDrawerLayout(),

        body: Center(
          child: MaterialButton(
            child: Text("Go to Student info"),
            color: kPrimaryColor,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => StudentInfo()));
            },
          ),
        ),
      ),
    );
  }

  _buildCarousel() {

  }

  Widget _buildDrawerLayout() {
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            _buildDrawerHeader(),

            DrawerItem(txt_my_student, null),
            DrawerItem(txt_all_students, AllStudents()),
            DrawerItem(txt_history, History()),
            DrawerItem(txt_profile, Profile()),
            DrawerItem(txt_logout, null),

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
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 50
                )
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [kPrimaryColor, Colors.lightGreen]
          )
      ),
    );
  }
}
