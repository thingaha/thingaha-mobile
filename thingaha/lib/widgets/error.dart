import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thingaha/util/logout.dart';

class ErrorMessageWidget extends StatelessWidget {
  final errorMessage;
  final log;

  ErrorMessageWidget({Key key, this.errorMessage, this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String assetName = 'images/bug.svg';
    print(log);
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          assetName,
          semanticsLabel: 'Oops! Something went wrong.',
          width: 200,
          height: 200,
        ),
        Text(
          "Oops! Something went wrong.",
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    )));
  }
}

class SomeThingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String assetName = 'images/blank.svg';
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: SizedBox(
            height: 500,
            width: 500,
            child: SvgPicture.asset(assetName,
                semanticsLabel: 'Oops! Something went wrong.'),
          ),
        ),
        Container(child: Text("There's no data... hmmm...")),
        ElevatedButton.icon(
          onPressed: logout(),
          label: Text("Logout"),
          icon: Icon(Icons.login_rounded),
        ),
      ],
    ));
  }
}
