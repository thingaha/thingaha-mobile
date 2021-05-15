import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return WillPopScope(
        onWillPop: () => SystemChannels.platform
            .invokeMethod('SystemNavigator.pop'), // onBackPress => exit the app
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20.0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Image.asset('images/logo.png'),
                _buildLoginFields()
              ],
            ),
          ),
        ));
  }

  Widget _buildLoginFields() {
    final emailTextField = _buildTextField(txt_email, false);

    final passwordTextField = _buildTextField(txt_password, true);

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
          backgroundColor: MaterialStateProperty.all(kPrimaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          ),
        ),
        child: (_isLoading)
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              )
            : Text(
                txt_login,
                textAlign: TextAlign.center,
                style:
                    TextStyle().copyWith(color: Colors.white, fontSize: 16.0),
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
          loginButton
        ],
      ),
    );
  }

  Widget _buildTextField(String label, bool isPassword) {
    return Material(
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return txt_login_error_msg;
          }
          return null;
        },
        controller: (isPassword) ? pwdController : emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.only(left: 10.0, bottom: 0.0),
          filled: true,
          fillColor: Colors.grey[50],
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300])),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        ),
        obscureText: isPassword,
      ),
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
    // TODO: Implement Dialog box to show the error.
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
