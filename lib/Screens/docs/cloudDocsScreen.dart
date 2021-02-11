import 'package:flutter/material.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class CloudDocsScreen extends StatefulWidget {
  @override
  _CloudDocsScreenState createState() => _CloudDocsScreenState();
}

class _CloudDocsScreenState extends State<CloudDocsScreen> {
  SizeConfig screenSize;

  FirebaseStorage storage = FirebaseStorage.instance;

  void _getData() async {
    StorageReference storageRef = storage.ref();
    StorageReference ref = storageRef.child('course/2yhfzHyC4hEbE6I8CuWL.jpeg');
    //StorageMetadata storageMetadata = StorageMetadata();
    //print(storageMetadata.path);

    print(await ref.getDownloadURL());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return Scaffold(
      body: Container(
        height: screenSize.screenHeight * 80,
        width: screenSize.screenWidth * 100,
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
