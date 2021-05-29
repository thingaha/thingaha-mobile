import 'package:flutter/material.dart';

class CustomCardView extends StatelessWidget {
  final Widget cardView;
  final double borderRadius;
  final Function onPress;
  
  CustomCardView({@required this.cardView, this.borderRadius, this.onPress});
  
  @override
  Widget build(BuildContext context) {
    double defaultRadius = 10.0;

    return GestureDetector(
      onTap: onPress,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? defaultRadius),
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