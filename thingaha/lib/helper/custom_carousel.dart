import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


int _current = 0;

class CustomCarousel extends StatefulWidget {
  final List<Widget> items;

  CustomCarousel({@required this.items});

  @override
  _CustomCarouselState createState() => new _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double carouselHeight = height - 110;

    return Column(
      children: [
        CarouselSlider(
            items: widget.items,
            options: CarouselOptions(
                height: carouselHeight,
                autoPlay: false,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }
            )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.items.map((item) {
            int index = widget.items.indexOf(item);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    )
    ;
  }
  
}