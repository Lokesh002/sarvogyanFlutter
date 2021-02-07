import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarvogyan/Screens/course/courseCategScreen.dart';
import 'package:sarvogyan/components/courseTree.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class NavDrawer {
  String fromScreen;
  NavDrawer(String screen) {
    this.fromScreen = screen;
  }

  Widget getNavDrawer(var context, CourseTreeNode sarvogyan) {
    SizeConfig screenSize = SizeConfig(context);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Column(
        // Important: Remove any padding from the ListView.

        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                Container(
                    width: screenSize.screenWidth * 100,
                    height: screenSize.screenHeight * 20,
                    child: Image.asset('images/logo.png')),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Container(
            height: screenSize.screenHeight * 70,
            child: Column(
              children: [
                Text(
                  "Courses",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: screenSize.screenHeight * 3),
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: screenSize.screenHeight * 30,
                  child: ListView.builder(
                      itemBuilder: (BuildContext cntxt, int index) {
                        return ListTile(
                          title:
                              Text(sarvogyan.children[0].children[index].value),
                          onTap: () {
                            if (fromScreen == 'homeScreen') {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CourseCategScreen(
                                    sarvogyan,
                                    "",
                                    sarvogyan.children[0].children[index],
                                    'images/media',
                                    false);
                              }));
                            } else {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return CourseCategScreen(
                                    sarvogyan,
                                    "",
                                    sarvogyan.children[0].children[index],
                                    'images/media',
                                    false);
                              }));
                            }
                          },
                        );
                      },
                      itemCount: sarvogyan.children[0].children.length,
                      padding: EdgeInsets.fromLTRB(
                          0,
                          screenSize.screenHeight * 2.5,
                          0,
                          screenSize.screenHeight * 2.5)),
                ),
                Container(
                  child: Text(
                    "Exams",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: screenSize.screenHeight * 3),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: screenSize.screenHeight * 30,
                  child: ListView.builder(
                      itemBuilder: (BuildContext cntxt, int index) {
                        return ListTile(
                          title:
                              Text(sarvogyan.children[1].children[index].value),
                          onTap: () {
                            if (fromScreen == 'homeScreen') {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CourseCategScreen(
                                    sarvogyan,
                                    "",
                                    sarvogyan.children[1].children[index],
                                    'images/media',
                                    false);
                              }));
                            } else {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return CourseCategScreen(
                                    sarvogyan,
                                    "",
                                    sarvogyan.children[1].children[index],
                                    'images/media',
                                    false);
                              }));
                            }
                          },
                        );
                      },
                      itemCount: sarvogyan.children[1].children.length,
                      padding: EdgeInsets.fromLTRB(
                          0,
                          screenSize.screenHeight * 2.5,
                          0,
                          screenSize.screenHeight * 2.5)),
                ),
              ],
            ),

//            ListView(
//              padding: EdgeInsets.zero,
//              children: [
//                Text(
//                  "Courses",
//                  style: TextStyle(
//                      color: Colors.black,
//                      fontSize: screenSize.screenHeight * 3),
//                  textAlign: TextAlign.center,
//                ),
//                ListTile(
//                  title: Text('School'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('Higher Education'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('Professional'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('Vocational Skills'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                Text(
//                  "Exams",
//                  style: TextStyle(
//                      color: Colors.black,
//                      fontSize: screenSize.screenHeight * 3),
//                  textAlign: TextAlign.center,
//                ),
//                ListTile(
//                  title: Text('JEE'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('CAT'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('CLAT'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('NDA'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('UPSC'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('SSC'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('GATE'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('SAT'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('GMAT'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('Banking'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('Teaching'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//                ListTile(
//                  title: Text('IIT JAM'),
//                  onTap: () {
//                    // Update the state of the app.
//                    // ...
//                  },
//                ),
//              ],
//            ),
          ),
        ],
      ),
    );
  }
}
