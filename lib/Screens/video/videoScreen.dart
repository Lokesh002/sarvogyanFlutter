import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sarvogyan/Screens/course/readCourseDocScreen.dart';
import 'package:sarvogyan/Screens/video/Exams.dart';
import 'package:sarvogyan/Screens/video/askDoubts.dart';
import 'package:sarvogyan/Screens/video/docs.dart';
import 'package:sarvogyan/Screens/video/makeNotes.dart';
import 'package:sarvogyan/components/fetchLessonsData.dart';
import 'package:sarvogyan/components/Cards/reusableOptionCard.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String id;
  var decData;
  final List<Lessons> lessonList;
  int index1;
  int index2;
  String name;

  VideoScreen(
      {this.id,
      this.decData,
      this.lessonList,
      this.name,
      this.index2,
      this.index1});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController _controller;
  bool listVisible = true;
  SavedData savedData = SavedData();
  PlayerState playerState;
  YoutubeMetaData videoMetaData;
  bool _isPlayerReady = false;
  List lessonList;
  List<Lessons> docsList = List<Lessons>();
  List<Lessons> lessList = List<Lessons>();

  PageController pageController = new PageController();

  int currentIndex = 0;

  SizeConfig screenSize;
  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    videoMetaData = const YoutubeMetaData();
    playerState = PlayerState.unknown;
    getData();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        listVisible = true;

        playerState = _controller.value.playerState;
        videoMetaData = _controller.metadata;
      });
    } else if (_controller.value.isFullScreen) {
      setState(() {
        listVisible = false;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();

    pageController.dispose();
    super.dispose();
  }

  Color getColor(int index1, int index2) {
    if (index1 == widget.index1) {
      if (index2 == widget.index2) {
        return Colors.redAccent;
      }
    }

    return Theme.of(context).accentColor;
  }

  Widget getIcon(String partType, int index1, int index2) {
    if (partType.toLowerCase() == 'video')
      return Icon(
        Icons.video_library,
        color: index1 == widget.index1
            ? index2 == widget.index2
                ? Colors.white
                : Theme.of(context).primaryColor
            : Theme.of(context).primaryColor,
        size: screenSize.screenWidth * 6,
      );
    else
      return Icon(
        Icons.library_books,
        color: index1 == widget.index1
            ? index2 == widget.index2
                ? Colors.white
                : Theme.of(context).primaryColor
            : Theme.of(context).primaryColor,
        size: screenSize.screenWidth * 6,
      );
  }

  void getData() {
    // decData = widget.decodedData;
    lessList = widget.lessonList;

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

  Widget videoBody(var player) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        player,
        SizedBox(
          height: screenSize.screenHeight * 1,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: screenSize.screenWidth * 6,
            ),
            Text(
              widget.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenSize.screenHeight * 2.5,
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenSize.screenHeight * 1,
        ),
        Visibility(
          visible: listVisible,
          child: Container(
            width: screenSize.screenWidth * 100,
            height: screenSize.screenHeight * 50,
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
                        width: screenSize.screenWidth * 84,
                        child: Center(
                          child: Text(
                              widget.lessonList[index1].lessonNo +
                                  ". " +
                                  widget.lessonList[index1].lessonName,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      height: screenSize.screenHeight * 7,
                      width: screenSize.screenWidth * 84,
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
                      itemBuilder: (contxt, index2) {
                        if (widget
                                .lessonList[index1].lessonParts[index2].partType
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
                                          horizontal:
                                              screenSize.screenWidth * 2),
                                      child: Center(
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: screenSize.screenWidth * 2,
                                            ),
                                            getIcon(
                                                widget
                                                    .lessonList[index1]
                                                    .lessonParts[index2]
                                                    .partType,
                                                index1,
                                                index2),
                                            SizedBox(
                                              width: screenSize.screenWidth * 2,
                                            ),
                                            Container(
                                              width:
                                                  screenSize.screenWidth * 70,
                                              child: Text(
                                                widget
                                                        .lessonList[index1]
                                                        .lessonParts[index2]
                                                        .partNo +
                                                    " " +
                                                    widget
                                                        .lessonList[index1]
                                                        .lessonParts[index2]
                                                        .partName,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                        ),
                                      ),
                                    ),
                                  )),
                                  elevation: index1 == widget.index1
                                      ? index2 == widget.index2
                                          ? 0
                                          : 5
                                      : 5,
                                  color: getColor(index1, index2),
                                  width: screenSize.screenWidth * 84,
                                  height: screenSize.screenHeight * 7,
                                ),
                                onTap: () {
                                  print(widget.lessonList[index1]
                                      .lessonParts[index2].partType);
                                  if (widget.lessonList[index1]
                                          .lessonParts[index2].partType
                                          .toLowerCase() ==
                                      'video') {
                                    String videoURL = widget.lessonList[index1]
                                        .lessonParts[index2].partContent;
                                    String e = 'embed/';
                                    String id = videoURL.substring(
                                        videoURL.indexOf(e) + e.length,
                                        videoURL.length);
                                    String name = widget.lessonList[index1]
                                        .lessonParts[index2].partName;
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return VideoScreen(
                                            index1: index1,
                                            index2: index2,
                                            name: name,
                                            id: id,
                                            decData: widget.decData,
                                            lessonList: widget.lessonList);
                                      },
                                    ));

//
                                  } else {
                                    if (widget.lessonList[index1]
                                            .lessonParts[index2].partType
                                            .toLowerCase() ==
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
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    return YoutubePlayerBuilder(
//      onExitFullScreen: () {
//        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
//        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {
          print('Player is ready.');

          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller.pause();
          _controller.play();

          // .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          // _showSnackBar('Next Video Started!');
        },
      ),
      builder: (context, player) => Scaffold(
          appBar: AppBar(
            title: Text(widget.name),
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
              videoBody(player),
              Docs(docsList),
              Exams(widget.decData),
              MakeNotes(widget.decData),
              AskDoubts(widget.decData),
            ],
          )),
    );
  }
}
