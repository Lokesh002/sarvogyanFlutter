import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sarvogyan/Screens/courseSelected.dart';
import 'package:sarvogyan/components/courseListData.dart';

class CourseSelectedLoadingScreen extends StatefulWidget {
  String id;
  CourseSelectedLoadingScreen(this.id);
  @override
  _CourseSelectedLoadingScreenState createState() =>
      _CourseSelectedLoadingScreenState();
}

class _CourseSelectedLoadingScreenState
    extends State<CourseSelectedLoadingScreen> {
  CourseModel courseModel = CourseModel();

  void getdata() async {
    var decodedData = await courseModel.getCourseDetails(widget.id);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      print("hello world");
      print(decodedData);
      return CourseSelected(decodedData);
    }));
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: Container(
          child: SpinKitWanderingCubes(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
