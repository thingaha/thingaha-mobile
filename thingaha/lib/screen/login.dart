import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),  // onBackPress => exit the app
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
      )
    );
  }

  Widget _buildLoginFields() {
    final emailTextField = _buildTextField(txt_email, false);

    final passwordTextField = _buildTextField(txt_password, true);

    final loginButton = Material(
      color: shadeGreyColor,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: () {
          if(_formKey.currentState.validate()) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          }
        },
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
        ),
        child: Text(
          txt_login,
          textAlign: TextAlign.center,
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 16.0
          ),
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
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.only(left: 10.0, bottom: 0.0),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black54)
          ),
        ),
        obscureText: isPassword,
      ),
    );
  }
}
