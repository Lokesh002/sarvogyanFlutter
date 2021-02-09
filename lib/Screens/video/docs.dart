import 'package:flutter/material.dart';
import 'package:sarvogyan/Screens/course/readCourseDocScreen.dart';
import 'package:sarvogyan/components/Cards/reusableOptionCard.dart';
import 'package:sarvogyan/components/fetchLessonsData.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class Docs extends StatefulWidget {
  final List<Lessons> lessonList;
  Docs(this.lessonList);

  @override
  _DocsState createState() => _DocsState();
}

class _DocsState extends State<Docs> {
  SizeConfig screenSize;

  Widget getIcon(String partType) {
    if (partType == 'video' || partType == 'Video')
      return Icon(
        Icons.video_library,
        color: Theme.of(context).primaryColor,
      );
    else
      return Icon(
        Icons.library_books,
        color: Theme.of(context).primaryColor,
      );
  }

  Widget docBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: screenSize.screenHeight * 1,
        ),
        Visibility(
          visible: true,
          child: Container(
            width: screenSize.screenWidth * 100,
            height: screenSize.screenHeight * 79,
            child: ListView.builder(
              itemCount: widget.lessonList.length,
              itemBuilder: (context, index1) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: screenSize.screenHeight * 2,
                    ),
                    ReusableOptionCard(
                      cardChild: Container(
                        height: screenSize.screenHeight * 7,
                        width: screenSize.screenWidth * 80,
                        child: Center(
                          child: Text(
                              (index1 + 1).toString() +
                                  " " +
                                  widget.lessonList[index1].lessonName,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      height: screenSize.screenHeight * 7,
                      width: screenSize.screenWidth * 80,
                      color: Theme.of(context).primaryColor,
                      elevation: 5,
                    ),
                    SizedBox(
                      height: screenSize.screenHeight * 2,
                    ),
                    ListView.builder(
                        itemCount: widget.lessonList[index1].lessonParts.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (cotxt, index2) {
                          if (widget.lessonList[index1].lessonParts[index2]
                                  .partType ==
                              'text') {
                            return Column(
                              children: <Widget>[
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                GestureDetector(
                                    child: ReusableOptionCard(
                                      cardChild: Center(
                                          child: Container(
                                        height: screenSize.screenHeight * 7,
                                        width: screenSize.screenWidth * 80,
                                        child: Center(
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width:
                                                    screenSize.screenWidth * 2,
                                              ),
                                              getIcon(widget
                                                  .lessonList[index1]
                                                  .lessonParts[index2]
                                                  .partType),
                                              SizedBox(
                                                width:
                                                    screenSize.screenWidth * 2,
                                              ),
                                              Text(
                                                (index1 + 1).toString() +
                                                    "." +
                                                    (index2 + 1).toString() +
                                                    " " +
                                                    widget
                                                        .lessonList[index1]
                                                        .lessonParts[index2]
                                                        .partName,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                          ),
                                        ),
                                      )),
                                      elevation: 5,
                                      color: Colors.white,
                                      width: screenSize.screenWidth * 80,
                                      height: screenSize.screenHeight * 5,
                                    ),
                                    onTap: () {
                                      print(widget.lessonList[index1]
                                          .lessonParts[index2].partType);

                                      if (widget.lessonList[index1]
                                              .lessonParts[index2].partType ==
                                          'text') {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return ReadCourseDocScreen(
                                                widget
                                                    .lessonList[index1]
                                                    .lessonParts[index2]
                                                    .partContent,
                                                widget
                                                    .lessonList[index1]
                                                    .lessonParts[index2]
                                                    .partName);
                                          },
                                        ));
                                      }
                                    }),
                              ],
                            );
                          } else {
                            return null;
                          }
                        }),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return Scaffold(
      body: Container(
        child: docBody(),
      ),
    );
  }
}
