import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sarvogyan/components/Cards/reusableShowAnswerCard.dart';
import 'package:sarvogyan/components/Networking/networking.dart';

import 'package:sarvogyan/components/getAllExams.dart';
import 'package:sarvogyan/components/getExamQuestions.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class ShowResultsScreen extends StatefulWidget {
  final answers;
  final Exam exam;
  final List<Question> questionList;
  ShowResultsScreen(this.exam, this.questionList, this.answers);
  @override
  _ShowResultsScreenState createState() => _ShowResultsScreenState();
}

class _ShowResultsScreenState extends State<ShowResultsScreen> {
  SizeConfig screenSize;
  bool isReady = false;
  SavedData savedData = SavedData();
  String acsTkn;
  var answer;
  getData() async {
    print(widget.exam.examId);
    print(await savedData.getUserId());
    acsTkn = await savedData.getAccessToken();
    Networking networking = Networking();
    answer = await networking.getDataWithToken(
        'api/exam/getAnswersForResult/${widget.exam.examId}', acsTkn);
    print('answer ' + answer.toString());
    setState(() {
      isReady = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    if (!isReady) {
      return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: SpinKitWanderingCubes(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          size: 100.0,
        ),
      );
    } else
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.exam.examName),
        ),
        body: Container(
          height: screenSize.screenHeight * 100,
          child: ListView.builder(
              itemBuilder: (BuildContext cntxt, int index) {
                print(widget.answers.toString());
                return ReusableShowAnswerCard(
                  question: widget.questionList[index].question,
                  option1: widget.questionList[index].option1,
                  option2: widget.questionList[index].option2,
                  option3: widget.questionList[index].option3,
                  option4: widget.questionList[index].option4,
                  description: answer[(index + 1).toString()]['description'],
                  descriptionLink: answer[(index + 1).toString()]
                      ['descriptionLink'],
                  markedAnswer: widget.answers[(index + 1).toString()],
                  questionNo: index + 1,
                  answer: answer[(index + 1).toString()]['answer'],
                  questionLink: widget.questionList[index].link,
                );
              },
              itemCount: widget.questionList.length,
              padding: EdgeInsets.fromLTRB(0, screenSize.screenHeight * 2.5, 0,
                  screenSize.screenHeight * 2.5)),
        ),
      );
  }
}
