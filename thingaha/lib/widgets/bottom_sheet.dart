import 'package:circle_flags/circle_flags.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/screen/login.dart';
import 'package:thingaha/util/keys.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';

class ProfileAndSettings extends ConsumerWidget {
  @override
  Widget build(BuildContext rootContext, ScopedReader watch) {
    final appT = watch(appThemeProvider);
    print("App Theme is $appT");
    return WillPopScope(
      onWillPop: () async {
        SetStatusBarAndNavBarColor().mainUI(rootContext, appT);
        return true;
      },
      child: Material(
        color: modalSheetBackgroundColor(rootContext, appT),
        child: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (context2) => Builder(
              builder: (context) => Consumer(
                builder: (context, ref, child) {
                  final appTheme = ref(appThemeProvider);
                  return Scaffold(
                    backgroundColor:
                        modalSheetBackgroundColor(context, appTheme),
                    appBar: AppBar(
                      backgroundColor: modalSheetAppBarColor(context, appTheme),
                      title: Text(
                        "Account",
                        style: Theme.of(rootContext).textTheme.headline6,
                      ),
                      centerTitle: true,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      actions: [
                        TextButton(
                            onPressed: () {
                              SetStatusBarAndNavBarColor()
                                  .mainUI(rootContext, appTheme);
                              Navigator.of(rootContext).pop();
                            },
                            child: Text("Done")),
                      ],
                    ),
                    body: accountChild(rootContext, context, appTheme),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget accountChild(rootContext, context, appTheme) {
    return Container(
      child: Column(
        children: [
          // Profile Card
          profileCard(context, appTheme),

          // Settings Column
          settingsCard(rootContext, context, appTheme),

          // LogOut card
          logoutCard(rootContext, context, appTheme),
        ],
      ),
    );
  }

  Widget profileCard(context, appTheme) {
    print("app theme after child is $appTheme");
    return Container(
      height: 200,
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
      decoration: BoxDecoration(
        color: greyCardBackgroundColor(context, appTheme),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          return ref(fetchUserDetail).when(
              loading: () => Center(
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballRotateChase,
                        color: primaryColors(context, appTheme),
                      ),
                    ),
                  ),
              error: (err, stack) {
                print(stack);
                return Container(
                  child: Text(err),
                );
              },
              data: (userInfo) {
                final name = userInfo.data.user.displayName;
                final email = userInfo.data.user.email;
                final username = userInfo.data.user.username;
                final country = userInfo.data.user.country;
                final address = userInfo.data.user.formattedAddress;
                return Container(
                  padding: EdgeInsets.only(
                      right: 16.0, left: 16.0, top: 16.0, bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleFlag(
                                  (country != "") ? country : "united_nations",
                                  size: 48),

                              // Name & NickName
                              Container(
                                margin: EdgeInsets.only(top: 16.0),
                                child: Text(
                                  (name != null) ? "$name\n($username)" : "",
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
                              ),

                              // Address
                              Container(
                                margin: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  (address != null) ? "$address" : "",
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .fontSize,
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .color,
                                    fontFamilyFallback: [
                                      'Sanpya',
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                primaryColors(context, appTheme)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                          ),
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit_rounded,
                            size: 22,
                            color: buttonTextColor(context, appTheme),
                          ),
                          label: Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: buttonTextColor(context, appTheme),
                            ),
                          )),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  Widget settingsItem(rootContext, context, icon, title, appTheme, action) {
    return ListTile(
      leading: Icon(icon, color: searchIconColor(context, appTheme)),
      onTap: () {
        switch (action) {
          case StaticStrings.actionLogOut:
            logout(rootContext);
            break;
          case StaticStrings.actionTheme:
            SetStatusBarAndNavBarColor().themeChooser(context, appTheme);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    AppThemeSelector(rootContext: rootContext)));
            break;
          default:
        }
      },
      title: Text(
        title,
        style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).textTheme.subtitle2.color,
            fontWeight: FontWeight.w500),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: searchIconColor(context, appTheme),
      ),
    );
  }

  Widget settingsCard(rootContext, context, appTheme) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
      decoration: BoxDecoration(
        color: greyCardBackgroundColor(context, appTheme),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            height: 6.0,
          ),
          settingsItem(rootContext, context, Icons.info_outline_rounded,
              "About Us", appTheme, StaticStrings.actionAboutUs),
          Divider(
            color: dividerColor(context, appTheme),
            thickness: 1.0,
          ),
          settingsItem(rootContext, context, Icons.translate_rounded,
              "Language", appTheme, StaticStrings.actionLanguage),
          Divider(
            color: dividerColor(context, appTheme),
            thickness: 1.0,
          ),
          settingsItem(rootContext, context, Icons.vpn_key_rounded,
              "Change Password", appTheme, StaticStrings.actionChangePassword),
          Divider(
            color: dividerColor(context, appTheme),
            thickness: 1.0,
          ),
          settingsItem(rootContext, context, EvaIcons.moonOutline, "Apperance",
              appTheme, StaticStrings.actionTheme),
          Container(
            height: 6.0,
          ),
        ],
      ),
    );
  }

  Widget logoutCard(rootContext, context, appTheme) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
      decoration: BoxDecoration(
        color: greyCardBackgroundColor(context, appTheme),
        borderRadius: BorderRadius.circular(12),
      ),
      child: settingsItem(rootContext, context, EvaIcons.logOutOutline,
          "Log Out", appTheme, StaticStrings.actionLogOut),
    );
  }

  logout(rootcontext) async {
    // print("This works");
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(StaticStrings.keyAccessToken, "");
    localStorage.setBool(StaticStrings.keyLogInStatus, false);
    localStorage.setInt(StaticStrings.keyUserID, 0);

    Navigator.of(rootcontext).popUntil((route) => route.isFirst);
    navKey.currentState.pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => Login()));
  }
}

class AppThemeSelector extends ConsumerWidget {
  final BuildContext rootContext;

  AppThemeSelector({Key key, this.rootContext}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final appTheme = watch(appThemeProvider);
    final appThemeChooser = watch(appThemeProvider.notifier);

    return Material(
        child: Scaffold(
      backgroundColor: themeChooserBG(context, appTheme),
      appBar: AppBar(
        backgroundColor: themeChooserBG(context, appTheme),
        title: Text(
          "Apperance",
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            color: searchIconColor(context, appTheme),
          ),
          onPressed: () {
            SetStatusBarAndNavBarColor().accountScreen(context, appTheme);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                SetStatusBarAndNavBarColor().mainUI(context, appTheme);
                Navigator.of(rootContext).pop();
              },
              child: Text("Done")),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 24.0, bottom: 5.0),
            alignment: Alignment.centerLeft,
            child: Text("THEME",
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
              color: themeChooserColumn(context, appTheme),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text("Jedi's",
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.subtitle2.color)),
                    value: ThemeMode.light,
                    groupValue: appTheme,
                    dense: true,
                    onChanged: (ThemeMode value) {
                      setAppTheme(appThemeChooser, value);
                    },
                  ),
                  Divider(
                    indent: 24.0,
                    endIndent: 24.0,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text("Sith's",
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.subtitle2.color)),
                    value: ThemeMode.dark,
                    groupValue: appTheme,
                    dense: true,
                    onChanged: (ThemeMode value) {
                      setAppTheme(appThemeChooser, value);
                    },
                  ),
                  Divider(
                    indent: 24.0,
                    endIndent: 24.0,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text("System's",
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.subtitle2.color)),
                    value: ThemeMode.system,
                    groupValue: appTheme,
                    dense: true,
                    onChanged: (ThemeMode value) {
                      setAppTheme(appThemeChooser, value);
                    },
                  ),
                ],
              )),
        ],
      ),
    ));
  }

  setAppTheme(appThemeSelection, result) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var themeString;
    if (result == ThemeMode.light) {
      themeString = StaticStrings.themeLight;

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xfff7f7f7),
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else if (result == ThemeMode.dark) {
      themeString = StaticStrings.themeDark;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xff0e0d0f),
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    } else if (result == ThemeMode.system) {
      themeString = StaticStrings.themeSystem;
    }
    localStorage.setString(StaticStrings.keyAppTheme, themeString);
    appThemeSelection.setTheme(result);
    print("current Theme is $result");
  }
}

class ChangePassword extends StatelessWidget {
  final BuildContext rootContext;

  ChangePassword({Key key, this.rootContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appTheme = ref(appThemeProvider);
        return Material(
            child: Scaffold(
          backgroundColor: themeChooserBG(context, appTheme),
          appBar: AppBar(
            backgroundColor: themeChooserBG(context, appTheme),
            title: Text(
              "Change Password",
              style: Theme.of(context).textTheme.headline6,
            ),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left_rounded,
                color: searchIconColor(context, appTheme),
              ),
              onPressed: () {
                SetStatusBarAndNavBarColor().accountScreen(context, appTheme);
                Navigator.of(context).pop();
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    SetStatusBarAndNavBarColor().mainUI(context, appTheme);
                    Navigator.of(rootContext).pop();
                  },
                  child: Text("Done")),
            ],
          ),
        ));
      },
    );
  }
}
