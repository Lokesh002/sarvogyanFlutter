import 'dart:developer';

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

class SearchCourse extends StatefulWidget {
  @override
  _SearchCourseState createState() => _SearchCourseState();
}

class _SearchCourseState extends State<SearchCourse> {
  SizeConfig screenSize;
  var _formKey = new GlobalKey<FormState>();
  var searchController = TextEditingController();
  String choice = "Course";
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
  List<CourseData> listofCourses = List<CourseData>();
  getCourses() async {
    Networking networking = Networking();
    var courses = await networking.postData("api/search/searchCourse",
        {"searchQuery": query.trimLeft().trimRight()});
    print("hefh");
    print(courses);
    if (courses != null) {
      var clist = Course_List(courses);
      //Navigator.pop(context);
      listofCourses = clist.getCourseList();
    } else {
      listofCourses = [];
    }
    isReady = true;
    if (mounted) {
      setState(() {});
    }
  }

  List<Exam> listOfExam = List<Exam>();
  getExam() async {
    GetAllExams getAllExams = GetAllExams();
    listOfExam = await getAllExams.getExamList(query);

    isReady = true;
    if (mounted) {
      setState(() {});
    }
  }

  String getSubscription(int index) {
    if (listofCourses[index].subscription == 'a')
      return "Free Course";
    else if (listofCourses[index].subscription == 'b')
      return "Basic Course";
    else if (listofCourses[index].subscription == 'c')
      return "Premium Course";
    else
      return "Invalid Subscription Code";
  }

  Widget getScreen() {
    if (!isReady) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenSize.screenHeight * 5),
            child: SpinKitWanderingCubes(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              size: 100.0,
            ),
          ),
        ],
      );
    } else {
      return (choice == 'Course')
          ? (listofCourses.length == 0
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
                        "No Courses Present",
                      ),
                      SizedBox(
                        height: screenSize.screenHeight * 20,
                      ),
                    ],
                  ),
                )
              : Container(
                  height: screenSize.screenHeight * 67,
                  child: ListView.builder(
                      itemBuilder: (BuildContext cntxt, int index) {
                        return ReusableCourseCard(
                          color: Theme.of(context).accentColor,
                          courseName: listofCourses[index].name,
                          subscription: getSubscription(index),
                          teacher: listofCourses[index].teacher,
                          image: listofCourses[index].picture,
                          onTap: () {
                            setState(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CourseSelectedLoadingScreen(
                                    listofCourses[index]);
                              }));
                            });
                          },
                        );
                      },
                      itemCount: listofCourses.length,
                      padding: EdgeInsets.fromLTRB(
                          0,
                          screenSize.screenHeight * 2.5,
                          0,
                          screenSize.screenHeight * 2.5)),
                ))
          : (listOfExam.length != 0)
              ? Container(
                  height: screenSize.screenHeight * 67,
                  child: ListView.builder(
                      itemBuilder: (BuildContext cntxt, int index) {
                        return ReusableExamCard(
                          examPicture: (listOfExam[index].examPicture == null ||
                                  listOfExam[index].examPicture == '')
                              ? 'images/media/logo.png'
                              : listOfExam[index].examPicture,
                          examName: listOfExam[index].examName,
                          examTime: listOfExam[index].examTime,
                          examType: listOfExam[index].examType,
                          examDesc: listOfExam[index].examDescription,
                          totalQuestion: listOfExam[index].totalQuestions,
                          onTap: () {
                            setState(() {
                              if (signedIn) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  print(listOfExam[index].examId);
                                  return TakeExamLoadingScreen(
                                      listOfExam[index]);
                                }));
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please login first.");
                              }
                            });
                          },
                        );
                      },
                      itemCount: listOfExam.length,
                      padding: EdgeInsets.fromLTRB(
                          0, screenSize.screenHeight * 2.5, 0, 0
                          //screenSize.screenHeight * 15)),
                          )))
              : Container(
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
                );
      ;
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.screenHeight * 2,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.screenWidth * 3),
                    child: Text('Search in: '),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45),
                        borderRadius:
                            BorderRadius.circular(screenSize.screenHeight * 2),
                      ),
                      width: screenSize.screenWidth * 75,
                      height: screenSize.screenHeight * 7,
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.screenWidth * 3),
                            child: DropdownButtonFormField(
                              disabledHint: Text("Choose Search Parameter"),
                              validator: (val) => val == null ? 'Choose' : null,
                              elevation: 7,
                              isExpanded: false,
                              hint: Text('Choose ',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: screenSize.screenHeight * 2)),
                              value: choice,
                              items: [
                                DropdownMenuItem(
                                  child: Text('Course'),
                                  value: 'Course',
                                ),
                                DropdownMenuItem(
                                  child: Text('Exam'),
                                  value: 'Exam',
                                ),
                              ],
                              onChanged: (value) {
                                choice = value;
                                print('selected: $choice');

                                setState(() {});
                              },
                            )),
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.screenWidth * 2,
                    vertical: screenSize.screenHeight * 2),
                child: Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenSize.screenWidth * 80,
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
                            hintText: "Search",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    screenSize.screenHeight * 2)),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: screenSize.screenWidth * 3),
                        child: GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isReady = false;
                                visible = true;
                              });
                              (choice == 'Course') ? getCourses() : getExam();
                            }
                          },
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(
                              screenSize.screenHeight * 2.8,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: screenSize.screenHeight * 3,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: screenSize.screenHeight * 2.8,
                                child: Icon(
                                  Icons.search,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
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
