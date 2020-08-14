import 'package:flutter/material.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class ReusableCard extends StatelessWidget {
  final Widget cardChild;

  final double height;
  final double width;
  ReusableCard({this.cardChild, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return Container(
      height: height,
      width: width,
      child: Center(
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.all(
            Radius.circular(screenSize.screenHeight * 1),
          ),
          child: cardChild,
        ),
      ),
    );
  }
}
