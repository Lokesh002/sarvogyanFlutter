import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarvogyan/components/Cards/ReusableCard.dart';
import 'package:sarvogyan/components/Cards/courseCard.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class ReusableShowAnswerCard extends StatelessWidget {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String description;
  final List<dynamic> markedAnswer;
  final questionNo;
  final List<dynamic> answer;
  final Function onTap;
  final Function onChangeTap;
  final Color color;
  final String questionLink;
  final String descriptionLink;
  ReusableShowAnswerCard(
      {this.description,
      this.questionNo,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.answer,
      this.markedAnswer,
      this.question,
      this.onTap,
      this.onChangeTap,
      this.color,
      this.questionLink,
      this.descriptionLink});

  SizeConfig screenSize;
  Widget getQuestion() {
    if (description == '') {
      return Container(
        width: screenSize.screenWidth * 95,
        child: (descriptionLink != null)
            ? Row(
                children: [
                  Text(
                    'Q$questionNo.',
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: screenSize.screenHeight * 2,
                        fontWeight: FontWeight.w300),
                  ),
                  Container(
                    width: screenSize.screenWidth * 75,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'images/logo.png',
                      image: this.questionLink,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              )
            : Image.asset(
                'images/logo.png',
                fit: BoxFit.contain,
              ),
      );
    } else {
      return Text(
        'Q$questionNo. $question',
        overflow: TextOverflow.clip,
        style: TextStyle(
            color: Colors.black,
            fontSize: screenSize.screenHeight * 2,
            fontWeight: FontWeight.w300),
      );
    }
  }

  Widget getDescription() {
    if (description == '') {
      return Container(
        width: screenSize.screenWidth * 95,
        child: (descriptionLink != null)
            ? FadeInImage.assetNetwork(
                placeholder: 'images/logo.png',
                image: this.descriptionLink,
                fit: BoxFit.contain,
              )
            : Image.asset(
                'images/logo.png',
                fit: BoxFit.contain,
              ),
      );
    } else {
      return Text(
        '$description',
        overflow: TextOverflow.clip,
        style: TextStyle(
            color: Colors.black,
            fontSize: screenSize.screenHeight * 2,
            fontWeight: FontWeight.w300),
      );
    }
  }

  Color getOptionColor(int n) {
    String num = n.toString();
    if (markedAnswer.contains(num) && !answer.contains(num)) {
      return Colors.redAccent;
    } else if (answer.contains(num)) {
      return Colors.lightGreenAccent;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    print(answer);
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: screenSize.screenWidth * 2.5),
          child: CourseCard(
            color: this.color,
            width: screenSize.screenWidth * 95,
            // height: screenSize.screenHeight * 10,
            cardChild: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize.screenWidth * 5,
                  vertical: screenSize.screenHeight * 2.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    child: getQuestion(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: screenSize.screenHeight * 2.3,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.screenWidth * 2,
                            vertical: screenSize.screenHeight * 1),
                        child: Container(
                          width: screenSize.screenWidth * 95,
                          child: Material(
                            color: getOptionColor(1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(screenSize.screenHeight * 2)),
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.screenWidth * 2,
                                  vertical: screenSize.screenHeight * 1),
                              child: Text(
                                'A. $option1',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.screenWidth * 2,
                            vertical: screenSize.screenHeight * 1),
                        child: Container(
                          width: screenSize.screenWidth * 95,
                          child: Material(
                            color: getOptionColor(2),
                            borderRadius: BorderRadius.all(
                                Radius.circular(screenSize.screenHeight * 2)),
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.screenWidth * 2,
                                  vertical: screenSize.screenHeight * 1),
                              child: Text(
                                'B. $option2',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.screenWidth * 2,
                            vertical: screenSize.screenHeight * 1),
                        child: Container(
                          width: screenSize.screenWidth * 95,
                          child: Material(
                            color: getOptionColor(3),
                            borderRadius: BorderRadius.all(
                                Radius.circular(screenSize.screenHeight * 2)),
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.screenWidth * 2,
                                  vertical: screenSize.screenHeight * 1),
                              child: Text(
                                'C. $option3',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.screenWidth * 2,
                            vertical: screenSize.screenHeight * 1),
                        child: Container(
                          width: screenSize.screenWidth * 95,
                          child: Material(
                            color: getOptionColor(4),
                            borderRadius: BorderRadius.all(
                                Radius.circular(screenSize.screenHeight * 2)),
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.screenWidth * 2,
                                  vertical: screenSize.screenHeight * 1),
                              child: Text(
                                'D. $option4',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.screenHeight * 1,
                      ),
                      Text(
                        'Description: ',
                        style: TextStyle(
                          fontSize: screenSize.screenHeight * 2,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        height: screenSize.screenHeight * 1,
                      ),
                      getDescription(),
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
          ),
        ),
        SizedBox(
          height: screenSize.screenHeight * 2,
        )
      ],
    );
  }
}
