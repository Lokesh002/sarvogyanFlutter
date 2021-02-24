import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/exams/takeExamLoadingScreen.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/Cards/reusableCourseCard.dart';
import 'package:sarvogyan/components/Cards/reusableExamCard.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/courseTree.dart';
import 'package:sarvogyan/components/getAllExams.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class Exams extends StatefulWidget {
  var decData;
  Exams(this.decData);

  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {
  SizeConfig screenSize;
  List<Exam> examList;
  bool isReady = false;
  bool generateCertificate = false;
  SavedData savedData = SavedData();
  String getQuery(List<dynamic> metaCategories) {
    String query = " ";
    for (int i = 0; i < metaCategories.length; i++) {
      query = query + metaCategories[i].toString() + ' ';
    }
    print('query: ' + query.trim());
    return query.trim();
  }

  void getResults() async {
    Networking networking = Networking();
    var examResultApiResponse = await networking.getDataWithToken(
        'api/user/getExamResult/', await savedData.getAccessToken());
    List examResultResponse = examResultApiResponse;
    log(examResultApiResponse.toString());
    double totalMarks = 0;
    double marks = 0;
    int completedExams = 0;
    bool isDone = false;
    for (int i = 0; i < examList.length; i++) {
      for (int j = 0; j < examResultResponse.length; j++) {
        if (examList[i].examId == examResultResponse[j]['id']) {
          totalMarks += examResultResponse[j]['totalMarks'];
          marks += examResultResponse[j]['marks'];
          completedExams += 1;
        }
      }
    }
    if (completedExams == examList.length) {
      isDone = true;
      if (marks / totalMarks >= 0.75) {
        generateCertificate = true;
      } else {
        generateCertificate = false;
      }
    } else {
      generateCertificate = false;
    }
  }

  void generateCert() async {
    if (generateCertificate) {
      Networking networking = Networking();
      var data = await networking.postData('api/document/generateCertificate', {
        'uName': await savedData.getName(),
        'cName': widget.decData['name'],
        'uid': await savedData.getUserId()
      });

      log(data.toString());

      isReady = true;
      setState(() {});
    }
  }

  void getExamList() async {
    print('heheheh ' + widget.decData.toString());
    userId = await savedData.getAccessToken();
    GetAllExams getAllExams = GetAllExams();
    examList = await getAllExams
        .getExamList(getQuery(widget.decData['metaCategories']));

    await getResults();
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
            : !generateCertificate
                ? Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenSize.screenHeight * 2,
                        ),
                        Container(
                            height: screenSize.screenHeight * 75,
                            child: ListView.builder(
                                itemBuilder: (BuildContext cntxt, int index) {
                                  return ReusableExamCard(
                                    examName: examList[index].examName,
                                    examTime: examList[index].examTime,
                                    examPicture: examList[index].examPicture ==
                                                null ||
                                            examList[index].examPicture == ""
                                        ? 'images/flogo.png'
                                        : examList[index].examPicture,
                                    examType: examList[index].examType,
                                    examDesc: examList[index].examDescription,
                                    totalQuestion:
                                        examList[index].totalQuestions,
                                    onTap: () {
                                      setState(() {
                                        if (signedIn) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
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
                  )
                : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenSize.screenHeight * 10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.screenWidth * 3),
                          child: Text(
                            'Congratulations! \n\nYou have successfully completed all the Exams of this course.\n \nYou are now eligible to get Certificate of this course.\n\n',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: screenSize.screenHeight * 3),
                          ),
                        ),
                        Center(
                          child: Container(
                            child: ReusableButton(
                              height: screenSize.screenHeight * 10,
                              width: screenSize.screenWidth * 30,
                              onPress: () async {
                                setState(() {
                                  isReady = false;
                                });
                                generateCert();
                              },
                              content: 'Generate Certificate',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
      );
  }
}
