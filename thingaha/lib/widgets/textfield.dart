import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';

class ThingahsTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  ThingahsTextField({Key key, this.label, this.isPassword, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final appTheme = ref(appThemeProvider);
      return TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return txt_login_error_msg;
          }
          return null;
        },
        style: Theme.of(context).textTheme.subtitle2,
        //controller: (isPassword) ? pwdController : emailController,
        controller: controller,
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
    });
  }
}
