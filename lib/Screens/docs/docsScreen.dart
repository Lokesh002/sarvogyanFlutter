import 'dart:io';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/components/Cards/CertificateCard.dart';
import 'package:sarvogyan/components/Cards/DocsCard.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/docsSupport.dart';
import 'package:sarvogyan/components/getAllDocs.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/Screens/docs/insideDocs.dart';

class DocsScreen extends StatefulWidget {
  String path;
  DocsScreen(this.path);
  @override
  _DocsScreenState createState() => _DocsScreenState();
}

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _DocsScreenState extends State<DocsScreen> {
  bool isReady = false;
  SavedData savedData = SavedData();
  SizeConfig screenSize;

  String accessTKN;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) getDocsList(widget.path);
    getPermission();
  }

  Future getPermission() async {
    print("permission");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  List<Doc> allDocs = List<Doc>();
  void getDocsList(String path) async {
    accessTKN = await savedData.getAccessToken();

    Reference storageRef = storage.ref().child(path);
    await storageRef.listAll().then((value) async {
      for (Reference prefix in value.prefixes) {
        allDocs.add(Doc(name: prefix.name, isFolder: true, link: ''));

        log(prefix.name);
      }
      for (var item in value.items) {
        allDocs.add(Doc(
          isFolder: false,
          name: item.name,
          link: await item.getDownloadURL(),
        ));
        log(item.toString());
      }
    });

    isReady = true;
    if (mounted) setState(() {});
  }

  Widget ShowScreen() {
    // print(isReady.toString());
    if (isReady == false) {
      return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: SpinKitWanderingCubes(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          size: 100.0,
        ),
      );
    } else if (accessTKN == null) {
      return Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: screenSize.screenHeight * 10,
              ),
              Container(
                height: screenSize.screenHeight * 20,
                child: SvgPicture.asset('svg/pleaseLogin.svg',
                    semanticsLabel: 'A red up arrow'),
              ),
              SizedBox(
                height: screenSize.screenHeight * 5,
              ),
              Text(
                "Please Login First",
              ),
              SizedBox(
                height: screenSize.screenHeight * 20,
              ),
              ReusableButton(
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Login(true);
                  }));
                },
                height: screenSize.screenHeight * 7,
                width: screenSize.screenWidth * 30,
                content: "Login",
              )
            ],
          ),
        ),
      );
    } else if (allDocs.length != 0) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: screenSize.screenHeight * 1,
              ),
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Container(
                      height: screenSize.screenHeight * 80,
                      child: ListView.builder(
                          itemBuilder: (BuildContext cntxt, int index) {
                            return ReusableDocsCard(
                              docName: allDocs[index].name,
                              //icon: Icon(Icons.folder),
                              isFolder: allDocs[index].isFolder,
                              color: Theme.of(context).backgroundColor,
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return InsideDocs(widget.path +
                                      '/' +
                                      allDocs[index].name +
                                      '/');
                                }));
                              },
                              button: SizedBox(),
                            );
                          },
                          itemCount: allDocs.length,
                          padding: EdgeInsets.fromLTRB(
                              0, screenSize.screenHeight * 2.5, 0, 0
                              //screenSize.screenHeight * 15)),
                              ))),
                ],
              ),
            ],
          ),
        ),
      );
    }
//    else if (allDocs.length == 0) {
//      return Column(children: <Widget>[
//        SizedBox(
//          height: screenSize.screenHeight * 10,
//        ),
//        Container(
//          height: screenSize.screenHeight * 20,
//          child: SvgPicture.asset('svg/analysis.svg',
//              semanticsLabel: 'A red up arrow'),
//        ),
//      ]);
//    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    return ShowScreen();
  }
}
