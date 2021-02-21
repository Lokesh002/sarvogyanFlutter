import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sarvogyan/Screens/profile/ResultScreen.dart';

import 'package:sarvogyan/components/getAllExams.dart';
import 'package:sarvogyan/components/getExamQuestions.dart';

import 'package:sarvogyan/components/reusableScreens/reusableQuestionScreen1.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/utilities/userData.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:quiver/async.dart';

class UpdatedExamScreen extends StatefulWidget {
  final Exam exam;
  final List<Question> questionList;
  UpdatedExamScreen(this.questionList, this.exam);
  @override
  _UpdatedExamScreenState createState() => _UpdatedExamScreenState();
}

class _UpdatedExamScreenState extends State<UpdatedExamScreen> {
  SizeConfig screenSize;
  List<Question> questionList;
  double x = 0.0;
  int currentPage = 0;
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
    else {
      return Text('');
    }
  }

  void submit() {
    int score = 0;
    print('answer');
    print(answers);

    //ACTUAL CODE GOES HERE
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ResultScreen(answers, questionList, widget.exam);
    }));
  }

  int getIconType(String ques) {
    if (answers[ques] == null) {
      if (markedQuestions[ques] == null || markedQuestions[ques] == false)
        return 1;
      else if (markedQuestions[ques] == true) return 4;
    } else if (answers[ques].isEmpty) {
      if (markedQuestions[ques] == null || markedQuestions[ques] == false)
        return 3;
      else if (markedQuestions[ques] == true) return 4;
    } else {
      if (markedQuestions[ques] == true)
        return 5;
      else
        return 2;
    }
    return 1;
  }

  Widget getIcon(String ques, int a) {
    switch (a) {
      case 1:
        return Container(
          width: screenSize.screenWidth * 8,
          height: screenSize.screenHeight * 4,
          child: Material(
            color: Colors.grey,
            child: Center(
              child: Text(
                ques,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            borderRadius: BorderRadius.circular(screenSize.screenHeight * 0.5),
          ),
        );
        break;
      case 2:
        return Container(
          width: screenSize.screenWidth * 8,
          height: screenSize.screenHeight * 4,
          child: Material(
            color: Colors.green,
            child: Center(
              child: Text(
                ques,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            borderRadius: BorderRadius.circular(screenSize.screenHeight * 0.5),
          ),
        );
        break;
      case 3:
        return Container(
          width: screenSize.screenWidth * 8,
          height: screenSize.screenHeight * 4,
          child: Material(
            color: Colors.red,
            child: Center(
              child: Text(
                ques,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            borderRadius: BorderRadius.circular(screenSize.screenHeight * 0.5),
          ),
        );
        break;
      case 4:
        return Container(
          width: screenSize.screenWidth * 8,
          height: screenSize.screenHeight * 4,
          child: Material(
            color: Colors.purpleAccent,
            child: Center(
              child: Text(
                ques,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            borderRadius: BorderRadius.circular(screenSize.screenHeight * 0.5),
          ),
        );
        break;
      case 5:
        return Container(
          width: screenSize.screenWidth * 8,
          height: screenSize.screenHeight * 4,
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.lightGreen,
            width: 3,
          )),
          child: Material(
            color: Colors.purpleAccent,
            child: Center(
              child: Text(
                ques,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
        break;
      default:
        return Container(child: Text('abcd'));
    }
  }

  Future<String> showStatus(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Status'),
            content: Container(
              height: screenSize.screenHeight * 80,
              width: screenSize.screenWidth * 80,
              child: Column(children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.screenWidth),
                ),
                Container(
                  width: screenSize.screenWidth * 80,
                  height: screenSize.screenHeight * 4,
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.screenWidth * 2),
                          child: getIcon('1', 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.screenWidth * 2),
                        child: Text(
                          'Not Visited',
                          style:
                              TextStyle(fontSize: screenSize.screenHeight * 2),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Container(
                  width: screenSize.screenWidth * 80,
                  height: screenSize.screenHeight * 4,
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.screenWidth * 2),
                          child: getIcon('1', 2)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.screenWidth * 2),
                        child: Text(
                          'Answered',
                          style:
                              TextStyle(fontSize: screenSize.screenHeight * 2),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Container(
                  width: screenSize.screenWidth * 80,
                  height: screenSize.screenHeight * 4,
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.screenWidth * 2),
                          child: getIcon('1', 3)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.screenWidth * 2),
                        child: Text(
                          'Not Answered',
                          style:
                              TextStyle(fontSize: screenSize.screenHeight * 2),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Container(
                  width: screenSize.screenWidth * 80,
                  height: screenSize.screenHeight * 4,
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.screenWidth * 2),
                          child: getIcon('1', 4)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.screenWidth * 2),
                        child: Text(
                          'Marked for review',
                          style:
                              TextStyle(fontSize: screenSize.screenHeight * 2),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Container(
                  width: screenSize.screenWidth * 80,
                  height: screenSize.screenHeight * 4,
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.screenWidth * 2),
                          child: getIcon('1', 5)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.screenWidth * 2),
                        child: Text(
                          'Answered and Marked for Review',
                          style: TextStyle(
                              fontSize: screenSize.screenHeight * 1.5),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Container(
                  width: screenSize.screenWidth * 80,
                  height: screenSize.screenHeight * 36,
                  child: ListView(
                    children: [
                      Container(
                        width: screenSize.screenWidth * 80,
                        height: screenSize.screenHeight * 36,
                        child: GridView.count(
                          // Create a grid with 2 columns. If you change the scrollDirection to
                          // horizontal, this produces 2 rows.
                          crossAxisCount: 6,
                          // Generate 100 widgets that display their index in the List.
                          children: List.generate(widget.questionList.length,
                              (index) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.screenWidth * 0.5,
                                    vertical: screenSize.screenHeight * 0.3),
                                child: GestureDetector(
                                    onTap: () {
                                      print(answers[(index + 1).toString()]);
                                      pageViewController.jumpToPage(index);
                                      Navigator.pop(context);
                                    },
                                    child: getIcon((index + 1).toString(),
                                        getIconType((index + 1).toString()))),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Done'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  @override
  void dispose() {
    //countDownTimer.cancel();
    super.dispose();
    scrollController.dispose();
    pageViewController.dispose();
    if (widget.exam.examType == 'timed') sub.cancel();
    markedQuestions.clear();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    if (widget.exam.examType == 'timed') startTimer();
  }

  @override
  Widget build(BuildContext context) {
    questionList = widget.questionList;

    screenSize = SizeConfig(context);
    return WillPopScope(
      onWillPop: () async {
        answers.clear();
        markedQuestions.clear();
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
                            width: screenSize.screenWidth * 40,
                          ),
                          timer(),
                          SizedBox(
                            width: widget.exam.examType != 'timed'
                                ? screenSize.screenWidth * 20
                                : screenSize.screenWidth * 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              showStatus(context);
                            },
                            child: Icon(Icons.apps),
                          ),
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
                  height: screenSize.screenHeight * 70,
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
                      currentPage = index;

                      print('current ' + currentPage.toString());
                      print(markedQuestions);
                      if (mounted && widget.exam.examType != 'timed') {
                        scrollController.addListener(() {
                          setState(() {});
                        });
                        pageViewController.addListener(() {
                          setState(() {});
                        });
                      }
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
                SizedBox(
                  height: screenSize.screenHeight * 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                print(currentPage);

                                if (currentPage != 0)
                                  pageViewController
                                      .jumpToPage(currentPage - 1);
                              });
                            },
                            child: Container(
                              color: Colors.black54,
                              //height: screenSize.screenHeight * 20,
                              width: screenSize.screenWidth * 20,
                              height: screenSize.screenHeight * 5,
                              child: Center(
                                  child: Text(
                                "< Prev",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              print(currentPage);
                              if (currentPage + 1 < questionList.length)
                                pageViewController.jumpToPage(currentPage + 1);
                            },
                            child: Container(
                              color: Colors.black54,
                              //height: screenSize.screenHeight * 20,
                              width: screenSize.screenWidth * 20,
                              height: screenSize.screenHeight * 5,
                              child: Center(
                                  child: Text(
                                "Next >",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          print('ans');
                          print(answers);
                          //countDownTimer.cancel();
                          if (widget.exam.examType == 'timed') sub.cancel();
                          submit();
                        },
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          //height: screenSize.screenHeight * 20,
                          width: screenSize.screenWidth * 20,
                          height: screenSize.screenHeight * 8,
                          child: Center(
                              child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
