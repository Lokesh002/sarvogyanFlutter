import 'package:flutter/material.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class CourseCard extends StatelessWidget {
  final Widget cardChild;
  final Color color;
  final double height;
  final double width;
  CourseCard({this.cardChild, this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return Container(
      height: height,
      width: width,
      child: Center(
        child: Material(
          color: this.color,
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
