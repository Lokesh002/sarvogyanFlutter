import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/exams/takeExamLoadingScreen.dart';
import 'package:sarvogyan/components/Cards/reusableCourseCard.dart';
import 'package:sarvogyan/components/Cards/reusableExamCard.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/courseTree.dart';
import 'package:sarvogyan/components/getAllExams.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class AllExamsScreen extends StatefulWidget {
  String query;
  CourseTreeNode node;
  AllExamsScreen(this.query, this.node);

  @override
  _AllExamsScreenState createState() => _AllExamsScreenState();
}

class _AllExamsScreenState extends State<AllExamsScreen> {
  SizeConfig screenSize;
  List<Exam> examList;
  bool isReady = false;
  SavedData savedData = SavedData();
  void getExamList() async {
    userId = await savedData.getAccessToken();
    GetAllExams getAllExams = GetAllExams();
    examList = await getAllExams.getExamList(widget.query);

    examList = examList;

    isReady = true;
    if (mounted) setState(() {});
  }

  String userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExamList();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    if (!isReady)
      return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: SpinKitWanderingCubes(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          size: 100.0,
        ),
      );
    else
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.node.value),
        ),
        body: examList.length == 0
            ? Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: screenSize.screenHeight * 10,
                    ),
                    Container(
                      height: screenSize.screenHeight * 20,
                      child: SvgPicture.asset('svg/noCourses.svg',
                          semanticsLabel: 'A red up arrow'),
                    ),
                    SizedBox(
                      height: screenSize.screenHeight * 5,
                    ),
                    Text(
                      "No Exams Present",
                    ),
                    SizedBox(
                      height: screenSize.screenHeight * 20,
                    ),
                  ],
                ),
              )
            : Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenSize.screenHeight * 5,
                    ),
                    Container(
                        height: screenSize.screenHeight * 80,
                        child: ListView.builder(
                            itemBuilder: (BuildContext cntxt, int index) {
                              return ReusableExamCard(
                                examName: examList[index].examName,
                                examTime: examList[index].examTime,
                                examPicture: examList[index].examPicture,
                                examDesc: examList[index].examDescription,
                                totalQuestion: examList[index].totalQuestions,
                                onTap: () {
                                  setState(() {
                                    if (signedIn) {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        print(examList[index].examId);
                                        return TakeExamLoadingScreen(
                                            examList[index]);
                                      }));
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Please login first.");
                                    }
                                  });
                                },
                              );
                            },
                            itemCount: examList.length,
                            padding: EdgeInsets.fromLTRB(
                                0, screenSize.screenHeight * 2.5, 0, 0
                                //screenSize.screenHeight * 15)),
                                ))),
                  ],
                ),
              ),
      );
  }
}
