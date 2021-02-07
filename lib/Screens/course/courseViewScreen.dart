import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:sarvogyan/Screens/video/videoScreen.dart';

import 'package:sarvogyan/components/Cards/reusableOptionCard.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

import 'package:sarvogyan/utilities/sharedPref.dart';

import 'package:sarvogyan/components/fetchLessonsData.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:sarvogyan/Screens/course/readCourseDocScreen.dart';

class CourseViewScreen extends StatefulWidget {
  var decodedData;
  List<Lessons> lessonsList;
  CourseViewScreen(this.decodedData, this.lessonsList);
  @override
  _CourseViewScreenState createState() => _CourseViewScreenState();
}

class _CourseViewScreenState extends State<CourseViewScreen> {
  SavedData savedData = SavedData();
  var decData;
  List<Lessons> lessList;

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

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    final x = screenSize.screenHeight * 50;
    print(widget.decodedData["name"]);
    decData = widget.decodedData;
    lessList = widget.lessonsList;
    print('the name is');

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.decodedData['name']),
        ),
        body: ListView.builder(
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
                    width: screenSize.screenWidth * 80,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: screenSize.screenWidth * 3,
                            right: screenSize.screenWidth * 3),
                        child: Text(
                            (index1 + 1).toString() +
                                " " +
                                lessList[index1].lessonName,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  height: screenSize.screenHeight * 10,
                  width: screenSize.screenWidth * 80,
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
                              width: screenSize.screenWidth * 80,
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
                                        (index1 + 1).toString() +
                                            "." +
                                            (index2 + 1).toString() +
                                            " " +
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
                            )),
                            elevation: 2,
                            color: Theme.of(context).accentColor,
                            width: screenSize.screenWidth * 80,
                            height: screenSize.screenHeight * 10,
                          ),
                          onTap: () {
                            print(
                                lessList[index1].lessonParts[index2].partType);
                            if (lessList[index1].lessonParts[index2].partType ==
                                    'video' ||
                                lessList[index1].lessonParts[index2].partType ==
                                    'Video') {
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
                                      .partType ==
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
                  },
                ),
              ],
            );
          },
        ));
  }
}
