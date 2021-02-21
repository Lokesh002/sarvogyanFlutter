import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';

import 'package:sarvogyan/components/Cards/DocsCard.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/getAllDocs.dart';

import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class CertificateScreen extends StatefulWidget {
  @override
  _CertificateScreenState createState() => _CertificateScreenState();
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

class _CertificateScreenState extends State<CertificateScreen> {
  bool isReady = false;
  SavedData savedData = SavedData();
  SizeConfig screenSize;
  bool downloadComplete = false;
  String downloadMessage = 'Initializing...';
  bool isDownloading = false;
  List<Docs> docsList;
  String userID;
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
    if (mounted) getCertificates();
    getPermission();
  }

  List certificates = List();
  void getCertificates() async {
    Networking networking = Networking();
    userID = await savedData.getUserId();

    var data =
        await networking.getData('/api/document/getUserCertificates/' + userID);
    // log(data.toString());
    certificates = data['files'];
    log(certificates[0].toString());
    isReady = true;
    if (mounted) setState(() {});
  }

  Future getPermission() async {
    print("permission");

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Widget ShowScreen(bool isReady) {
    if (certificates.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Certificates'),
        ),
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
                              docName: certificates[index]['name']
                                  .toString()
                                  .substring(13 + userID.length + 1),
                              color: Theme.of(context).backgroundColor,
                              button: ReusableButton(
                                  height: screenSize.screenHeight * 5,
                                  width: screenSize.screenWidth * 15,
                                  content: "Download",
                                  onPress: () async {
                                    await download(
                                        certificates[index]['metadata']
                                            ['mediaLink'],
                                        certificates[index]['name']
                                            .toString()
                                            .substring(13 + userID.length + 1));
                                  }),
                            );
                          },
                          itemCount: certificates.length,
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
      return Scaffold(
        appBar: AppBar(
          title: Text('Certificates'),
        ),
        body: Column(children: <Widget>[
          SizedBox(
            height: screenSize.screenHeight * 10,
          ),
          Container(
            height: screenSize.screenHeight * 20,
            child: SvgPicture.asset('svg/analysis.svg',
                semanticsLabel: 'A red up arrow'),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: screenSize.screenHeight * 3),
            child: Text(
              'No Certificates Available.',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.screenHeight * 3),
            ),
          )
        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    if (isReady)
      return ShowScreen(isReady);
    else
      return Scaffold(
          backgroundColor: Color(0xffffffff),
          body: SpinKitWanderingCubes(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
            size: 100.0,
          ));
  }
}
