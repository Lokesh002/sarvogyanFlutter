import 'package:flutter/material.dart';
import 'package:sarvogyan/Screens/course/courseCategScreen.dart';
import 'package:sarvogyan/components/courseTree.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class AllCoursesScreen extends StatefulWidget {
  CourseTreeNode node;
  String imagePath;
  CourseTreeNode sarvogyan;
  AllCoursesScreen(this.sarvogyan, this.node, this.imagePath);
  @override
  _AllCoursesScreenState createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  SizeConfig screenSize;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                                return CourseCategScreen(
                                    widget.sarvogyan,
                                    "",
                                    widget.node.children[index],
                                    'images/media',
                                    false);
                              }));
                            },
                            child: Container(
                              width: screenSize.screenWidth * 40,
                              height: screenSize.screenHeight * 30,
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    screenSize.screenHeight * 2),
                                elevation: screenSize.screenHeight * 1,
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
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: screenSize.screenWidth * 1,
                                          right: screenSize.screenWidth * 1,
                                          bottom: screenSize.screenHeight * 1,
                                          top: screenSize.screenHeight * 1),
                                      child: Text(
                                        widget.node.children[index].value,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                screenSize.screenHeight * 2),
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
          ),
        ));
  }
}
