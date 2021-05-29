import 'package:flutter/material.dart';
import 'package:thingaha/model/student_donation_status.dart';
import 'package:thingaha/widgets/custom_cardview.dart';
import 'package:thingaha/screen/student_info.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';

class MonthlyStatus extends StatelessWidget {
  final StudentDonationStatus studentStatus;

  MonthlyStatus({@required this.studentStatus});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double cardViewHeight = height;

    return Column(
      children: [
        CustomCardView(
            borderRadius: 0.0,
            onPress: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StudentInfo()));
            },
            cardView: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStudentInfo(context),
                    Container(
                      padding:
                          EdgeInsets.only(left: 10.0, top: 30.0, bottom: 10.0),
                      child: Text(
                        txt_monthly_donation_status,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: _buildMonthlyStatus(context),
                      ),
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }

  Widget _buildStudentInfo(context) {
    String name = studentStatus.name;
    String grade = studentStatus.grade;
    String dateOfBirth = "born on " + studentStatus.dateOfBirth;
    String profileURL = studentStatus.profileUrl;

    return CustomCardView(
        cardView: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: [
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              profileURL,
              fit: BoxFit.contain,
              height: 100,
              width: 100,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                grade,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 10),
              Text(
                dateOfBirth,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  List<Widget> _buildMonthlyStatus(context) {
    List<Widget> statusWidgets = studentStatus.donationStatus
        .map((donation) => CustomCardView(
                cardView: Container(
              width: 150,
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donation.month,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    donation.amount + " Ks",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    donation.date,
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 10),
                  textStatus(donation.status, donation.donated)
                ],
              ),
            )))
        .toList();

    return statusWidgets;
  }

  Widget textStatus(status, donated) {
    String text = donated;
    Widget widget;
    if (status) {
      widget = Text(
        text,
        style: TextStyle(fontSize: 16, color: kPrimaryColor),
      );
    } else {
      widget = Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.red),
      );
    }
    return widget;
  }
}
