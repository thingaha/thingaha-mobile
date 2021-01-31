import 'package:flutter/material.dart';

class CustomCardView extends StatelessWidget {
  final Widget cardView;
  final double borderRadius;
  final Function onPress;
  
  CustomCardView({@required this.cardView, this.borderRadius, this.onPress});
  
  @override
  Widget build(BuildContext context) {
    double radius = borderRadius == null? 10.0 : borderRadius;

    return GestureDetector(
      onTap: onPress,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // if you need this
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: cardView,
      ),
    );
  }
  
}