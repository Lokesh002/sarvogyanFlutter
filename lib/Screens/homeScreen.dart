import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/course/ListloadingScreen.dart';
import 'package:sarvogyan/Screens/course/allCoursesScreen.dart';
import 'package:sarvogyan/Screens/course/search/seachScreen.dart';
import 'package:sarvogyan/Screens/docs/cloudDocsScreen.dart';

import 'package:sarvogyan/Screens/docs/docsScreen.dart';
import 'package:sarvogyan/Screens/exams/examCategScreen.dart';
import 'package:sarvogyan/Screens/exams/examListLoadingScreen.dart';
import 'package:sarvogyan/Screens/course/myCourses/myCourses.dart';
import 'package:sarvogyan/Screens/NavDrawer.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/components/courseTree.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _widgets = <Widget>[];
  int _defaultIndex = 0;
  GetCourseClass getCourseClass = GetCourseClass();
  CourseTreeNode sarvogyan;
  int _selectedIndex;
  NavDrawer navDrawer = NavDrawer('homeScreen');
  void _onTapHandler(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  SavedData savedData = SavedData();

  getSignedInStatus() async {
    // print(signedIn);
    signedIn = await savedData.getLoggedIn();
    //  print(signedIn);
    if (signedIn == null) {
      signedIn = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sarvogyan = getCourseClass.process();
    _selectedIndex = _defaultIndex;
  }

  SizeConfig screenSize;
  @override
  Widget build(BuildContext context) {
    getSignedInStatus();
    screenSize = SizeConfig(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          drawer: navDrawer.getNavDrawer(context, sarvogyan),
          appBar: AppBar(
            actions: <Widget>[
              Visibility(
                visible: true,
                child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          color: Theme.of(context).accentColor,
                          size: screenSize.screenHeight * 6,
                        ),
                      ],
                    ),
                    onTap: () {
                      signedIn
                          ? Navigator.pushNamed(context, '/profile')
                          : Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                              return Login(true);
                            }));
                      ;
                    }),
              ),
              SizedBox(
                width: screenSize.screenWidth * 3,
              )
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
//                SizedBox(
//                  width: screenSize.screenWidth * 5,
//                ),
//
                Hero(
                  tag: 'logo',
                  child: Container(
                      height: screenSize.screenHeight * 10,
                      child: Image.asset('images/logo.png')),
                ),
                Text("Sarvogyan",
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: screenSize.screenHeight * 3)),
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 5,
            bottom: TabBar(
              unselectedLabelColor: Theme.of(context).accentColor,
              indicator: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(screenSize.screenHeight * 5),
                color: Theme.of(context).accentColor,
              ),
              tabs: <Widget>[
                Tab(
                  child: Container(
                    child: Text(
                      "Search",
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      "My Courses",
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      "Courses",
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      "Exam",
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      "Docs",
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                  ),
                ),
              ],
              onTap: _onTapHandler,
            ),
          ),
          backgroundColor: Theme.of(context).accentColor,
          body: TabBarView(children: [
            SearchScreen(),
            MyCourses(),
            AllCoursesScreen(sarvogyan, sarvogyan.children[0], 'images/media'),
            ExamCategScreen(
                sarvogyan, "", sarvogyan.children[1], 'images/media'),
            CloudDocsScreen(),
          ]),
        ),
      ),
    );
  }

  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to exit!");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
