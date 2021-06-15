import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:thingaha/util/style_constants.dart';

class MainLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'images/loading.svg',
            semanticsLabel: 'Reading from memory card.',
            width: 200,
            height: 200,
          ),
          SizedBox(
            width: 36,
            height: 36,
            child: LoadingIndicator(
              indicatorType: Indicator.ballBeat,
              color: kPrimaryColor,
            ),
          ),
          Text(
            "Reading from memory card.\nPlease do not remove memory card.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    ));
  }
}

class StudentsLoadingWidget extends StatelessWidget {
  final String message;

  StudentsLoadingWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulseRise,
              color: kPrimaryColor,
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}

class AttendanceLoadingWidget extends StatelessWidget {
  final String message;

  AttendanceLoadingWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: LoadingIndicator(
                indicatorType: Indicator.orbit,
                color: kPrimaryColor,
              ),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}

class SchoolsLoading extends StatelessWidget {
  final String message;

  SchoolsLoading({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: LoadingIndicator(
              indicatorType: Indicator.ballSpinFadeLoader,
              color: kPrimaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
    );
  }
}
