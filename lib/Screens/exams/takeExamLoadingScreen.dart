import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sarvogyan/Screens/exams/takeExamScreen.dart';
import 'package:sarvogyan/Screens/exams/updatedTakeExamScreen.dart';
import 'package:sarvogyan/components/getAllExams.dart';
import 'package:sarvogyan/components/getExamQuestions.dart';

class TakeExamLoadingScreen extends StatefulWidget {
  Exam exam;

  TakeExamLoadingScreen(this.exam);
  @override
  _TakeExamLoadingScreenState createState() => _TakeExamLoadingScreenState();
}

class _TakeExamLoadingScreenState extends State<TakeExamLoadingScreen> {
  List<Question> questionList;

  void getQues() async {
    print(widget.exam.examId);
    GetExamQuestions getExamQuestions = GetExamQuestions(widget.exam.examId);
    questionList = await getExamQuestions.getQuestions();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return UpdatedExamScreen(questionList, widget.exam);
    }));
  }

  @override
  void initState() {
    super.initState();
    getQues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: Container(
          child: SpinKitWanderingCubes(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
