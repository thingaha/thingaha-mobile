import 'package:flutter/material.dart';
import 'package:thingaha/model/student_donation_status.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/screen/student_info.dart';
import 'package:thingaha/util/string_constants.dart';

class MonthlyStatus extends StatelessWidget {
  final StudentDonationStatus studentStatus;

  MonthlyStatus({@required this.studentStatus});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double cardViewHeight = height - 120;

    return Column(
      children: [
        CustomCardView(
            borderRadius: 0.0,
            onPress: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => StudentInfo()));
            },
            cardView: Container(
              width: MediaQuery.of(context).size.width,
              height: cardViewHeight,
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStudentInfo(context),

                    Container(
                      padding: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 10.0),
                      child: Text(txt_monthly_donation_status),
                    ),

                    Column(
                      children: _buildMonthlyStatus(context),
                    ),
                  ],
                ),
              ),
            )
        )
      ],
    );
  }

  Widget _buildStudentInfo(context) {
    String name = txt_name + " : " + studentStatus.name;
    String grade = txt_grade + " : " + studentStatus.grade;
    String dateOfBirth = txt_date_of_birth + " : " + studentStatus.dateOfBirth;

    return CustomCardView(
        cardView: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                grade,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                dateOfBirth,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        )
    )
    ;
  }

  List<Widget> _buildMonthlyStatus(context) {
    List<Widget> statusWidgets =  studentStatus.donationStatus.map((donation) => CustomCardView(
        cardView: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                txt_month + " : " + donation.month,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                txt_amount + " : " + donation.amount,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                txt_date + " : " + donation.date,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              textStatus(donation.status, donation.donated)
            ],
          ),
        )
      )
    ).toList();

    return statusWidgets;
  }

  Widget textStatus(status, donated) {
    String text = txt_status + " : " + donated;
    Widget widget;
    if (status) {
      widget = Text(
        text,
        style: TextStyle(fontSize: 16),
      );
    }
    else {
      widget = Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.red),
      );
    }
    return widget;
  }

}