import 'package:flutter/material.dart';
import 'package:sarvogyan/Screens/NavDrawer.dart';
import 'package:sarvogyan/Screens/exams/AllExamsScreen.dart';
import 'package:sarvogyan/components/Cards/reusableCourseCard.dart';
import 'package:sarvogyan/components/courseTree.dart';
import 'package:sarvogyan/components/getAllExams.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class ExamCategScreen extends StatefulWidget {
  final CourseTreeNode node;
  final String query;
  final String imagePath;
  final CourseTreeNode sarvogyan;
  ExamCategScreen(this.sarvogyan, this.query, this.node, this.imagePath);
  @override
  _ExamCategScreenState createState() => _ExamCategScreenState();
}

class _ExamCategScreenState extends State<ExamCategScreen> {
  SizeConfig screenSize;
  NavDrawer navDrawer = NavDrawer('examCategScreen');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.query);
  }

  Widget ShowScreen() {
    if (widget.node == null) {
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
//      child: ListView.builder(
//          itemBuilder: (BuildContext cntxt, int index) {
//            return ReusableCourseCard(
//              color: Theme.of(context).accentColor,
//              courseName: veh[index].name,
//              subscription: getSubscription(index),
//              teacher: veh[index].teacher,
//              image: veh[index].picture,
//              onTap: () {
//                setState(() {
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) {
//                        return CourseSelectedLoadingScreen(
//                            veh[index].id);
//                      }));
//                });
//              },
//            );
//          },
//          itemCount: veh.length,
//          padding: EdgeInsets.fromLTRB(
//              0,
//              screenSize.screenHeight * 2.5,
//              0,
//              screenSize.screenHeight * 2.5)),,
              ));
    } else {
      return Scaffold(
          drawer: navDrawer.getNavDrawer(context, widget.sarvogyan),
          body: Container(
            child: Column(
              children: [
                SizedBox(
                  height: screenSize.screenHeight * 5,
                ),
                Container(
                  width: screenSize.screenWidth * 100,
                  height: screenSize.screenHeight * 75,
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
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AllExamsScreen(
                                  widget.query +
                                      "${widget.node.children[index].value} ",
                                  widget.node.children[index],
                                );
                              }));
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
                                        height: screenSize.screenHeight * 11,
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

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return ShowScreen();
  }
}
