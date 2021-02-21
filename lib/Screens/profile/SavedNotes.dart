import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class SavedNotes extends StatefulWidget {
  @override
  _SavedNotesState createState() => _SavedNotesState();
}

class _SavedNotesState extends State<SavedNotes> {
  SizeConfig screenSize;

  Widget ShowScreen() {
    if (!isReady) {
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
        appBar: AppBar(
          title: Text('Notes'),
        ),
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            height: screenSize.screenHeight * 80,
            child: ListView.builder(
                itemBuilder: (BuildContext cntxt, int index) {
                  return Container(
                    color: Theme.of(context).accentColor,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.screenWidth * 2),
                              child: Container(
                                  child: Image.asset(
                                'images/media/note.png',
                                height: screenSize.screenHeight * 7,
                              )),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.screenWidth * 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: screenSize.screenWidth * 70,
                                    child: Text(
                                      notesList[index]['noteTitle'],
                                      style: TextStyle(
                                          fontSize: screenSize.screenHeight * 3,
                                          color: Colors.black54),
                                    ),
                                  ),
                                  Text(
                                    'Created on: ' +
                                        notesList[index]['date'].toString(),
                                    style: TextStyle(
                                        fontSize: screenSize.screenHeight * 1.5,
                                        color: Colors.blueGrey),
                                  ),
                                  Container(
                                    width: screenSize.screenWidth * 70,
                                    child: Text(
                                      notesList[index]['noteDesc'],
                                      style: TextStyle(
                                          fontSize:
                                              screenSize.screenHeight * 2.3),
                                    ),
                                  ),
                                  Container(
                                    width: screenSize.screenWidth * 70,
                                    child: Text(
                                      'Related to ' +
                                          notesList[index]['courseName']
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: screenSize.screenHeight * 2,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.black26,
                          thickness: 1,
                        )
                      ],
                    ),
                  );
                },
                itemCount: notesList.length,
                padding: EdgeInsets.fromLTRB(0, screenSize.screenHeight * 2.5,
                    0, screenSize.screenHeight * 2.5)),
          ),
        ),
      );
    }
  }

  List<dynamic> notesList;
  SavedData savedData = SavedData();
  String uID;
  void getData() async {
    uID = await savedData.getUserId();
    Networking networking = Networking();
    var decData = await networking.getData('api/course/getNotes/$uID');

    notesList = decData['notes'];
    log(notesList.toString());
    setState(() {
      isReady = true;
    });
  }

  bool isReady = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    print(notesList);
    screenSize = SizeConfig(context);

    return ShowScreen();
  }
}
