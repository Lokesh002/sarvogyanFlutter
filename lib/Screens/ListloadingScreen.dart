import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sarvogyan/components/ReusableButton.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/lists/course_List.dart';
import 'package:sarvogyan/components/courseListData.dart';
import 'package:sarvogyan/Screens/allCourses.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarvogyan/Screens/courseSelectedLoadingScreen.dart';
import 'package:sarvogyan/Screens/examListLoadingScreen.dart';
import 'package:sarvogyan/Screens/login.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/components/ReusableButton.dart';
import 'package:sarvogyan/components/reusableCourseCard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/lists/colorList.dart';

class ListLoadingScreen extends StatefulWidget {
  var listofCourses;

  @override
  _ListLoadingScreenState createState() => _ListLoadingScreenState();
}

class _ListLoadingScreenState extends State<ListLoadingScreen> {
  SavedData savedData = SavedData();

  var veh;
  CourseModel courseModel = CourseModel();
  Course_List clist;

  void getLocation() async {
    var decodedData = await courseModel.getAllCourses();
    clist = Course_List(decodedData);
    //Navigator.pop(context);
    widget.listofCourses = clist.getCourseList();
    allCoursesList = widget.listofCourses;
    isReady = true;
    if (mounted) {
      setState(() {});
    }
//    AllCourses(clist.getCourseList());
  }

  getStatus() async {
    signedIn = await savedData.getLoggedIn();
    if (signedIn == null) {
      signedIn = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  String getSubscription(int index) {
    if (allCoursesList[index].subscription == 'a')
      return "Free Course";
    else if (allCoursesList[index].subscription == 'b')
      return "Basic Course";
    else if (allCoursesList[index].subscription == 'c')
      return "Premium Course";
    else
      return "Invalid Subscription Code";
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getLocation();
    }
  }

  bool isReady = false;

  SizeConfig screenSize;
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
                  alignment: AlignmentDirectional.bottomEnd,
                  children: <Widget>[
                    Container(
                      height: screenSize.screenHeight * 80,
                      child: ListView.builder(
                          itemBuilder: (BuildContext cntxt, int index) {
                            return ReusableCourseCard(
                              color: Theme.of(context).accentColor,
                              courseName: veh[index].name,
                              subscription: getSubscription(index),
                              teacher: veh[index].teacher,
                              image: veh[index].picture,
                              onTap: () {
                                setState(() {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CourseSelectedLoadingScreen(
                                        veh[index].id);
                                  }));
                                });
                              },
                            );
                          },
                          itemCount: veh.length,
                          padding: EdgeInsets.fromLTRB(
                              0,
                              screenSize.screenHeight * 2.5,
                              0,
                              screenSize.screenHeight * 2.5)),
                    ),
                    Container(
                      width: screenSize.screenWidth * 30,
                      child: Column(
                        children: <Widget>[
                          FloatingActionButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/filterLoadingScreen');
                            },
                            elevation: 5,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(
                              Icons.search,
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                          SizedBox(
                            height: signedIn
                                ? screenSize.screenHeight * 2
                                : screenSize.screenHeight * 10,
                          )
//                        ReusableButton(
//                            onPress: () {
//                              Navigator.pushNamed(
//                                  context, '/filterLoadingScreen');
//                            },
//                            content: "asdas",
//                            height: screenSize.screenHeight * 5,
//                            width: screenSize.screenWidth * 20),
//                      SizedBox(
//                        width: screenSize.screenWidth * 1,
//                      )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !signedIn,
                      child: Column(
                        children: <Widget>[
//                  SizedBox(
//                    height: screenSize.screenHeight * 2,
//                  ),
                          Visibility(
                            visible: !signedIn,
                            child: Material(
                              elevation: 10,
                              child: Container(
                                height: screenSize.screenHeight * 7,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Visibility(
                                        visible: !signedIn,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return Login(true);
                                            }));
                                          },
                                          child: Container(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              child: Center(
                                                  child: Text(
                                                "Sign In",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                              height:
                                                  screenSize.screenHeight * 7,
                                              width: screenSize.screenWidth *
                                                  49.95),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !signedIn,
                                        child: SizedBox(
                                          width: screenSize.screenWidth * 0.1,
                                        ),
                                      ),
                                      Visibility(
                                        visible: !signedIn,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/registerUser');
                                          },
                                          child: Container(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              child: Center(
                                                  child: Text(
                                                "Sign Up",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                              height:
                                                  screenSize.screenHeight * 7,
                                              width: screenSize.screenWidth *
                                                  49.95),
                                        ),
                                      ),
//                            Visibility(
//                              visible: signedIn,
//                              child: ReusableButton(
//                                  onPress: () {
//                                    Navigator.pushNamed(context, '/profile');
//                                  },
//                                  content: "Profile",
//                                  height: screenSize.screenHeight * 7,
//                                  width: screenSize.screenWidth * 20),
//                            ),
//                            Visibility(
//                              visible: signedIn,
//                              child: SizedBox(
//                                width: screenSize.screenWidth * 20,
//                              ),
//                            ),
//                            Visibility(
//                              visible: signedIn,
//                              child: ReusableButton(
//                                  onPress: () {
//                                    Navigator.pushNamed(
//                                        context, '/ExamLoadingScreen');
//                                  },
//                                  content: "Exam List",
//                                  height: screenSize.screenHeight * 7,
//                                  width: screenSize.screenWidth * 20),
//                            ),
//                            Visibility(
//                              visible: signedIn,
//                              child: ReusableButton(
//                                  onPress: () {
//                                    Navigator.pushNamed(
//                                        context, '/changeColour');
//                                  },
//                                  content: "Change Colour",
//                                  height: screenSize.screenHeight * 7,
//                                  width: screenSize.screenWidth * 20),
//                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    veh = allCoursesList;

    getStatus();

    screenSize = SizeConfig(context);
    return ShowScreen(isReady);
  }
}
