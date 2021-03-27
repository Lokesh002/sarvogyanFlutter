import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sarvogyan/Screens/video/Exams.dart';
import 'package:sarvogyan/Screens/video/askDoubts.dart';
import 'package:sarvogyan/Screens/video/docs.dart';
import 'package:sarvogyan/Screens/video/makeNotes.dart';

import 'package:sarvogyan/Screens/video/videoScreen.dart';

import 'package:sarvogyan/components/Cards/reusableOptionCard.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

import 'package:sarvogyan/utilities/sharedPref.dart';

import 'package:sarvogyan/components/fetchLessonsData.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:sarvogyan/Screens/course/readCourseDocScreen.dart';

class CourseViewScreen extends StatefulWidget {
  final decodedData;
  final List<Lessons> lessonsList;
  CourseViewScreen(this.decodedData, this.lessonsList);
  @override
  _CourseViewScreenState createState() => _CourseViewScreenState();
}

class _CourseViewScreenState extends State<CourseViewScreen> {
  SavedData savedData = SavedData();
  var decData;
  List<Lessons> lessList;
  SizeConfig screenSize;
  PageController pageController = new PageController();
  List<Lessons> docsList = List<Lessons>();
  int currentIndex = 0;
  Widget getIcon(String partType) {
    if (partType.toLowerCase() == 'video')
      return Icon(
        Icons.video_library,
        color: Theme.of(context).primaryColor,
        size: screenSize.screenWidth * 6,
      );
    else
      return Icon(
        Icons.library_books,
        color: Theme.of(context).primaryColor,
        size: screenSize.screenWidth * 6,
      );
  }

  void getData() {
    decData = widget.decodedData;
    lessList = widget.lessonsList;

    for (int i = 0; i < lessList.length; i++) {
      Lessons lessonDoc = Lessons();
      List<Parts> partsList = List<Parts>();
      bool istrue = false;
      for (int j = 0; j < lessList[i].lessonParts.length; j++) {
        if (lessList[i].lessonParts[j].partType.toLowerCase() != 'video') {
          Parts part = Parts();
          part.partType = lessList[i].lessonParts[j].partType;
          part.partName = lessList[i].lessonParts[j].partName;
          part.partId = lessList[i].lessonParts[j].partId;
          part.partLessonId = lessList[i].lessonParts[j].partLessonId;
          part.partContent = lessList[i].lessonParts[j].partContent;
          part.partNo = lessList[i].lessonParts[j].partNo;
          partsList.add(part);
          istrue = true;
        }
      }
      if (istrue) {
        lessonDoc.lessonParts = partsList;
        lessonDoc.lessonNo = lessList[i].lessonNo;
        lessonDoc.lessonName = lessList[i].lessonName;
        lessonDoc.lessonId = lessList[i].lessonId;
        lessonDoc.lessonDesc = lessList[i].lessonDesc;
        lessonDoc.lessonTeacher = lessList[i].lessonTeacher;
        lessonDoc.lessonCourseId = lessList[i].lessonCourseId;
        docsList.add(lessonDoc);
      }
    }
  }

  Widget getCourseView() {
    return ListView.builder(
      itemCount: lessList.length,
      itemBuilder: (context, index1) {
        return Column(
          children: <Widget>[
            SizedBox(
              height: screenSize.screenHeight * 2,
            ),
            ReusableOptionCard(
              cardChild: Container(
                height: screenSize.screenHeight * 10,
                width: screenSize.screenWidth * 84,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: screenSize.screenWidth * 3,
                        right: screenSize.screenWidth * 3),
                    child: Text(
                        lessList[index1].lessonNo +
                            '. ' +
                            lessList[index1].lessonName,
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              height: screenSize.screenHeight * 10,
              width: screenSize.screenWidth * 84,
              color: Theme.of(context).primaryColor,
              elevation: 5,
            ),
            SizedBox(
              height: screenSize.screenHeight * 2,
            ),
            ListView.builder(
              itemCount: lessList[index1].lessonParts.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index2) {
                if (lessList[index1]
                        .lessonParts[index2]
                        .partType
                        .toLowerCase() ==
                    'video') {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: screenSize.screenHeight * 1,
                      ),
                      GestureDetector(
                        child: ReusableOptionCard(
                          cardChild: Center(
                              child: Container(
                            height: screenSize.screenHeight * 10,
                            width: screenSize.screenWidth * 84,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.screenWidth * 2),
                              child: Center(
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: screenSize.screenWidth * 2,
                                    ),
                                    getIcon(lessList[index1]
                                        .lessonParts[index2]
                                        .partType),
                                    SizedBox(
                                      width: screenSize.screenWidth * 2,
                                    ),
                                    Container(
                                      width: screenSize.screenWidth * 70,
                                      child: Text(
                                        lessList[index1]
                                                .lessonParts[index2]
                                                .partNo +
                                            ' ' +
                                            lessList[index1]
                                                .lessonParts[index2]
                                                .partName,
                                        style: TextStyle(color: Colors.black),
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                ),
                              ),
                            ),
                          )),
                          elevation: 2,
                          color: Theme.of(context).accentColor,
                          width: screenSize.screenWidth * 84,
                          height: screenSize.screenHeight * 10,
                        ),
                        onTap: () {
                          print(lessList[index1].lessonParts[index2].partType);
                          if (lessList[index1]
                                  .lessonParts[index2]
                                  .partType
                                  .toLowerCase() ==
                              'video') {
//                              String videoURL = lessList[index1]
//                                  .lessonParts[index2]
//                                  .partContent;
                            String videoURL = lessList[index1]
                                .lessonParts[index2]
                                .partContent;
                            String e = 'embed/';
                            String id = videoURL.substring(
                                videoURL.indexOf(e) + e.length,
                                videoURL.length);
                            String name =
                                lessList[index1].lessonParts[index2].partName;
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                //return CourseVideoScreen(videoURL);
                                return VideoScreen(
                                    index1: index1,
                                    index2: index2,
                                    name: name,
                                    id: id,
                                    decData: widget.decodedData,
                                    lessonList: widget.lessonsList);
                              },
                            ));

//                              FlutterYoutube.onVideoEnded.listen((onData) {
//                                //perform your action when video playing is done
//                              });
//
//                              FlutterYoutube.playYoutubeVideoById(
//                                apiKey:
//                                    "AIzaSyCvWWU3e_Kvk6vBwRmKznYulu8QyxyFXsw",
//                                videoId: id,
//                              );
                          } else {
                            if (lessList[index1]
                                    .lessonParts[index2]
                                    .partType
                                    .toLowerCase() ==
                                'text') {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ReadCourseDocScreen(
                                      lessList[index1]
                                          .lessonParts[index2]
                                          .partContent,
                                      lessList[index1]
                                          .lessonParts[index2]
                                          .partName);
                                },
                              ));
                            }
                          }
                        },
                      ),
                    ],
                  );
                } else {
                  return null;
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    pageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    print('the name is');

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.decodedData['name']),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (page) {
            setState(() {
              currentIndex = page;
            });
            pageController.jumpToPage(page);
          },
          currentIndex: currentIndex,
          selectedIconTheme:
              IconThemeData(color: Theme.of(context).primaryColor),
          unselectedIconTheme:
              IconThemeData(color: Theme.of(context).accentColor),
          unselectedLabelStyle: TextStyle(color: Colors.white),
          backgroundColor: Colors.grey.shade700,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: "Videos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: "Documents",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.border_color), label: "Exams"),
            BottomNavigationBarItem(
                icon: Icon(Icons.note_add), label: "Make Notes"),
            BottomNavigationBarItem(
                icon: Icon(Icons.help), label: "Ask Doubts"),
          ],
        ),
        body: PageView(
          onPageChanged: (index) {
            currentIndex = index;
            setState(() {});
          },
          controller: pageController,
          children: [
            getCourseView(),
            Docs(docsList),
            Exams(widget.decodedData),
            MakeNotes(widget.decodedData),
            AskDoubts(widget.decodedData),
          ],
        ));
  }
}
