import 'package:flutter/material.dart';
import 'package:thingaha/widgets/reusable_widget.dart';
import 'package:thingaha/util/string_constants.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final Widget route;

  DrawerItem({@required this.title, this.route});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          onTap: () {
            Navigator.pop(context); //Close drawer

            if (title != txt_my_student && route != null) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => route));
            } else if (title == txt_logout) {
              //TODO: logout
            }
          },
        ),
        ReusableWidgets.getDivider(),
      ],
    );
  }
}
