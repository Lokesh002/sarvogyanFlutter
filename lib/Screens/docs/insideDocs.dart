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

class InsideDocs extends StatefulWidget {
  final String path;
  InsideDocs(this.path);
  @override
  _InsideDocsState createState() => _InsideDocsState();
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

class _InsideDocsState extends State<InsideDocs> {
  bool isReady = false;
  SavedData savedData = SavedData();
  SizeConfig screenSize;
  bool downloadComplete = false;
  String downloadMessage = 'Initializing...';
  bool isDownloading = false;
  List<Docs> docsList;

  Future download(String url, String name) async {
    String path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath = "$path/$name";

    try {
      Dio dio = Dio();
      showAlertDialog(context);
      Response response =
          await dio.get(url, onReceiveProgress: (actualbytes, totalbytes) {
        var percentage = (actualbytes / totalbytes) * 100;

        setState(() {
          downloadMessage = 'Downloading....  ${percentage.floor()}%';
          if (percentage == 100) {
            downloadComplete = true;
            setState(() {
              Fluttertoast.showToast(
                  msg: "Go to Internal Storage/Downloads to check the file.",
                  toastLength: Toast.LENGTH_LONG);
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
    if (mounted) getDocsList(widget.path);
    //getPermission();
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  List<Doc> allDocs = List<Doc>();
  void getDocsList(String path) async {
    Reference storageRef = storage.ref().child(path);
    await storageRef.listAll().then((value) async {
      for (Reference prefix in value.prefixes) {
        allDocs.add(Doc(name: prefix.name, link: '', isFolder: true));

        log(prefix.name);
      }
      for (var item in value.items) {
        allDocs.add(Doc(
          name: item.name,
          isFolder: false,
          link: '',
        ));
        log(item.toString());
      }
    });

    if (mounted)
      setState(() {
        isReady = true;
      });
  }

  Future getPermission() async {
    print("permission");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Widget showScreen() {
    print('hello');
    if (!isReady) {
      return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: SpinKitWanderingCubes(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          size: 100.0,
        ),
      );
    } else if (allDocs.length != 0) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('E Books'),
        ),
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
                      height: screenSize.screenHeight * 90,
                      child: ListView.builder(
                          itemBuilder: (BuildContext cntxt, int index) {
                            return ReusableDocsCard(
                              docName: allDocs[index].name,
                              isFolder: allDocs[index].isFolder,
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return InsideDocs(widget.path +
                                      '/' +
                                      allDocs[index].name +
                                      '/');
                                }));
                              },
                              color: Theme.of(context).backgroundColor,
                              button: ReusableButton(
                                  height: screenSize.screenHeight * 5,
                                  width: screenSize.screenWidth * 15,
                                  content: "Download",
                                  onPress: () async {
                                    Reference stRef = storage.ref().child(
                                        widget.path +
                                            '/' +
                                            allDocs[index].name +
                                            '/');

                                    await download(await stRef.getDownloadURL(),
                                        allDocs[index].name);
                                  }),
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
    } else {
      print('hello2');
      return Scaffold(
        body: Column(children: <Widget>[
          SizedBox(
            height: screenSize.screenHeight * 10,
          ),
          Container(
            height: screenSize.screenHeight * 20,
            child: SvgPicture.asset('svg/analysis.svg',
                semanticsLabel: 'A red up arrow'),
          ),
        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    return showScreen();
  }
}
