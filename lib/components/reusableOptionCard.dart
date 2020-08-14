import 'package:flutter/material.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class ReusableOptionCard extends StatelessWidget {
  final Widget cardChild;
  final double elevation;
  final double height;
  final double width;
  final Color color;
  ReusableOptionCard(
      {this.cardChild, this.height, this.width, this.elevation, this.color});

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return Container(
      height: height,
      width: width,
      child: Center(
        child: Material(
          color: color,
          elevation: elevation,
          borderRadius: BorderRadius.all(
            Radius.circular(screenSize.screenHeight * 1),
          ),
          child: cardChild,
        ),
      ),
    );
  }
}
