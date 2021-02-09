import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/course/courseSelectedLoadingScreen.dart';
import 'package:sarvogyan/Screens/exams/takeExamLoadingScreen.dart';
import 'package:sarvogyan/components/Cards/reusableCourseCard.dart';
import 'package:sarvogyan/components/Cards/reusableExamCard.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/getAllExams.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/lists/course_List.dart';

class SearchExams extends StatefulWidget {
  @override
  _SearchExamsState createState() => _SearchExamsState();
}

class _SearchExamsState extends State<SearchExams> {
  SizeConfig screenSize;
  var _formKey = new GlobalKey<FormState>();
  var searchController = TextEditingController();
  String query;
  @override
  void dispose() {
    visible = false;
    searchController.clear();
    searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool visible = false;
  bool isReady = false;
  List<Exam> listOfExam = List<Exam>();
  getExam() async {
    GetAllExams getAllExams = GetAllExams();
    listOfExam = await getAllExams.getExamList(query);

    isReady = true;
    if (mounted) {
      setState(() {});
    }
  }

  Widget getScreen() {
    if (!isReady) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenSize.screenHeight * 30),
            child: SpinKitWanderingCubes(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              size: 100.0,
            ),
          ),
        ],
      );
    } else {
      return listOfExam.length == 0
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
              height: screenSize.screenHeight * 80,
              child: ListView.builder(
                  itemBuilder: (BuildContext cntxt, int index) {
                    return ReusableExamCard(
                      examName: listOfExam[index].examName,
                      examTime: listOfExam[index].examTime,
                      examPicture: listOfExam[index].examPicture,
                      examDesc: listOfExam[index].examDescription,
                      totalQuestion: listOfExam[index].totalQuestions,
                      onTap: () {
                        setState(() {
                          if (signedIn) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              print(listOfExam[index].examId);
                              return TakeExamLoadingScreen(listOfExam[index]);
                            }));
                          } else {
                            Fluttertoast.showToast(msg: "Please login first.");
                          }
                        });
                      },
                    );
                  },
                  itemCount: listOfExam.length,
                  padding:
                      EdgeInsets.fromLTRB(0, screenSize.screenHeight * 2.5, 0, 0
                          //screenSize.screenHeight * 15)),
                          )));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isReady = true;
    visible = false;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.screenWidth * 2,
                    vertical: screenSize.screenHeight * 2),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 5,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter query first.' : null,
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    onChanged: (query) {
                      this.query = query;
                      print(this.query);
                    },
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: screenSize.screenHeight * 2),
                    // focusNode: focusNode,

                    decoration: InputDecoration(
                      hintText: "Search Exam",
                      suffixIcon: GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                visible = true;
                                isReady = false;
                              });
                              getExam();
                            }
                          },
                          child: Icon(Icons.search)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              screenSize.screenHeight * 2)),
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Visibility(visible: visible, child: getScreen()),
            ],
          ),
        ),
      ),
    );
  }
}
