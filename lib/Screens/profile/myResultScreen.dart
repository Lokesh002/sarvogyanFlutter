import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/profile/addMoney/applyCouponCode.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/components/Cards/ReusableCard.dart';
import 'package:sarvogyan/components/pieChart.dart';
import 'package:sarvogyan/components/Cards/reusableExamCard.dart';
import 'package:sarvogyan/components/Cards/reusableResultCard.dart';
import 'package:sarvogyan/utilities/userData.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/Screens/profile/addMoney/MakePaymentScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

class MyResultScreen extends StatefulWidget {
  @override
  _MyResultScreenState createState() => _MyResultScreenState();
}

class _MyResultScreenState extends State<MyResultScreen> {
  SizeConfig screenSize;
  bool isReady = false;
  SavedData savedData = SavedData();
  double totalScore = 0;
  double totalMarks = 0;
  double percentage = 0.0;
  List<TestResult> testResult = List<TestResult>();
  Widget showScreen(bool isReady, BuildContext context) {
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
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: screenSize.screenHeight * 45,
              floating: false,
              pinned: true,
              title: Text(
                "Top Results",
                style: TextStyle(
                    fontSize: screenSize.screenHeight * 3,
                    color: Theme.of(context).accentColor),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.screenHeight * 10,
                    bottom: screenSize.screenHeight * 10,
                  ),
                  child: Center(child: overallPerf(context)),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: ReusableResultCard(
                    color: Theme.of(context).accentColor,
                    totalMarks: testResult[index].totalMarks,
                    score: testResult[index].score,
                    examName: testResult[index].nameOfExam,
                  ),
                );
              },
              childCount: testResult.length,
            )),
          ],
        ),
      );
    }
  }

  Widget overallPerf(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  spreadRadius: -screenSize.screenHeight * 2,
                  blurRadius: screenSize.screenHeight * 3,
                  offset: Offset(-5, -5),
                  color: Colors.white),
              BoxShadow(
                  spreadRadius: -screenSize.screenHeight * 0.4,
                  blurRadius: screenSize.screenHeight * 1,
                  offset: Offset(7, 7),
                  color: Colors.black26),
            ]),
        child: Stack(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: screenSize.screenHeight * 4.5),
                child: SizedBox(
                  width: min(screenSize.screenWidth * 40,
                      screenSize.screenHeight * 20),

                  child: CustomPaint(
                    child: Center(),
                    foregroundPainter: PieChart(
                        width: screenSize.screenWidth * 15,
                        percentage: percentage,
                        score: totalScore,
                        totalMarks: totalMarks,
                        marks: [percentage, 1 - percentage]),
                  ),
                  //height: screenSize.screenHeight * 5,
                ),
              ),
            ),
            Center(
              child: Container(
                height: screenSize.screenHeight * 18,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      offset: Offset(-1, -1),
                      color: Colors.white,
                    ),
                    BoxShadow(
                      spreadRadius: -2,
                      blurRadius: 10,
                      offset: Offset(5, 5),
                      color: Colors.black.withOpacity(0.5),
                    )
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        (percentage * 100).toStringAsFixed(2) + "%",
                        style: TextStyle(
                            fontSize: screenSize.screenHeight * 2.5,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                      ),
                      Text(totalScore.toString() + "/" + totalMarks.toString()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getData() async {
    String accessToken = await savedData.getAccessToken();

    print(accessToken);
    String url =
        "https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user/getExamResult";
    http.Response response =
        await http.get(url, headers: {'x-auth-token': accessToken});
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = convert.jsonDecode(data);

      List tests = decodedData;
      for (int i = 0; i < tests.length; i++) {
        TestResult testRes = TestResult();
        testRes.examCode = tests[i]['id'];
        testRes.nameOfExam = tests[i]['name'];
        testRes.score = tests[i]['marks'].toDouble();
        totalScore += testRes.score;

        testRes.totalMarks = tests[i]['totalMarks'].toDouble();
        totalMarks += testRes.totalMarks;

        testResult.add(testRes);
      }
      for (int i = 0; i < testResult.length; i++) {
        print(testResult[i].nameOfExam);
      }
      percentage = totalScore / totalMarks;
      print(percentage.toStringAsFixed(2) + "%");
      isReady = true;
      setState(() {});
    } else {
      print(response.statusCode);
      print(convert.jsonDecode(response.body));
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    screenSize = SizeConfig(context);
    return showScreen(isReady, context);
  }
}

class TestResult {
  double totalMarks = 0;
  double score = 0;
  String nameOfExam = '';
  String examCode = '';

  TestResult({this.score, this.examCode, this.nameOfExam, this.totalMarks});
}
