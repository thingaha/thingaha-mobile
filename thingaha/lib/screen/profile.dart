import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingaha/helper/custom_appbar.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/helper/reusable_widget.dart';
import 'package:thingaha/helper/title_and_text_with_column.dart';
import 'package:thingaha/model/donor.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: txt_profile),
      body: _buildProfile()
    );
  }

  Widget _buildProfile() {

    //TODO: Get data from API
    Donor donor = Donor();
    donor.name = "Khine Khine";
    donor.email = "khinekhine123@gmail.com";
    donor.country = "Myanmar";
    donor.address = "Lorem ipsum dolor sit amet";

    Widget name = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Text(
            donor.name,
            style: GoogleFonts.merriweather(
                textStyle: TextStyle(
                    fontSize: 30
                )
            )
        ),
      ),
    );

    Widget info = Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: CustomCardView(
        cardView: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              TitleAndTextWithColumn(title: txt_email, text: donor.email),
              TitleAndTextWithColumn(title: txt_country, text: donor.country),
              TitleAndTextWithColumn(title: txt_address, text: donor.address)
            ],
          ),
        ),
      ),
    );

    Widget changePassword = Container(
      margin: EdgeInsets.symmetric(vertical: 25.0),
      child: MaterialButton(
        onPressed: () {},
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            txt_change_password,
            textAlign: TextAlign.center,
            style: TextStyle().copyWith(
                color: Colors.white,
                fontSize: 16.0
            ),
          ),
        ),
      ),
    );

    return Container(
      child: Column(
        children: [
          name,
          info,
          changePassword
        ],
      ),
    )
    ;
  }

}