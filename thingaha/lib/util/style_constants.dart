import 'package:flutter/material.dart';

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

Color studentPhotoDummyColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Colors.grey[200]
      : lighterDarkColor;
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
                  ? Icons.account_circle_rounded
                  : Icons.account_circle_outlined;
}

Color searchIconColor(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Colors.black
      : Colors.grey;
}

Color bottomAppBarIconColor(context, itemIndex, screenIndex, appTheme) {
  return (screenIndex == itemIndex)
      ? Theme.of(context).primaryColor
      : (appTheme == ThemeMode.light ||
              appTheme == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness ==
                      Brightness.light) // Light Theme Or System Light theme
          ? Colors.black
          : Colors.grey;
}

Brightness appStatusBarIconBrightness(context, selectedAppTheme) {
  return (selectedAppTheme == ThemeMode.light ||
          selectedAppTheme == ThemeMode.system &&
              MediaQuery.of(context).platformBrightness == Brightness.light)
      ? Brightness.dark
      : Brightness.light;
}
