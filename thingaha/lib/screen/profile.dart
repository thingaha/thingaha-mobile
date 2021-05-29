import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/model/userinfo.dart';
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
  bool isDarkTheme = false;
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
    return Consumer(
      builder: (context, ref, child) {
        var appThemeSelection = ref(appThemeProvider.notifier);
        final selectedAppTheme = ref(appThemeProvider);

        return _buildProfile(appThemeSelection, selectedAppTheme);
      },
    );
  }

  Widget _buildProfile(appThemeSelection, selectedAppTheme) {
    Widget settingsListItem(icon, iconBackgroundColor, iconColor, title, sub,
        bool isThemeChooser, String onTapEvent) {
      return Padding(
        padding: EdgeInsets.only(left: 16.0, top: 12.0, right: 16.0),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(12)),
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

            //if (onTapEvent == "logout") logout();
            switch (onTapEvent) {
              case "logout":
                logout();
                break;

              default:
            }
          },
          child: ListTile(
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
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    sub,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 50,
                  height: 46,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 30,
                    color: searchIconColor(context, selectedAppTheme),
                  ),
                ),
              )),
        ),
      );
    }

    Widget settingsColumn = Container(
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 32.0, top: 32.0, bottom: 12.0),
              child: Text(
                txt_settings,
                style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle2.color),
              )),
          settingsListItem(Icons.info_rounded, Colors.pink[50], Colors.pink,
              "About Us", "", false, null),
          settingsListItem(Icons.language_rounded, Colors.blue[50], Colors.blue,
              "Language", "English", false, null),
          settingsListItem(Icons.vpn_key_rounded, Colors.green[50],
              Colors.green, "Password", "", false, null),
          _buildThemeChooser(appThemeSelection, selectedAppTheme),
          settingsListItem(Icons.logout, Colors.cyan[50], Colors.cyan, "Logout",
              "", false, "logout"),
        ],
      ),
    );

    Widget name = Container(
      width: MediaQuery.of(context).size.width,
      child: Consumer(builder: (context, watch, child) {
        var name = "";
        var email = "";
        var username = "";
        var country = "";
        var address = "";
        return watch(fetchUserDetail).when(
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
          error: (err, stack) => Text('Error: $err'),
          data: (userInfo) {
            name = userInfo.data.user.displayName;
            email = userInfo.data.user.email;
            username = userInfo.data.user.username;
            country = userInfo.data.user.country;
            address = userInfo.data.user.formattedAddress;
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildSliverAppBar(txt_acc),
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 32.0),
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          onTap: () {
                            final scaffold = ScaffoldMessenger.of(context);
                            scaffold.showSnackBar(
                              SnackBar(
                                content: Text('Pressed $name (* ^ ω ^)'),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 1),
                                //action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
                              ),
                            );

                            //if (onTapEvent == "logout") logout();
                          },
                          child: ListTile(
                              leading: CircleFlag(
                                  (country != "") ? country : "united_nations",
                                  size: 38),
                              title: Text(
                                (name != null) ? "$name ($username)" : "",
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .fontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .color,
                                  fontFamilyFallback: [
                                    'Sanpya',
                                  ],
                                ),
                              ),
                              trailing: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 50,
                                  height: 46,
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    size: 30,
                                    color: searchIconColor(
                                        context, selectedAppTheme),
                                  ),
                                ),
                              )),
                        ),
                      ),
                      settingsColumn,
                    ],
                  ),
                )
              ],
            );
          },
        );
      }),
    );

    return Container(
      child: name,
    );
  }

  _buildThemeChooser(appThemeSelection, selectedAppTheme) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: PopupMenuButton<ThemeMode>(
        enableFeedback: true,
        color: cardBackgroundColor(context, selectedAppTheme),
        tooltip: "Choose one of the three App Themes",
        onSelected: (ThemeMode result) {
          setAppTheme(appThemeSelection, result);
          setState(() {
            //_selection = result;
          });
        },
        offset: Offset(width.toDouble(), -16),
        child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple[50],
              child: Icon(
                (selectedAppTheme == ThemeMode.light)
                    ? EvaIcons.sun
                    : (selectedAppTheme == ThemeMode.dark)
                        ? EvaIcons.moon
                        : EvaIcons.settings,
                color: Colors.purple,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "App Theme",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  (selectedAppTheme == ThemeMode.light)
                      ? "Jedi's"
                      : (selectedAppTheme == ThemeMode.dark)
                          ? "Sith's"
                          : "System's",
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                // color: (selectedAppTheme == ThemeMode.light ||
                //         selectedAppTheme == ThemeMode.system &&
                //             MediaQuery.of(context).platformBrightness ==
                //                 Brightness.light)
                //     ? Colors.grey[50]
                //     : Colors.white70,
                width: 50,
                height: 46,
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 30,
                  color: searchIconColor(context, selectedAppTheme),
                ),
              ),
            )),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
          PopupMenuItem<ThemeMode>(
            value: ThemeMode.light,
            child: Text("Jedi's", style: Theme.of(context).textTheme.subtitle2),
          ),
          PopupMenuItem<ThemeMode>(
            value: ThemeMode.dark,
            child: Text("Sith's", style: Theme.of(context).textTheme.subtitle2),
          ),
          PopupMenuItem<ThemeMode>(
            value: ThemeMode.system,
            child:
                Text("System's", style: Theme.of(context).textTheme.subtitle2),
          ),
        ],
      ),
    );
  }

  setAppTheme(appThemeSelection, result) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var themeString;
    if (result == ThemeMode.light) {
      themeString = StaticStrings.themeLight;
    } else if (result == ThemeMode.dark) {
      themeString = StaticStrings.themeDark;
    } else if (result == ThemeMode.system) {
      themeString = StaticStrings.themeSystem;
    }
    localStorage.setString(StaticStrings.keyAppTheme, themeString);
    appThemeSelection.setTheme(result);
  }

  _buildSliverAppBar(title) {
    return SliverAppBar(
        pinned: true,
        expandedHeight: 100,
        title: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _isScrolled ? 1.0 : 0.0,
          curve: Curves.ease,
          child: Text(title, style: Theme.of(context).textTheme.headline5),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _isScrolled ? 0.0 : 1.0,
          curve: Curves.ease,
          child: Container(
            padding: EdgeInsets.only(left: 32.0, top: 92.0, right: 32.0),
            child: Text(title, style: Theme.of(context).textTheme.headline4),
          ),
        ));
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
