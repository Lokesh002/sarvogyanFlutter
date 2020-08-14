import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sarvogyan/Screens/myResultScreen.dart';
import 'package:sarvogyan/components/ReusableButton.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:sarvogyan/utilities/sharedPref.dart';

class ResultScreen extends StatefulWidget {
  int score;
  int totalQues;
  String examId;
  ResultScreen(this.score, this.totalQues, this.examId);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  SizeConfig screenSize;
  bool isReady = false;
  SavedData savedData = SavedData();

  @override
  void initState() {
    super.initState();
    saveResult();
  }

  void saveResult() async {
    String authAccessToken = await savedData.getAccessToken();

    String url =
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/exam/setResults';
    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": authAccessToken
        },
        body: convert.jsonEncode({
          'exam_id': widget.examId,
          'totalMarks': widget.totalQues,
          'marks': widget.score
        }));

    if (response.statusCode == 200) {
      var decodedData = convert.jsonDecode(response.body);

      print(decodedData);
      isReady = true;
      setState(() {});
    } else {
      print(response.statusCode);
    }
  }

  Widget showScreen() {
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: screenSize.screenWidth * 10,
                                ),
                                Text(
                                  "Result",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize.screenHeight * 3.5,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                ReusableButton(
                                  width: screenSize.screenWidth * 3,
                                  height: screenSize.screenHeight * 5,
                                  content: "Back",
                                  onPress: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(
                                  width: screenSize.screenWidth * 10,
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1.7,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 1.7,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: screenSize.screenHeight * 10,
                          ),
                          Container(
                            height: screenSize.screenHeight * 30,
                            child: SvgPicture.asset('svg/result.svg',
                                semanticsLabel: 'A red up arrow'),
                          ),
                          SizedBox(
                            height: screenSize.screenHeight * 5,
                          ),
                          Center(
                            child: Text(
                              "You Scored ${widget.score} out of ${widget.totalQues}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenSize.screenHeight * 3.5,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.screenHeight * 15,
                          ),
                          ReusableButton(
                              onPress: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MyResultScreen();
                                }));
                              },
                              content: "See All Results",
                              height: screenSize.screenHeight * 7,
                              width: screenSize.screenWidth * 30),
                        ],
                      ),
                    ),
                  ),
                ]),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return showScreen();
  }
}
