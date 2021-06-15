import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/screen/splash.dart';
import 'package:thingaha/util/constants.dart';
import 'package:thingaha/util/keys.dart';
import 'package:thingaha/util/style_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  runApp(ProviderScope(
      child: EasyLocalization(
          supportedLocales: [Locale('en', 'US'), Locale('my', 'MM')],
          path:
              'assets/translations', // <-- change the path of the translation files
          fallbackLocale: Locale('en', 'US'),
          child: MyApp())));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = ref(appThemeProvider);

        final WidgetsBinding binding =
            WidgetsFlutterBinding.ensureInitialized();

        if (Platform.isAndroid) {
          //Android has a bug that the system auto re-color the nav bar.
          // see https://github.com/flutter/flutter/issues/40590
          binding.renderView.automaticSystemUiAdjustment = false;
        }

        return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: EasyLocalization.of(context).locale,
            navigatorKey: navKey,
            title: APP_NAME,
            themeMode: theme,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primaryColor: kPrimaryColor,
              fontFamily: GoogleFonts.nunito().fontFamily,
              appBarTheme: AppBarTheme(
                backgroundColor: kAppBarWhiteWithALittleTransparency,
                brightness: Brightness.light,
                elevation: 0,
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.dark,
                  systemNavigationBarColor: kAppBarWhiteWithALittleTransparency,
                  statusBarColor: kAppBarWhiteWithALittleTransparency,
                  statusBarIconBrightness: Brightness.dark,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
              ),
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  color: Colors.black,
                  fontFamilyFallback: ['Sanpya'],
                ),
                subtitle2: TextStyle(
                  color: Colors.black,
                  fontFamilyFallback: ['Sanpya'],
                ),
                headline4: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamilyFallback: ['Sanpya'],
                ),
                headline5: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamilyFallback: ['Sanpya'],
                ),
                headline6: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamilyFallback: ['Sanpya'],
                ),
              ),
              radioTheme: RadioThemeData(
                fillColor: MaterialStateProperty.all(kPrimaryColor),
              ),
              bottomAppBarColor: Colors.white,
            ),
            darkTheme: ThemeData(
                scaffoldBackgroundColor: darkBackgroundColor,
                primaryColor: kprimaryDarkColor,
                fontFamily: GoogleFonts.nunito().fontFamily,

                //Text Themes
                textTheme: TextTheme(
                  bodyText1: TextStyle(
                    color: Colors.white,
                    fontFamilyFallback: ['Sanpya'],
                  ),
                  subtitle2: TextStyle(
                    color: Colors.white,
                    fontFamilyFallback: ['Sanpya'],
                  ),
                  headline4: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamilyFallback: ['Sanpya'],
                  ),
                  headline5: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamilyFallback: ['Sanpya'],
                  ),
                  headline6: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamilyFallback: ['Sanpya'],
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),

                //AppBar theme
                appBarTheme: AppBarTheme(
                  backgroundColor: darkBackgroundColor,
                  brightness: Brightness.dark,
                  elevation: 0,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarBrightness: Brightness.light,
                    systemNavigationBarColor: highElevatedDark,
                    statusBarColor: darkBackgroundColor,
                    statusBarIconBrightness: Brightness.light,
                    systemNavigationBarIconBrightness: Brightness.light,
                  ),
                ),

                //Bottom Navigation Bar Theme
                bottomAppBarColor: highElevatedDark,
                radioTheme: RadioThemeData(
                  fillColor: MaterialStateProperty.all(kprimaryDarkColor),
                )),
            home: Splash());
      },
    );
  }
}
