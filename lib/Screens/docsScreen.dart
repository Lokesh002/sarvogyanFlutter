import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sarvogyan/Screens/login.dart';
import 'package:sarvogyan/components/DocsCard.dart';
import 'package:sarvogyan/components/ReusableButton.dart';
import 'package:sarvogyan/components/getAllDocs.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class DocsScreen extends StatefulWidget {
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
  bool downloadComplete = false;
  String downloadMessage = 'Initializing...';
  bool isDownloading = false;
  List<Docs> docsList;
  String accessTKN;
  Future download(String url, String name) async {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_MUSIC);
    String fullPath = "$path/$name";

    try {
      Dio dio = Dio();
      showAlertDialog(context);
      Response response =
          await dio.get(url, onReceiveProgress: (actualbytes, totalbytes) {
        var percentage = (actualbytes / totalbytes) * 100;

        setState(() {
          downloadMessage = 'Downoading....  ${percentage.floor()}%';
          if (percentage == 100) {
            downloadComplete = true;
            setState(() {
              Fluttertoast.showToast(
                  msg: "Go to Internal Storage/Downloads to check the file.");
            });
          }
        });
      },
              options: Options(
                  responseType: ResponseType.bytes,
                  followRedirects: false,
                  validateStatus: (status) {
                    return status < 500;
                  }));
      File file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }

//
//    dio.download(url, '${dir.path}/kartikResume.pdf',
//        onReceiveProgress: (actualbytes, totalbytes) {
//      var percentage = (actualbytes / totalbytes) * 100;
//
//      setState(() {
//        downloadMessage = 'Downoading....  ${percentage.floor()}%';
//        if(percentage==100)
    //{
    //     downloadComplete=true;
    //}
//      });
//    });
    downloadComplete = true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) getDocsList();
    getPermission();
  }

  void getDocsList() async {
    List<Docs> docsList;
    GetAllDocs getAllDocs = GetAllDocs();
    docsList = await getAllDocs.getDocsList();
    this.docsList = docsList;
    isReady = true;
    if (mounted) setState(() {});
  }

  Future getPermission() async {
    print("permission");
    accessTKN = await savedData.getAccessToken();
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Widget ShowScreen(bool isReady) {
    if (accessTKN == null) {
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
    } else if (!isReady) {
      return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: SpinKitWanderingCubes(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          size: 100.0,
        ),
      );
    } else if (docsList.length != 0) {
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
                              docName: docsList[index].name,
                              color: Theme.of(context).backgroundColor,
                              button: ReusableButton(
                                  height: screenSize.screenHeight * 5,
                                  width: screenSize.screenWidth * 15,
                                  content: "Download",
                                  onPress: () async {
                                    await download(docsList[index].link,
                                        docsList[index].name);
                                  }),
                            );
                          },
                          itemCount: docsList.length,
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
    } else {
      return Column(children: <Widget>[
        SizedBox(
          height: screenSize.screenHeight * 10,
        ),
        Container(
          height: screenSize.screenHeight * 20,
          child: SvgPicture.asset('svg/analysis.svg',
              semanticsLabel: 'A red up arrow'),
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    return ShowScreen(isReady);
  }
}
