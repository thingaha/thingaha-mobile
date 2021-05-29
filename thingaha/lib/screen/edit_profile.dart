import 'package:flutter/material.dart';
import 'package:thingaha/widgets/custom_appbar.dart';
import 'package:thingaha/util/string_constants.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title:
              txt_edit_profile), // year name which was passed from all students year list
      body: Center(
        child: Text(txt_edit_profile),
      ),
    );
  }
}
