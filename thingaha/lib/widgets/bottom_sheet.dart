import 'dart:convert';
import 'dart:io';

import 'package:circle_flags/circle_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/screen/login.dart';
import 'package:thingaha/util/actions.dart';
import 'package:thingaha/util/api_strings.dart';
import 'package:thingaha/util/keys.dart';
import 'package:thingaha/util/network.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';
import 'package:thingaha/widgets/textfield.dart';

class ProfileAndSettings extends StatefulWidget {
  @override
  _ProfileAndSettingsState createState() => _ProfileAndSettingsState();
}

class _ProfileAndSettingsState extends State<ProfileAndSettings> {
  @override
  Widget build(BuildContext rootContext) {
    return Consumer(
      builder: (context, watch, child) {
        final appT = watch(appThemeProvider);
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
                          backgroundColor:
                              modalSheetAppBarColor(context, appTheme),
                          title: Text(
                            "page_title_account".tr(),
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
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                      fontFamilyFallback: ['Sanpya'],
                                      color: primaryColors(context, appTheme),
                                      fontWeight: FontWeight.w600),
                                )),
                          ],
                        ),
                        body: SingleChildScrollView(
                            child:
                                accountChild(rootContext, context, appTheme)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget accountChild(rootContext, context, appTheme) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
    //print("app theme after child is $appTheme");
    return Container(
      height: 210,
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
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleFlag(
                                (country != "") ? country : "united_nations",
                                size: 48),
                            ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      primaryColors(context, appTheme)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                  ),
                                ),
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit_rounded,
                                  size: 22,
                                  color: buttonTextColor(context, appTheme),
                                ),
                                label: Text(
                                  "btn_lbl_editprofile".tr(),
                                  style: TextStyle(
                                    fontFamilyFallback: [
                                      'Sanpya',
                                    ],
                                    fontWeight: FontWeight.bold,
                                    color: buttonTextColor(context, appTheme),
                                  ),
                                )),
                          ],
                        ),

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
                              color:
                                  Theme.of(context).textTheme.subtitle2.color,
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
                              color:
                                  Theme.of(context).textTheme.subtitle2.color,
                              fontFamilyFallback: [
                                'Sanpya',
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Widget settingsItem(rootContext, context, icon, title, appTheme, action) {
    //bool togg = EasyLocalization.of(context).locale.toString() == "my_MM";
    String countryCode = EasyLocalization.of(context).locale.countryCode;
    return ListTile(
      leading: Icon(icon, color: searchIconColor(context, appTheme)),
      onTap: () {
        switch (action) {
          case StaticStrings.keyActionLanguage:
            //languageChange.setLocale(Locale("my", "MM"));
            var locale = EasyLocalization.of(context).locale;
            print(locale);
            if (locale.toString() == "my_MM")
              EasyLocalization.of(context).setLocale(Locale("en", "US"));
            else
              EasyLocalization.of(context).setLocale(Locale("my", "MM"));

            Future.delayed(const Duration(milliseconds: 500), () {
              SetStatusBarAndNavBarColor().accountScreen(context, appTheme);
            });

            break;
          case StaticStrings.keyActionLogOut:
            logoutFromBottomSheet(context, rootContext, appTheme, navKey);
            break;
          case StaticStrings.keyActionTheme:
            SetStatusBarAndNavBarColor().themeChooser(context, appTheme);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    AppThemeSelector(rootContext: rootContext)));
            break;
          case StaticStrings.keyActionChangePassword:
            SetStatusBarAndNavBarColor().themeChooser(context, appTheme);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ChangePassword(rootContext: rootContext)));
            break;
          default:
        }
      },
      title: Text(
        title,
        style: TextStyle(
            fontFamilyFallback: ['Sanpya'],
            color: Theme.of(context).textTheme.subtitle2.color,
            fontWeight: FontWeight.w500),
      ),
      trailing: (action == StaticStrings.keyActionLanguage)
          ? Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      offset: Offset(0.25, 1),
                    )
                  ]),
              width: 25,
              height: 16,
              clipBehavior: Clip.hardEdge,
              child: Flag(
                countryCode,
              ),
            )
          : Icon(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 6.0,
          ),
          settingsItem(
              rootContext,
              context,
              Icons.info_outline_rounded,
              "list_title_aboutus".tr(),
              appTheme,
              StaticStrings.keyActionAboutUs),
          Divider(
            color: dividerColor(context, appTheme),
            thickness: 1.0,
          ),
          settingsItem(
              rootContext,
              context,
              Icons.translate_rounded,
              "list_title_language".tr(),
              appTheme,
              StaticStrings.keyActionLanguage),
          Divider(
            color: dividerColor(context, appTheme),
            thickness: 1.0,
          ),
          settingsItem(
              rootContext,
              context,
              Icons.vpn_key_rounded,
              "list_title_changepassword".tr(),
              appTheme,
              StaticStrings.keyActionChangePassword),
          Divider(
            color: dividerColor(context, appTheme),
            thickness: 1.0,
          ),
          settingsItem(
              rootContext,
              context,
              EvaIcons.moonOutline,
              "list_title_appearance".tr(),
              appTheme,
              StaticStrings.keyActionTheme),
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
          "list_title_logout".tr(), appTheme, StaticStrings.keyActionLogOut),
    );
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
          "list_title_appearance".tr(),
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
            child: Text(
              "Done",
              style: TextStyle(
                  fontFamilyFallback: ['Sanpya'],
                  color: primaryColors(context, appTheme),
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 24.0, bottom: 5.0),
            alignment: Alignment.centerLeft,
            child: Text("theme".tr(),
                style: TextStyle(
                    fontFamilyFallback: ['Sanpya'],
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
                    title: Text("jedi".tr(),
                        style: TextStyle(fontFamilyFallback: [
                          'Sanpya'
                        ], color: Theme.of(context).textTheme.subtitle2.color)),
                    value: ThemeMode.light,
                    groupValue: appTheme,
                    dense: true,
                    onChanged: (ThemeMode value) {
                      setAppTheme(
                          context, appTheme, appThemeChooser, value, true);
                    },
                  ),
                  Divider(
                    indent: 24.0,
                    endIndent: 24.0,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text("sith".tr(),
                        style: TextStyle(fontFamilyFallback: [
                          'Sanpya'
                        ], color: Theme.of(context).textTheme.subtitle2.color)),
                    value: ThemeMode.dark,
                    groupValue: appTheme,
                    dense: true,
                    onChanged: (ThemeMode value) {
                      setAppTheme(
                          context, appTheme, appThemeChooser, value, true);
                    },
                  ),
                  Divider(
                    indent: 24.0,
                    endIndent: 24.0,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text("system_theme".tr(),
                        style: TextStyle(fontFamilyFallback: [
                          'Sanpya'
                        ], color: Theme.of(context).textTheme.subtitle2.color)),
                    value: ThemeMode.system,
                    groupValue: appTheme,
                    dense: true,
                    onChanged: (ThemeMode value) {
                      setAppTheme(
                          context, appTheme, appThemeChooser, value, true);
                    },
                  ),
                ],
              )),
        ],
      ),
    ));
  }
}

class ChangePassword extends StatefulWidget {
  final BuildContext rootContext;

  ChangePassword({Key key, this.rootContext}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isLoading = false;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final appTheme = ref(appThemeProvider);
        final WidgetsBinding binding =
            WidgetsFlutterBinding.ensureInitialized();
        if (Platform.isAndroid) {
          //Android has a bug that the system auto re-color the nav bar.
          // see https://github.com/flutter/flutter/issues/40590
          binding.renderView.automaticSystemUiAdjustment = false;
        }
        return Material(
            child: Container(
          child: Scaffold(
              backgroundColor: themeChooserBG(context, appTheme),
              appBar: AppBar(
                backgroundColor: themeChooserBG(context, appTheme),
                title: Text(
                  "list_title_changepassword".tr(),
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
                    SetStatusBarAndNavBarColor()
                        .accountScreen(context, appTheme);
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        SetStatusBarAndNavBarColor().mainUI(context, appTheme);
                        Navigator.of(widget.rootContext).pop();
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                            fontFamilyFallback: ['Sanpya'],
                            color: primaryColors(context, appTheme),
                            fontWeight: FontWeight.w600),
                      )),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.all(32.0),
                      child: ThingahaTextField(
                        isPassword: true,
                        label: "txtfield_lbl_oldpwd".tr(),
                        controller: oldPasswordController,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 32.0, right: 32.0, bottom: 8.0, top: 16.0),
                      child: ThingahaTextField(
                        isPassword: true,
                        label: "txtfield_lbl_newpwd".tr(),
                        controller: newPasswordController,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 32.0, right: 32.0, bottom: 32.0, top: 8.0),
                      child: ThingahaTextField(
                        isPassword: true,
                        label: "txtfield_lbl_confirmpwd".tr(),
                        controller: confirmNewPasswordController,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(32.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.only(top: 15.0, bottom: 15.0)),
                          backgroundColor: MaterialStateProperty.all(
                              primaryColors(context, appTheme)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                        ),
                        onPressed: () {
                          updatePassword(
                              context,
                              widget.rootContext,
                              appTheme,
                              oldPasswordController.text,
                              newPasswordController.text,
                              confirmNewPasswordController.text);
                        },
                        child: (_isLoading)
                            ? SizedBox(
                                width: 32,
                                height: 32,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballClipRotatePulse,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "btn_save".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle().copyWith(
                                    fontFamilyFallback: ['Sanpya'],
                                    color: buttonTextColor(context, appTheme),
                                    fontSize: 16.0),
                              ),
                      ),
                    )
                  ],
                ),
              )),
        ));
      },
    );
  }

  showErrorDialog(context, title, message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  updatePassword(
      context, rootContext, appTheme, oldPwd, newPwd, confirmPwd) async {
    setState(() {
      _isLoading = true;
    });
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    var data = {
      "current_password": oldPwd,
      "new_password": newPwd,
      "new_confirm_password": confirmPwd
    };

    var updatePasswordResponse =
        await Network().putData(data, APIs.updatePassword);
    print(updatePasswordResponse.body);
    var body = json.decode(updatePasswordResponse.body);
    if (body['errors'] != null) {
      showErrorDialog(rootContext, body['errors'][0]['reason'],
          body['errors'][0]['description']);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (body['status'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("succ_pwd_change".tr()),
      ));

      setState(() {
        _isLoading = false;
      });
      SetStatusBarAndNavBarColor().accountScreen(context, appTheme);
      Navigator.of(context).pop();
    }
  }
}
