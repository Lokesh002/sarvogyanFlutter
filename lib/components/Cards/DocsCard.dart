import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/Cards/ReusableCard.dart';
import 'package:sarvogyan/components/Cards/courseCard.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class ReusableDocsCard extends StatelessWidget {
  final String docName;

  final Color color;
  final Widget button;
  ReusableDocsCard({
    this.docName,
    this.button,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return Row(
      children: <Widget>[
        SizedBox(
          width: screenSize.screenWidth * 2.5,
        ),
        Column(
          children: <Widget>[
            CourseCard(
              color: this.color,
              width: screenSize.screenWidth * 95,
              // height: screenSize.screenHeight * 10,
              cardChild: Row(
                children: <Widget>[
                  SizedBox(
                    width: screenSize.screenWidth * 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: screenSize.screenHeight * 2.3,
                      ),
                      Container(
                        width: screenSize.screenWidth * 70,
                        child: Text(
                          '$docName',
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenSize.screenHeight * 2,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.screenHeight * 1,
                      ),
                      button,
                      SizedBox(
                        height: screenSize.screenHeight * 1,
                      ),
                      SizedBox(
                        height: screenSize.screenHeight * 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenSize.screenHeight * 2,
            )
          ],
        ),
        SizedBox(
          width: screenSize.screenWidth * 1,
        ),
      ],
    );
  }
}
