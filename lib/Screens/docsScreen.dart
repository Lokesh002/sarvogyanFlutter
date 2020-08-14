import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class DocsScreen extends StatefulWidget {
  @override
  _DocsScreenState createState() => _DocsScreenState();
}

class _DocsScreenState extends State<DocsScreen> {
  SizeConfig screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return Column(
      children: <Widget>[
        SizedBox(
          height: screenSize.screenHeight * 10,
        ),
        Container(
          height: screenSize.screenHeight * 20,
          child: SvgPicture.asset('svg/analysis.svg',
              semanticsLabel: 'A red up arrow'),
        ),
        SizedBox(
          height: screenSize.screenHeight * 10,
        ),
      ],
    );
  }
}
