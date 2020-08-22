import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sarvogyan/Screens/ResultScreen.dart';
import 'package:sarvogyan/components/ReusableCard.dart';
import 'package:sarvogyan/components/getAllExams.dart';
import 'package:sarvogyan/components/getExamQuestions.dart';
import 'package:collection/collection.dart';
import 'package:sarvogyan/components/reusableQuestionScreen1.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/utilities/userData.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:quiver/async.dart';

class ExamScreen extends StatefulWidget {
  String userId;
  Exam exam;
  List<Question> questionList;
  ExamScreen(this.userId, this.questionList, this.exam);
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  SizeConfig screenSize;
  List<Question> questionList;
  double x = 0.0;
  PageController pageViewController =
      PageController(viewportFraction: 1, keepPage: true);
  ScrollController scrollController = ScrollController();
  Color colour = Colors.white;
  double ind = 0;
  var sub;
  int _start;
  int _hours;
  int _minutes;
  int _seconds;
  int _current;
  CountdownTimer countDownTimer;
  GlobalKey<PageContainerState> key = GlobalKey();
  void startTimer() {
    _current = widget.exam.examTime;
    _start = widget.exam.examTime;
    _hours = _start ~/ 3600;
    _minutes = _start ~/ 60;
    _seconds = _start % 60;
    countDownTimer = new CountdownTimer(
      new Duration(hours: _hours, minutes: _minutes, seconds: _seconds),
      new Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      if (this.mounted)
        setState(() {
          _current = _start - duration.elapsed.inSeconds;
        });
      else
        return;
    });
    if (this.mounted)
      sub.onDone(() {
        print("Done");
        countDownTimer.cancel();
        submit();
        sub.cancel();
      });
    else
      return;
  }

  Widget timer() {
    if (widget.exam.examType == 'timed')
      return Row(
        children: <Widget>[
          Text(
            (_current ~/ 3600).toString() + ' : ',
            style: TextStyle(
              color: Colors.black,
              fontSize: screenSize.screenHeight * 2,
              fontFamily: "Roboto",
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            (_current ~/ 60).toString() + ' : ',
            style: TextStyle(
              color: Colors.black,
              fontSize: screenSize.screenHeight * 2,
              fontFamily: "Roboto",
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            (_current % 60).toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: screenSize.screenHeight * 2,
              fontFamily: "Roboto",
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    else
      return Text('');
  }

  void submit() {
    int score = 0;
    print('answer');
    print(answers);
//    Map getAnswer = answers;
//    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
//
//    for (int i = 0; i < getAnswer.length; i++) {
//      if (unOrdDeepEq(
//          getAnswer['${(i + 1).toString()}'], questionList[i].answer)) score++;
//    }
//    print('get');
//    print(getAnswer);

//    print(score);
    //countDownTimer.cancel();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ResultScreen(answers, questionList.length, widget.exam.examId);
    }));
  }

  @override
  void dispose() {
    //countDownTimer.cancel();
    super.dispose();
    scrollController.dispose();
    pageViewController.dispose();
    if (widget.exam.examType == 'timed') sub.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    if (widget.exam.examType == 'timed') {
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    questionList = widget.questionList;

    screenSize = SizeConfig(context);
    return WillPopScope(
      onWillPop: () async {
        answers.clear();
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(screenSize.screenHeight * 3),
                  ),
                  elevation: 5,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: screenSize.screenHeight * 7,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: screenSize.screenWidth * 10,
                          ),
                          Text(
                            "Test",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenSize.screenHeight * 3.5,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: screenSize.screenWidth * 50,
                          ),
                          timer(),
//                          Text(
//                            (_current ~/ 3600).toString() + ' : ',
//                            style: TextStyle(
//                              color: Colors.black,
//                              fontSize: screenSize.screenHeight * 2,
//                              fontFamily: "Roboto",
//                              fontWeight: FontWeight.bold,
//                            ),
//                          ),
//                          Text(
//                            (_current ~/ 60).toString() + ' : ',
//                            style: TextStyle(
//                              color: Colors.black,
//                              fontSize: screenSize.screenHeight * 2,
//                              fontFamily: "Roboto",
//                              fontWeight: FontWeight.bold,
//                            ),
//                          ),
//                          Text(
//                            (_current % 60).toString(),
//                            style: TextStyle(
//                              color: Colors.black,
//                              fontSize: screenSize.screenHeight * 2,
//                              fontFamily: "Roboto",
//                              fontWeight: FontWeight.bold,
//                            ),
//                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenSize.screenHeight * 1.7,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenSize.screenHeight * 1,
                ),
                Container(
                  alignment: Alignment.center,
                  height: screenSize.screenHeight * 8,
                  width: screenSize.screenWidth * 100,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: screenSize.screenWidth * 2.5,
                        right: screenSize.screenWidth * 2.5),
                    child: ListView.builder(
                        controller: scrollController,
                        //shrinkWrap: true,
                        itemBuilder: (BuildContext cntxt, int index) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: screenSize.screenWidth * 2.5,
                                  right: screenSize.screenWidth * 2.5),
                              child: GestureDetector(
                                onTap: () {
                                  pageViewController.jumpToPage(index);
                                  colour = Theme.of(context).primaryColor;
                                  setState(() {});
                                  ind = pageViewController.page;
                                },
                                child: Material(
                                  color: index.toDouble() == ind
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                  elevation: 3,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: screenSize.screenWidth * 10,
                                    height: screenSize.screenHeight * 8,
                                    child: Center(child: Text("${index + 1}")),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: questionList.length,
                        padding: EdgeInsets.fromLTRB(
                            0,
                            screenSize.screenHeight * 1,
                            0,
                            screenSize.screenHeight * 1)),
                  ),
                ),
                SizedBox(
                  height: screenSize.screenHeight * 1,
                ),
                Container(
                  width: double.infinity,
                  height: screenSize.screenHeight * 72.5,
                  child: PageView.builder(
                    controller: pageViewController,
                    onPageChanged: (value) {
                      setState(() {
                        ind = value.toDouble();
                        print(ind);

                        print('ind: $ind');
                        print('x: $x');
                        if ((ind) > (x + 5.0)) {
                          if (ind < x + 5.0) {
                            x = x + 5.0;
                            print('x changed to: $x');
                          }
                          if (ind > x + 5.0) {
                            int quotient = (ind / 5.0).floor();
                            x = 5.0 * quotient;
                            print('x changed to: $x');
                          }
                          scrollController
                              .jumpTo((x) * screenSize.screenWidth * 15);
                        }
                        if ((ind) < (x)) {
                          int quotient = (ind / 5.0).floor();
                          x = 5.0 * quotient;
                          scrollController
                              .jumpTo((x) * screenSize.screenWidth * 15);

                          print('x changed to: $x');
                        }
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ReusableQuestionScreen1(
                        onTap: () {},
                        questionNo: questionList[index].questionNo,
                        question: questionList[index].questiontype == 'picture'
                            ? questionList[index].link
                            : questionList[index].question,
                        questionTyp: questionList[index].questiontype,
                        option1: questionList[index].option1,
                        option2: questionList[index].option2,
                        option3: questionList[index].option3,
                        option4: questionList[index].option4,
                        answer: questionList[index].answer,
                      );
                    },
                    itemCount: questionList.length,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('ans');
                    print(answers);
                    //countDownTimer.cancel();
                    if (widget.exam.examType == 'timed') sub.cancel();
                    submit();

//                    int score = 0;
//                    Map getAnswer = answers;
//                    Function unOrdDeepEq =
//                        const DeepCollectionEquality.unordered().equals;
//
//                    for (int i = 0; i < getAnswer.length; i++) {
//                      if (unOrdDeepEq(getAnswer['${(i + 1).toString()}'],
//                          questionList[i].answer)) score++;
//                    }
//                    print(getAnswer);
//                    answers.clear();
//                    print(score);
//                    Navigator.pushReplacement(context,
//                        MaterialPageRoute(builder: (context) {
//                      return ResultScreen(score, questionList.length);
//                    }));
                  },
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    //height: screenSize.screenHeight * 20,
                    width: double.infinity,
                    height: screenSize.screenHeight * 8,
                    child: Center(
                        child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ],
            ),

//            SizedBox(
//              height: screenSize.screenHeight * 1,
//            ),
//            Stack(
//              alignment: AlignmentDirectional.bottomCenter,
//              children: <Widget>[
//                Container(
//                  height: screenSize.screenHeight * 89,
//                  child: ListView.builder(
//                      itemBuilder: (BuildContext cntxt, int index) {
//                        return ReusableExamCard(
//                          examName: questionList[index].question,
//                          //examTime: examsList[index].question,
//                          //examType: questionList[index].questionNo,
//                          examDesc: questionList[index].answer,
//                          //totalQuestion: examsList[index].totalQuestions,
//                          onTap: () {
//                            setState(() {
////                                        Navigator.push(context,
////                                            MaterialPageRoute(
////                                                builder: (context) {
////                                          return DetailLoadingScreen(
////                                              veh[index].id);
////                                        }));
//                            });
//                          },
//                        );
//                      },
//                      itemCount: questionList.length,
//                      padding: EdgeInsets.fromLTRB(
//                          0,
//                          screenSize.screenHeight * 2.5,
//                          0,
//                          screenSize.screenHeight * 15)),
//                ),
////                          Column(
////                            children: <Widget>[
////                              Row(
////                                mainAxisAlignment: MainAxisAlignment.center,
////                                children: <Widget>[
////                                  Visibility(
////                                    visible: !signedIn,
////                                    child: ReusableButton(
////                                        onPress: () {
////                                          Navigator.push(context,
////                                              MaterialPageRoute(
////                                                  builder: (context) {
////                                            return Login(true);
////                                          }));
////                                        },
////                                        content: "Sign In",
////                                        height: screenSize.screenHeight * 7,
////                                        width: screenSize.screenWidth * 20),
////                                  ),
////                                  Visibility(
////                                    visible: !signedIn,
////                                    child: SizedBox(
////                                      width: screenSize.screenWidth * 10,
////                                    ),
////                                  ),
////                                  Visibility(
////                                    visible: !signedIn,
////                                    child: ReusableButton(
////                                        onPress: () {
////                                          Navigator.pushNamed(
////                                              context, '/registerUser');
////                                        },
////                                        content: "Sign Up",
////                                        height: screenSize.screenHeight * 7,
////                                        width: screenSize.screenWidth * 20),
////                                  ),
////                                  Visibility(
////                                    visible: signedIn,
////                                    child: ReusableButton(
////                                        onPress: () {
////                                          Navigator.pushNamed(
////                                              context, '/profile');
////                                        },
////                                        content: "Profile",
////                                        height: screenSize.screenHeight * 7,
////                                        width: screenSize.screenWidth * 20),
////                                  ),
////                                  Visibility(
////                                    visible: signedIn,
////                                    child: SizedBox(
////                                      width: screenSize.screenWidth * 10,
////                                    ),
////                                  ),
////                                  Visibility(
////                                    visible: signedIn,
////                                    child: ReusableButton(
////                                        onPress: () {
////                                          Navigator.pushNamed(
////                                              context, '/ExamLoadingScreen');
////                                        },
////                                        content: "Exam List",
////                                        height: screenSize.screenHeight * 7,
////                                        width: screenSize.screenWidth * 20),
////                                  ),
////                                ],
////                              ),
//              ],
//            ),
//          ],
//        ),
//      ),
          )),
    );
  }
}
