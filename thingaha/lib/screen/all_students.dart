import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:thingaha/helper/custom_appbar.dart';
import 'package:thingaha/helper/custom_cardview.dart';
import 'package:thingaha/model/providers.dart';
import 'package:thingaha/screen/student_per_year.dart';
import 'package:thingaha/util/string_constants.dart';
import 'package:thingaha/util/style_constants.dart';

//TODO: Get data from API
List<String> years = ["2017", "2018", "2019", "2020"];

class AllStudents extends StatefulWidget {
  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  ScrollController _scrollController;
  bool _isScrolled = false;
  @override
  void initState() {
    // TODO: implement initState
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
        return watch(studentPageCount).when(
          loading: () => _studentLoading("Swapping Time and Space ..."),
          error: (err, stack) => _studentError(err, stack),
          data: (itemCount) {
            print("student Page is $itemCount pages long.");
            return NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, isInnerBoxScrolled) {
                  return [_buildSliverAppBar()];
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
                                      "Changing a new lightbulb..."),
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
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey[200]),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[200],
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
                                                        : Colors.grey[200],
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
                                              Text(list[listIndex].name),
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

  _buildSliverAppBar() {
    return SliverAppBar(
        pinned: true,
        backgroundColor: _isScrolled ? kAppBarLightColor : Colors.white,
        expandedHeight: 80,
        title: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _isScrolled ? 1.0 : 0.0,
          curve: Curves.ease,
          child: Text("Students",
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.lato().fontFamily,
              )),
        ),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 16.0),
              child: IconButton(
                  icon: Icon(Icons.search_rounded), onPressed: () {})),
        ],
        automaticallyImplyLeading: false,
        elevation: _isScrolled ? 1.5 : 0,
        flexibleSpace: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _isScrolled ? 0.0 : 1.0,
          curve: Curves.ease,
          child: Container(
            padding: EdgeInsets.only(left: 32.0, top: 92.0, right: 32.0),
            child: Text("Students",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: GoogleFonts.lato().fontFamily,
                )),
          ),
        ));
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
