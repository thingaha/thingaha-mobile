import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/util/style_constants.dart';
import 'package:thingaha/widgets/appbar.dart';
import 'package:thingaha/widgets/bottom_sheet.dart';

class AllStudents extends StatefulWidget {
  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  ScrollController _scrollController;
  bool _isScrolled = false;
  @override
  void initState() {
    super.initState();
    context.read(fetchDisplayNamefromLocalProvider);
    context.read(fetchDonationList);
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 48.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final appTheme = watch(appThemeProvider);
        return watch(studentPageCount).when(
          loading: () => _studentLoading("Swapping Time and Space ..."),
          error: (err, stack) => _studentError(err, stack),
          data: (itemCount) {
            print("student Page is $itemCount pages long.");
            return NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, isInnerBoxScrolled) {
                  return [
                    ThingahaAppBar(
                      appTheme: appTheme,
                      isScrolled: _isScrolled,
                      screenIndex: 2,
                      title: "Students",
                    ),
                  ];
                },
                body: ListView(
                  children: List.generate(itemCount, (index) {
                    return Consumer(
                      builder: (context, watch, child) {
                        return watch(studentPage(index)).when(
                            loading: () => Container(
                                  width: 100,
                                  height: 200,
                                  child: _studentLoading(
                                      "Changing lightbulb #$index"),
                                ),
                            error: (err, stack) => _studentError(err, stack),
                            data: (att) {
                              var list = att.data.students.toList();
                              print("List is ${list.length} long");
                              return GridView.count(
                                childAspectRatio:
                                    (250 / 350), // (Width / Height)
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                children: List.generate(
                                    list.length,
                                    (listIndex) => Container(
                                          margin: EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                              color: cardBackgroundColor(
                                                  context, appTheme),
                                              border: Border.all(
                                                  color: borderColor(
                                                      context, appTheme)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: boxShadowColor(
                                                      context, appTheme),
                                                  offset: Offset(0, 1),
                                                )
                                              ]),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 175,
                                                height: 180,
                                                margin: EdgeInsets.all(16.0),
                                                decoration: BoxDecoration(
                                                    color: (list[listIndex]
                                                                .photo !=
                                                            "")
                                                        ? Colors.transparent
                                                        : studentPhotoDummyColor(
                                                            context, appTheme),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12.0))),
                                                child: (list[listIndex].photo !=
                                                        "")
                                                    ? ClipRRect(
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        child: Image.network(
                                                            list[listIndex]
                                                                .photo),
                                                      )
                                                    : Center(
                                                        child: Text(
                                                            "Student Photo"),
                                                      ),
                                              ),
                                              Text(
                                                list[listIndex].name,
                                                style: TextStyle(
                                                    fontFamilyFallback: [
                                                      'Sanpya',
                                                    ],
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .color),
                                              ),
                                            ],
                                          ),
                                        )),
                              );
                            });
                      },
                    );
                  }),
                ));
          },
        );
      },
    );
  }

  _studentLoading(String message) {
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

  _studentError(err, stack) {
    print(stack);
    String assetName = 'images/bug.svg';
    return Center(
      child: SvgPicture.asset(assetName,
          semanticsLabel: 'Oops! Something went wrong.'),
    );
  }
}
