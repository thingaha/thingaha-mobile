import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kPrimaryColor = Color(0xFF00B900);
const kAppBarWhiteWithALittleTransparency = Color(0xeeffffff);
const kappBarDark = Color(0xff1a1a1a);
const shadeGreyColor = Color(0x90ffffff);

const highElevatedDark = Color(0xff1E1F22);
const darkBottomAppBarColor = Color(0xff201F21);
const lowFlatDark = Color(0xff18171B);
const darkBackgroundColor = Color(0xff1F2124);
const kprimaryDarkColor = Color(0xff90EE90);
const darkAppBarShadowColor = Color(0xff323133);
const lighterDarkColor = Color(0xff292B2E);

const cloudColor = Color(0xfff6f6f6);
const ccColor = Color(0xff525252);

const navBarIconColorLight = Color(0xff5f6369);

Color borderColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Colors.grey[200]
      : darkAppBarShadowColor;
}

Color appBarColor(context, isScrolled, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? kAppBarWhiteWithALittleTransparency
      : darkAppBarColor(context, isScrolled, selectedAppTheme);
}

Color darkAppBarColor(context, isScrolled, selectedAppTheme) {
  return (isScrolled)
      ? cardBackgroundColor(context, selectedAppTheme)
      : darkBackgroundColor;
}

Color boxShadowColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Colors.grey[200]
      : Colors.transparent;
}

Color cardBackgroundColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Colors.white
      : highElevatedDark;
}

Color greyCardBackgroundColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Color(0xffefeef0)
      : Color(0xff1f1e22);
}

Color studentPhotoDummyColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Colors.grey[200]
      : lighterDarkColor;
}

Color textFieldFillColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Colors.grey[50]
      : lighterDarkColor;
}

Color primaryColors(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? kPrimaryColor
      : kprimaryDarkColor;
}

IconData bottomAppBarIcon(itemIndex, screenIndex) {
  return (itemIndex == 0)
      ? (screenIndex == 0)
          ? Icons.local_library_rounded
          : Icons.local_library_outlined
      : (itemIndex == 1)
          ? (screenIndex == 1)
              ? Icons.menu_book_rounded
              : Icons.menu_book_outlined
          : (itemIndex == 2)
              ? (screenIndex == 2)
                  ? Icons.badge
                  : Icons.badge
              : (screenIndex == 3)
                  ? Icons.school_rounded
                  : Icons.school_outlined;
}

Color searchIconColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? navBarIconColorLight
      : Colors.grey;
}

Color bottomAppBarIconColor(context, itemIndex, screenIndex, appTheme) {
  return (screenIndex == itemIndex)
      ? Theme.of(context).primaryColor
      : (appTheme == ThemeMode.light ||
              appTheme == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness ==
                      Brightness.light) // Light Theme Or System Light theme
          ? navBarIconColorLight
          : Colors.grey;
}

Color bottomAppBarTextColor(context, itemIndex, screenIndex, appTheme) {
  return (screenIndex == itemIndex)
      ? Theme.of(context).primaryColor
      : (appTheme == ThemeMode.light ||
              appTheme == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness ==
                      Brightness.light) // Light Theme Or System Light theme
          ? navBarIconColorLight
          : Colors.grey;
}

Brightness appStatusBarIconBrightness(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Brightness.dark
      : Brightness.light;
}

String logoImage(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? 'images/logo_jedi.png'
      : 'images/logo_sith.png';
}

Color moneyStatusColor(context, status, selectedAppTheme) {
  return (status == 'pending')
      ? (selectedAppTheme == ThemeMode.light ||
              selectedAppTheme == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness == Brightness.light)
          ? Colors.red
          : Colors.red.shade300
      : Colors.green;
}

Color modalSheetBackgroundColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Colors.white
      : Color(0xff18171b);
}

Color modalSheetAppBarColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Colors.white
      : Color(0xff1d1c20);
}

Color dividerColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Color(0xffdddcde)
      : Color(0xff403f43);
}

Color buttonTextColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Colors.white
      : Colors.black;
}

Color themeChooserBG(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Color(0xfff7f7f7)
      : Color(0xff0e0d0f);
}

Color themeChooserColumn(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Colors.white
      : Color(0xff18171b);
}

class SetStatusBarAndNavBarColor {
  void accountScreen(context, appTheme) {
    SystemChrome.setSystemUIOverlayStyle((appTheme == ThemeMode.light ||
            appTheme == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.light)
        ? SystemUiOverlayStyle(
            //statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle(
            //statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xff18171b),
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
          ));
  }

  void themeChooser(context, appTheme) {
    SystemChrome.setSystemUIOverlayStyle((appTheme == ThemeMode.light ||
            appTheme == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.light)
        ? SystemUiOverlayStyle(
            //statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xfff7f7f7),
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle(
            //statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xff0e0d0f),
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
          ));
  }

  void mainUI(context, appTheme) {
    SystemChrome.setSystemUIOverlayStyle((appTheme == ThemeMode.light ||
            appTheme == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.light)
        ? SystemUiOverlayStyle(
            //statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle(
            //statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: highElevatedDark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
          ));
  }
}
