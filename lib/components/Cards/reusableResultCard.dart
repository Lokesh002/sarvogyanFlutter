import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarvogyan/components/Cards/ReusableCard.dart';
import 'package:sarvogyan/components/Cards/courseCard.dart';
import 'package:sarvogyan/components/pieChart.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class ReusableResultCard extends StatelessWidget {
  final String examName;
  final double totalMarks;
  final double score;

  final Color color;

  ReusableResultCard({this.totalMarks, this.score, this.color, this.examName});

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
                  Container(
                    color: Colors.black26,
                    height: screenSize.screenHeight * 14,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: screenSize.screenWidth * 5,
                        ),
                        Center(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: screenSize.screenWidth * 10,
                                child: CustomPaint(
                                  child: Center(),
                                  foregroundPainter: PieChart(
                                      width: screenSize.screenWidth * 5,
                                      percentage: score / totalMarks,
                                      score: score,
                                      totalMarks: totalMarks,
                                      marks: [
                                        score / totalMarks,
                                        1 - score / totalMarks
                                      ]),
                                ),
                                height: screenSize.screenWidth * 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenSize.screenWidth * 4,
                        ),
                      ],
                    ),
                  ),
//                  SizedBox(
//                    width: screenSize.screenWidth * 15,
//                    height: screenSize.screenWidth * 15,
//
//                      child: PieChart(
//                        marks: [score/totalMarks,1-score/totalMarks],
//                        totalMarks: totalMarks,
//                        score: score,
//                        percentage: score/totalMarks,
//                        width: screenSize.screenHeight*5
//                      ),
                  SizedBox(
                    width: screenSize.screenWidth * 4,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: screenSize.screenHeight * 3,
                      ),
                      Container(
                        width: screenSize.screenWidth * 70,
                        child: Text(
                          '$examName',
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenSize.screenHeight * 2.5,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.screenHeight * 1,
                      ),
                      Text(
                        this.score.toStringAsFixed(0) +
                            " / " +
                            this.totalMarks.toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: screenSize.screenHeight * 3,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        height: screenSize.screenHeight * 3,
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
