import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:sarvogyan/Screens/exams/examListScreen.dart';
import 'package:sarvogyan/Screens/search/filterCourseScreen.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/lists/course_List.dart';
import 'package:sarvogyan/components/courseListData.dart';
import 'package:sarvogyan/lists/allCategory_list.dart';
import 'package:sarvogyan/components/getAllExams.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sarvogyan/Screens/exams/takeExamLoadingScreen.dart';
import 'package:sarvogyan/components/getAllExams.dart';
import 'package:sarvogyan/components/Cards/reusableExamCard.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class ExamListLoadingScreen extends StatefulWidget {
  String userId;
  List<Exam> examList;
//  String selectedCourse;
//  ExamListLoadingScreen(this.selectedCourse);
  @override
  _ExamListLoadingScreenState createState() => _ExamListLoadingScreenState();
}

class _ExamListLoadingScreenState extends State<ExamListLoadingScreen> {
  bool isReady = false;
  CourseModel courseModel = CourseModel();
  AllCategoryList clist;
  SavedData savedData = SavedData();

  Course_List clst;
  void getExamList() async {
    List<Exam> examList;
    GetAllExams getAllExams = GetAllExams();
    examList = await getAllExams.getExamList("all");
    String UserId = await savedData.getAccessToken();
//    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
//      return ExamListScreen(examList, UserId);
//    }));
    widget.userId = UserId;
    widget.examList = examList;
    allExamList = examList;
    isReady = true;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (mounted) getExamList();
    //getLocation();
  }

  SizeConfig screenSize;

  List<Exam> examsList;

  Widget ShowScreen(bool isReady) {
    if (!isReady) {
      return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: SpinKitWanderingCubes(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          size: 100.0,
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: screenSize.screenHeight * 1,
              ),
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Container(
                      height: screenSize.screenHeight * 80,
                      child: ListView.builder(
                          itemBuilder: (BuildContext cntxt, int index) {
                            return ReusableExamCard(
                              examName: allExamList[index].examName,
                              examTime: allExamList[index].examTime,
                              examPicture: allExamList[index].examPicture,
                              examDesc: allExamList[index].examDescription,
                              totalQuestion: allExamList[index].totalQuestions,
                              onTap: () {
                                setState(() {
                                  if (signedIn) {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return TakeExamLoadingScreen(
                                          allExamList[index]);
                                    }));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Please login first.");
                                  }
                                });
                              },
                            );
                          },
                          itemCount: allExamList.length,
                          padding: EdgeInsets.fromLTRB(
                              0, screenSize.screenHeight * 2.5, 0, 0
                              //screenSize.screenHeight * 15)),
                              ))),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    examsList = widget.examList;
    screenSize = SizeConfig(context);
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: ShowScreen(isReady),
    );
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
