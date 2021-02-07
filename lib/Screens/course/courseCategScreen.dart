import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sarvogyan/Screens/NavDrawer.dart';
import 'package:sarvogyan/Screens/course/courseSelectedLoadingScreen.dart';
import 'package:sarvogyan/components/Cards/reusableCourseCard.dart';
import 'package:sarvogyan/components/Constants/constants.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/courseTree.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/course_List.dart';

class CourseCategScreen extends StatefulWidget {
  final CourseTreeNode node;
  final String query;
  final bool isLast;
  final String imagePath;
  final CourseTreeNode sarvogyan;
  CourseCategScreen(
      this.sarvogyan, this.query, this.node, this.imagePath, this.isLast);
  @override
  _CourseCategScreenState createState() => _CourseCategScreenState();
}

class _CourseCategScreenState extends State<CourseCategScreen> {
  SizeConfig screenSize;
  var listofCourses;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.query);
    print(widget.node);
  }

  bool isReady = false;
  getCourses() async {
    Networking networking = Networking();
    var courses = await networking.postData(
        "api/search/searchCourse", {"searchQuery": widget.query.trimRight()});
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

  Widget ShowScreen() {
    if (widget.isLast) {
      if (!isReady) {
        getCourses();
        return Scaffold(
          backgroundColor: Color(0xffffffff),
          body: SpinKitWanderingCubes(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
            size: screenSize.screenHeight * 18,
          ),
        );
      } else {
        return Scaffold(
            drawer: navDrawer.getNavDrawer(context, widget.sarvogyan),
            appBar: AppBar(
              toolbarHeight: screenSize.screenHeight * 10,
              elevation: 5,
              title: Text(
                widget.node.value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.screenHeight * 3.5),
              ),
            ),
            body: listofCourses.length == 0
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
                                      listofCourses[index].id);
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
                  ));
      }
    } else {
      return Scaffold(
          drawer: navDrawer.getNavDrawer(context, widget.sarvogyan),
          appBar: AppBar(
            toolbarHeight: screenSize.screenHeight * 10,
            elevation: 5,
            title: Text(
              widget.node.value,
              style: TextStyle(
                  color: Colors.white, fontSize: screenSize.screenHeight * 3.5),
            ),
          ),
          body: Container(
            child: Column(
              children: [
                SizedBox(
                  height: screenSize.screenHeight * 5,
                ),
                Container(
                  width: screenSize.screenWidth * 100,
                  height: screenSize.screenHeight * 85,
                  child: GridView.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 2,
                    // Generate 100 widgets that display their index in the List.
                    children:
                        List.generate(widget.node.children.length, (index) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.screenWidth * 5,
                              vertical: screenSize.screenHeight * 3),
                          child: GestureDetector(
                            onTap: () {
                              print("printing list of children");
                              print(widget.node.children[index].children);
                              if (widget.node.children[index].children.length ==
                                  0) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CourseCategScreen(
                                      widget.sarvogyan,
                                      widget.query +
                                          "${widget.node.children[index].value} ",
                                      widget.node.children[index],
                                      'images/media',
                                      true);
                                }));
                              } else {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CourseCategScreen(
                                      widget.sarvogyan,
                                      widget.query +
                                          "${widget.node.children[index].value} ",
                                      widget.node.children[index],
                                      'images/media',
                                      false);
                                }));
                              }
                            },
                            child: Container(
                              width: screenSize.screenWidth * 40,
                              height: screenSize.screenHeight * 30,
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    screenSize.screenHeight * 2),
                                elevation: 5.0,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              screenSize.screenWidth * 1,
                                          vertical:
                                              screenSize.screenHeight * 1),
                                      child: Container(
                                        height: screenSize.screenHeight * 15,
                                        child: Image.asset(
                                          '${widget.imagePath}/${widget.node.children[index].value}.jpg',
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: screenSize.screenWidth * 1,
                                        right: screenSize.screenWidth * 1,
                                        bottom: screenSize.screenHeight * 1,
                                        top: screenSize.screenHeight * 1,
                                      ),
                                      child: Text(
                                        widget.node.children[index].value,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ));
    }
  }

  NavDrawer navDrawer = NavDrawer('courseCategScreen');
  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return ShowScreen();
  }
}
