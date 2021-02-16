import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sarvogyan/Screens/course/courseSelectedLoadingScreen.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/Cards/reusableCourseCard.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/lists/course_List.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyCourses extends StatefulWidget {
  @override
  _MyCoursesState createState() => _MyCoursesState();
}

class _MyCoursesState extends State<MyCourses> {
  SizeConfig screenSize;
  bool isReady = false;
  List<CourseData> courseList = List<CourseData>();
  SavedData savedData = SavedData();
  getMyCourseData() async {
    String url =
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/course/myCourses/student';
    String acsTkn = await savedData.getAccessToken();
    http.Response response =
        await http.get(url, headers: {"x-auth-token": acsTkn});

    if (response.statusCode == 200) {
      var decodedData = convert.jsonDecode(response.body);
      print(decodedData);
      List myCourses = decodedData;
      for (int i = 0; i < myCourses.length; i++) {
        String id = myCourses[i]["id"];
        String name = myCourses[i]["name"];
        String desc = myCourses[i]["description"];
        String category;
        String subCategory;
        var teacher = myCourses[i]["teacherDetails"];
        String teacherName = teacher["name"];

        List a = myCourses[i]["courseCategory"];
        String picture = myCourses[i]["picture"];

        // print(a);
        if (a.isNotEmpty) {
          print(a[0]);
          category = a[0];
        } else {
          category = null;
        }
        List b = myCourses[i]["courseSubcategory"];
        if (b != null) {
          if (b.isNotEmpty) {
            //print('hello: ${b[0]}');
            subCategory = b[0];
          } else {
            subCategory = null;
          }
        } else {
          subCategory = null;
        }

        var subscription = myCourses[i]["subscription"];
        if (subscription == null) {
          subscription = "wrong";
        }
        print("subscription: " + subscription);
        this.courseList.add(CourseData(id, name, desc, category, subCategory,
            teacherName, picture, subscription));

        print("yo: " + courseList[i].name);
      }
      print("done");
      isReady = true;
      if (mounted) {
        setState(() {});
      }
    } else {
      print(convert.jsonDecode(response.body));
      print(response.statusCode);
    }
  }

  String getSubscription(int index) {
    if (courseList[index].subscription == 'a')
      return "Basic Course";
    else if (courseList[index].subscription == 'b')
      return "Basic Course";
    else if (courseList[index].subscription == 'c')
      return "Premium Course";
    else
      return "Invalid Subscription Code";
  }

  Widget showScreen(bool isReady) {
    if (signedIn) {
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
        if (courseList.isNotEmpty) {
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
                      alignment: AlignmentDirectional.bottomEnd,
                      children: <Widget>[
                        Container(
                          height: screenSize.screenHeight * 80,
                          child: ListView.builder(
                              itemBuilder: (BuildContext cntxt, int index) {
                                return ReusableCourseCard(
                                  color: Theme.of(context).accentColor,
                                  courseName: courseList[index].name,
                                  subscription: getSubscription(index),
                                  teacher: courseList[index].teacher,
                                  image: courseList[index].picture,
                                  onTap: () {
                                    setState(() {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return CourseSelectedLoadingScreen(
                                            courseList[index]);
                                      }));
                                    });
                                  },
                                );
                              },
                              itemCount: courseList.length,
                              padding: EdgeInsets.fromLTRB(
                                  0,
                                  screenSize.screenHeight * 2.5,
                                  0,
                                  screenSize.screenHeight * 2.5)),
                        ),
//                      Container(
//                        width: screenSize.screenWidth * 30,
//                        child: Column(
//                          children: <Widget>[
//                            FloatingActionButton(
//                              onPressed: () {
//                                Navigator.pushNamed(
//                                    context, '/filterLoadingScreen');
//                              },
//                              elevation: 5,
//                              backgroundColor: Theme.of(context).primaryColor,
//                              child: Icon(
//                                Icons.search,
//                                color: Theme.of(context).backgroundColor,
//                              ),
//                            ),
//                            SizedBox(
//                              height: screenSize.screenHeight * 2,
//                            )
//                          ],
//                        ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ));
        } else {
          return Scaffold(
            body: Container(
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
            ),
          );
        }
      }
    } else {
      return Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: screenSize.screenHeight * 10,
              ),
              Container(
                height: screenSize.screenHeight * 20,
                child: SvgPicture.asset('svg/pleaseLogin.svg',
                    semanticsLabel: 'A red up arrow'),
              ),
              SizedBox(
                height: screenSize.screenHeight * 5,
              ),
              Text(
                "Please Login First",
              ),
              SizedBox(
                height: screenSize.screenHeight * 20,
              ),
              ReusableButton(
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Login(true);
                  }));
                },
                height: screenSize.screenHeight * 7,
                width: screenSize.screenWidth * 30,
                content: "Login",
              )
            ],
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) getMyCourseData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    screenSize = SizeConfig(context);
    return showScreen(isReady);
  }
}
