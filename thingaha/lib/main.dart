import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/screen/splash.dart';
import 'package:thingaha/util/constants.dart';
import 'package:thingaha/util/keys.dart';
import 'package:thingaha/util/style_constants.dart';

void main() => runApp(ProviderScope(child: MyApp()));

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
        print(theme);
        return MaterialApp(
            navigatorKey: navKey,
            title: APP_NAME,
            themeMode: theme,
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primaryColor: kPrimaryColor,
                fontFamily: GoogleFonts.nunito().fontFamily,
                appBarTheme: AppBarTheme(
                  backgroundColor: kAppBarWhiteWithALittleTransparency,
                  brightness: Brightness.light,
                ),
                textTheme: TextTheme(
                  headline4: TextStyle(
                    color: Colors.black,
                  ),
                  headline5: TextStyle(
                    color: Colors.black,
                  ),
                  headline6: TextStyle(
                    color: Colors.black,
                  ),
                )),
            darkTheme: ThemeData(
              scaffoldBackgroundColor: darkBackgroundColor,
              primaryColor: kprimaryDarkColor,
              fontFamily: GoogleFonts.nunito().fontFamily,

              //Text Themes
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  color: Colors.white,
                ),
                subtitle2: TextStyle(
                  color: Colors.white,
                ),
                headline4: TextStyle(
                  color: Colors.white,
                ),
                headline5: TextStyle(
                  color: Colors.white,
                ),
                headline6: TextStyle(
                  color: Colors.white,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),

              //AppBar theme
              appBarTheme: AppBarTheme(
                backgroundColor: darkBackgroundColor,
                brightness: Brightness.dark,
              ),

              //Bottom Navigation Bar Theme
              bottomAppBarColor: highElevatedDark,
            ),
            home: Splash());
      },
    );
  }
}
