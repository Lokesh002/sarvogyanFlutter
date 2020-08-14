import 'package:flutter/material.dart';
import 'package:sarvogyan/components/ReusableCard.dart';
import 'package:sarvogyan/components/courseCard.dart';
import 'package:sarvogyan/components/reusableCourseCard.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class ReusableExamCard extends StatelessWidget {
  final String examName;
  final int examTime;
  final String examType;
  final int totalQuestion;
  final String examDesc;

  final Function onTap;
  final Function onChangeTap;

  ReusableExamCard(
      {this.examName,
      this.examTime,
      this.examDesc,
      this.totalQuestion,
      this.examType,
      this.onTap,
      this.onChangeTap});
  IconData getIcon() {
    if (examType == 'timed') {
      return Icons.timer;
    }
    return Icons.border_color;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              CourseCard(
                color: Theme.of(context).accentColor,
                width: screenSize.screenWidth * 95,
                cardChild: Row(
                  children: <Widget>[
                    SizedBox(
                      width: screenSize.screenWidth * 5,
                    ),
                    Icon(
                      getIcon(),
                      size: screenSize.screenHeight * 4,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: screenSize.screenWidth * 3,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: screenSize.screenHeight * 2.3,
                        ),
                        Text(
                          '$examName',
                          style: TextStyle(
                              fontSize: screenSize.screenHeight * 2,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                        Container(
                          child: Text(
                            '$examDesc',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: screenSize.screenHeight * 1.7,
                              color: Color(0xff7f7f7f),
                            ),
                          ),
                          //],
                          // ),
                          height: screenSize.screenHeight * 2,
                          width: screenSize.screenWidth * 75,
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                        Container(
                          width: screenSize.screenWidth * 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Time: $examTime',
                                style: TextStyle(
                                  fontSize: screenSize.screenHeight * 1.7,
                                  color: Color(0xff7f7f7f),
                                ),
                              ),
                              Text(
                                '$totalQuestion Questions',
                                style: TextStyle(
                                  fontSize: screenSize.screenHeight * 1.7,
                                  color: Color(0xff7f7f7f),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 2.3,
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
        ],
      ),
    );
  }
}
