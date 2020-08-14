import 'package:flutter/material.dart';
import 'package:sarvogyan/components/ReusableCard.dart';
import 'package:sarvogyan/components/reusableOptionCard.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/utilities/userData.dart';

class ReusableQuestionScreen1 extends StatefulWidget {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final List<dynamic> answer;
  final String questionNo;

  final Function onTap;
  final Function onChangeTap;

  ReusableQuestionScreen1(
      {this.questionNo,
      this.question,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.answer,
      this.onTap,
      this.onChangeTap});
  @override
  _ReusableQuestionScreen1State createState() =>
      _ReusableQuestionScreen1State();
}

class _ReusableQuestionScreen1State extends State<ReusableQuestionScreen1> {
  bool option1selected = false;
  bool option2selected = false;
  bool option3selected = false;
  bool option4selected = false;
  double getElevation(bool a) {
    if (a == true) {
      return 0.0;
    }

    return 5.0;
  }

  Color getColor(bool a) {
    if (a == true) {
      return Theme.of(context).primaryColor;
    }

    return Colors.white;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (answers['${(widget.questionNo)}'] == null) {
      answers['${(widget.questionNo)}'] = List<dynamic>();
    } else {
      List ans;
      ans = answers['${(widget.questionNo)}'];
      for (int i = 0; i < ans.length; i++) {
        setState(() {
          String x = ans[i];
          if (x == '1')
            option1selected = true;
          else if (x == '2')
            option2selected = true;
          else if (x == '3')
            option3selected = true;
          else if (x == '4') option4selected = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return Row(
      children: <Widget>[
        SizedBox(
          width: screenSize.screenWidth * 10,
        ),
        Column(
          children: <Widget>[
            ReusableCard(
              width: screenSize.screenWidth * 80,
              height: screenSize.screenHeight * 78,
              cardChild: Container(
                color: Theme.of(context).accentColor,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: screenSize.screenWidth * 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: screenSize.screenHeight * 2.3,
                        ),
                        Container(
                          width: screenSize.screenWidth * 72,
                          height: screenSize.screenHeight * 25,
                          child: ListView(
                            children: <Widget>[
                              Text(
                                'Q${widget.questionNo}. ${widget.question}',
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: screenSize.screenHeight * 3,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (option1selected == false) {
                                option1selected = true;
//                              option2selected = false;
//                              option3selected = false;
//                              option4selected = false;

                                answers['${widget.questionNo}'].add('1');
                                print('${widget.questionNo}: $answers');
                              } else {
                                option1selected = false;
                                answers['${widget.questionNo}'].remove('1');
                                print('${widget.questionNo}: $answers');
                              }
                            });
                          },
                          child: ReusableOptionCard(
                            color: getColor(option1selected),
                            //height: screenSize.screenHeight * 20,
                            width: screenSize.screenWidth * 70,
                            elevation: getElevation(option1selected),
                            cardChild: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: screenSize.screenWidth * 5,
                                ),
                                Container(
                                  child: Center(
                                      child: Text(
                                    "A. ${widget.option1}",
                                    style: TextStyle(
                                        fontSize:
                                            screenSize.screenHeight * 2.5),
                                  )),
                                  height: screenSize.screenHeight * 10,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (option2selected == false) {
//                              option1selected = false;
                                option2selected = true;
//                              option3selected = false;
//                              option4selected = false;

                                answers['${widget.questionNo}'].add('2');
                                print('${widget.questionNo}: $answers');
                              } else {
                                option2selected = false;
                                answers['${widget.questionNo}'].remove('2');
                                print('${widget.questionNo}: $answers');
                              }
                            });
                          },
                          child: ReusableOptionCard(
                            color: getColor(option2selected),
                            //height: screenSize.screenHeight * 20,
                            elevation: getElevation(option2selected),
                            width: screenSize.screenWidth * 70,
                            cardChild: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: screenSize.screenWidth * 5,
                                ),
                                Container(
                                  child: Center(
                                      child: Text(
                                    "B. ${widget.option2}",
                                    style: TextStyle(
                                        fontSize:
                                            screenSize.screenHeight * 2.5),
                                  )),
                                  height: screenSize.screenHeight * 10,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (option3selected == false) {
//                              option1selected = false;
//                              option2selected = false;
                                option3selected = true;
//                              option4selected = false;

                                answers['${widget.questionNo}'].add('3');
                                print('${widget.questionNo}: $answers');
                              } else {
                                option3selected = false;
                                answers['${widget.questionNo}'].remove('3');
                                print('${widget.questionNo}: $answers');
                              }
                            });
                          },
                          child: ReusableOptionCard(
                            color: getColor(option3selected),
                            //height: screenSize.screenHeight * 20,
                            width: screenSize.screenWidth * 70,
                            elevation: getElevation(option3selected),
                            cardChild: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: screenSize.screenWidth * 5,
                                ),
                                Container(
                                  child: Center(
                                      child: Text(
                                    "C. ${widget.option3}",
                                    style: TextStyle(
                                        fontSize:
                                            screenSize.screenHeight * 2.5),
                                  )),
                                  height: screenSize.screenHeight * 10,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (option4selected == false) {
//                              option1selected = false;
//                              option2selected = false;
//                              option3selected = false;
                                option4selected = true;

                                answers['${widget.questionNo}'].add('4');
                                print('${widget.questionNo}: $answers');
                              } else {
                                option4selected = false;
                                answers['${widget.questionNo}'].remove('4');
                                print('${widget.questionNo}: $answers');
                              }
                            });
                          },
                          child: ReusableOptionCard(
                            color: getColor(option4selected),
                            //height: screenSize.screenHeight * 20,
                            width: screenSize.screenWidth * 70,
                            elevation: getElevation(option4selected),
                            cardChild: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: screenSize.screenWidth * 5,
                                ),
                                Container(
                                  child: Center(
                                      child: Text(
                                    "D. ${widget.option4}",
                                    style: TextStyle(
                                        fontSize:
                                            screenSize.screenHeight * 2.5),
                                  )),
                                  height: screenSize.screenHeight * 10,
                                ),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenSize.screenHeight * 2,
            )
          ],
        ),
        SizedBox(
          width: screenSize.screenWidth * 10,
        ),
      ],
    );
  }
}
