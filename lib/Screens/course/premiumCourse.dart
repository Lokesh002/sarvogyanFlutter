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

class PremiumCourse extends StatefulWidget {
  @override
  _PremiumCourseState createState() => _PremiumCourseState();
}

class _PremiumCourseState extends State<PremiumCourse> {
  SizeConfig screenSize;
  @override
  void dispose() {
    visible = false;
    super.dispose();
  }

  bool visible = false;
  bool isReady = false;
  List<CourseData> listofCourses = List<CourseData>();
  getCourses() async {
    Networking networking = Networking();
    var courses = await networking
        .postData("api/search/searchCourse", {"searchQuery": "certification"});
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
      return Center(
        child: SpinKitWanderingCubes(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          size: 100.0,
        ),
      );
    } else {
      return (listofCourses.length == 0
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
              height: screenSize.screenHeight * 80,
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
                  padding: EdgeInsets.fromLTRB(0, screenSize.screenHeight * 2.5,
                      0, screenSize.screenHeight * 2.5)),
            ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    visible = false;
    if (mounted) getCourses();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Container(
              height: screenSize.screenHeight * 80, child: getScreen())),
    );
  }
}
