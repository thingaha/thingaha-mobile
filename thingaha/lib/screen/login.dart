import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/util/api_strings.dart';
import 'package:thingaha/util/network.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isDialOpen = ValueNotifier(false);

    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Consumer(builder: (context, ref, child) {
          final appTheme = ref(appThemeProvider);
          return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 10.0, left: 20.0, right: 20.0),
                  color: cardBackgroundColor(context, appTheme),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 64.0, top: 150.0),
                        child: Image.asset(
                          logoImage(context, appTheme),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: _buildLoginFields(appTheme))
                    ],
                  ),
                ),
              ));
        }),
        floatingActionButton: buildSpeedDial(),
      ),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      /// both default to 16
      marginEnd: 18,
      marginBottom: 20,

      // animatedIcon: AnimatedIcons.menu_close,
      // animatedIconTheme: IconThemeData(size: 22.0),
      /// This is ignored if animatedIcon is non null
      icon: Icons.settings_rounded,
      activeIcon: Icons.close,
      // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),

      /// The label of the main button.
      // label: Text("Open Speed Dial"),
      /// The active label of the main button, Defaults to label if not specified.
      // activeLabel: Text("Close Speed Dial"),
      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
      buttonSize: 56.0,
      visible: true,

      /// If true user is forced to close dial manually
      /// by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: lighterDarkColor,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),

      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      children: [
        SpeedDialChild(
          child: Icon(Icons.translate),
          backgroundColor: Colors.grey[200],
          label: 'change_language'.tr(),
          labelStyle: TextStyle(fontSize: 12.0),
          onTap: () {
            if (EasyLocalization.of(context).locale.toString() == "my_MM")
              EasyLocalization.of(context).setLocale(Locale("en", "US"));
            else
              EasyLocalization.of(context).setLocale(Locale("my", "MM"));
          },
          onLongPress: () => print('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(EvaIcons.moonOutline),
          backgroundColor: Colors.grey[200],
          label: 'change_theme'.tr(),
          labelStyle: TextStyle(fontSize: 12.0),
          onTap: () {},
          onLongPress: () => print('SECOND CHILD LONG PRESS'),
        ),
      ],
    );
  }

  Widget _buildLoginFields(appTheme) {
    final emailTextField =
        _buildTextField("txtfield_lbl_email".tr(), false, appTheme);

    final passwordTextField =
        _buildTextField("txtfield_lbl_pwd".tr(), true, appTheme);

    final loginButton = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            login(context, emailController.text, pwdController.text);
          }
        },
        //minWidth: MediaQuery.of(context).size.width,

        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              EdgeInsets.only(top: 15.0, bottom: 15.0)),
          backgroundColor:
              MaterialStateProperty.all(primaryColors(context, appTheme)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
        ),
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
                "btn_lbl_login".tr(),
                textAlign: TextAlign.center,
                style: TextStyle().copyWith(
                    fontFamilyFallback: ['Sanpya'],
                    color: buttonTextColor(context, appTheme),
                    fontSize: 16.0),
              ),
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          emailTextField,
          SizedBox(height: 20),
          passwordTextField,
          SizedBox(height: 30),
          loginButton,
          (_isLoading)
              ? Container(
                  margin: EdgeInsets.only(top: 32.0),
                  child: Text(
                    "Shovelling coal into the server ...",
                    style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).textTheme.subtitle2.color),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, bool isPassword, appTheme) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return txt_login_error_msg;
        }
        return null;
      },
      style: Theme.of(context).textTheme.subtitle2,
      controller: (isPassword) ? pwdController : emailController,
      keyboardType: (isPassword)
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.subtitle2,
        contentPadding: EdgeInsets.only(left: 10.0, bottom: 0.0),
        filled: true,
        fillColor: textFieldFillColor(context, appTheme),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor(context, appTheme)),
            borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColors(context, appTheme)),
            borderRadius: BorderRadius.circular(12)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12)),
      ),
      obscureText: isPassword,
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

  login(context, email, password) async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    //var data = {"email_or_username": "moemoe@gmail.com", "password": "123"};
    var data = {"email_or_username": email, "password": password};

    // This connects to the server and logs in the user.
    var loginResponse = await Network().authData(data, APIs.loginURL);
    // This decodes the JSON format replied from the server.
    var body = json.decode(loginResponse.body);

    // TODO: Delete this line in Production.
    print(loginResponse.body);

    // If a credential or something is wrong, error will throw.
    if (body['errors'] != null) {
      showErrorDialog(context, body['errors'][0]['reason'],
          body['errors'][0]['description']);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // This means that there's nothing wrong and the server responds success.
    var accessToken = body['data']['access_token'];
    print(accessToken);
    var userID = body['data']['user']['id'];
    if (accessToken != null) {
      // This saves the access token in device's local storage
      localStorage.setString(StaticStrings.keyAccessToken, accessToken);
      localStorage.setInt(StaticStrings.keyUserID, userID);
      // context.read(userIDProvider).state.set(userID);
      localStorage.setBool(StaticStrings.keyLogInStatus, true);
    }

    setState(() {
      _isLoading = false;
    });

    // If everything that has to be done is done, we go to home screen.
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Home())); //Show error dialog.
  }
}
