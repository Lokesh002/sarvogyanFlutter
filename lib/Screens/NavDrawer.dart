import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarvogyan/Screens/course/courseCategScreen.dart';
import 'package:sarvogyan/Screens/exams/AllExamsScreen.dart';
import 'package:sarvogyan/components/courseTree.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class NavDrawer {
  String fromScreen;
  NavDrawer(String screen) {
    this.fromScreen = screen;
  }

  String getCourseImage(int index) {
    switch (index) {
      case 0:
        return 'schoolIcon.png';
        break;
      case 1:
        return 'collegeIcon.png';
        break;
      case 2:
        return 'professionalIcon.png';
        break;
      case 3:
        return 'vocationalIcon.png';
        break;
      default:
        return 'collegeBlack.png';
    }
  }

  String getExamImage(int index) {
    switch (index) {
      case 0:
        return 'enggIcon.png';
        break;
      case 1:
        return 'medicalIcon.png';
        break;
      case 2:
        return 'lawIcon.png';
        break;
      case 3:
        return 'govtIcon.png';
        break;
      case 4:
        return 'govtIcon.png';
        break;
      case 5:
        return 'govtIcon.png';
        break;
      case 6:
        return 'enggIcon.png';
        break;
      case 7:
        return 'enggIcon.png';
        break;
      case 8:
        return 'managementIcon.png';
        break;
      case 9:
        return 'govtIcon.png';
        break;
      case 10:
        return 'govtIcon.png';
        break;
      case 11:
        return 'enggIcon.png';
        break;
      default:
        return 'collegeBlack.png';
    }
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
                    height: screenSize.screenHeight * 17,
                    child: Image.asset(
                      'images/flogoBig.png',
                      fit: BoxFit.contain,
                    )),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Container(
            height: screenSize.screenHeight * 74,
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
                  height: screenSize.screenHeight * 32,
                  child: ListView.builder(
                      itemBuilder: (BuildContext cntxt, int index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  SizedBox(
                                    width: screenSize.screenWidth * 2,
                                  ),
                                  Image.asset(
                                    'images/media/${getCourseImage(index)}',
                                    height: screenSize.screenHeight * 4,
                                  ),
                                  SizedBox(
                                    width: screenSize.screenWidth * 2,
                                  ),
                                  Text(sarvogyan
                                      .children[0].children[index].value),
                                ],
                              ),
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
                            ),
                          ],
                        );
                      },
                      itemCount: sarvogyan.children[0].children.length,
                      padding: EdgeInsets.fromLTRB(
                          0,
                          screenSize.screenHeight * 2.5,
                          0,
                          screenSize.screenHeight)),
                ),
                Divider(
                  thickness: 1,
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
                  height: screenSize.screenHeight * 32,
                  child: ListView.builder(
                      itemBuilder: (BuildContext cntxt, int index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  SizedBox(
                                    width: screenSize.screenWidth * 2,
                                  ),
                                  Image.asset(
                                    'images/media/${getExamImage(index)}',
                                    height: screenSize.screenHeight * 4,
                                  ),
                                  SizedBox(
                                    width: screenSize.screenWidth * 2,
                                  ),
                                  Text(sarvogyan
                                      .children[1].children[index].value),
                                ],
                              ),
                              onTap: () {
                                if (fromScreen == 'homeScreen') {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AllExamsScreen(
                                      sarvogyan
                                          .children[1].children[index].value,
                                      sarvogyan.children[1].children[index],
                                    );
                                  }));
                                } else {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AllExamsScreen(
                                      sarvogyan
                                          .children[1].children[index].value,
                                      sarvogyan.children[1].children[index],
                                    );
                                  }));
                                }
                              },
                            ),
                          ],
                        );
                      },
                      itemCount: sarvogyan.children[1].children.length,
                      padding: EdgeInsets.fromLTRB(
                          0,
                          screenSize.screenHeight * 2.5,
                          0,
                          screenSize.screenHeight)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
