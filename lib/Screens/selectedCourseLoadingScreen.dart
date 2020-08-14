import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class SelectedCourseLoadingScreen extends StatefulWidget {
  @override
  _SelectedCourseLoadingScreenState createState() =>
      _SelectedCourseLoadingScreenState();
}

class _SelectedCourseLoadingScreenState
    extends State<SelectedCourseLoadingScreen> {
  void verify() async {}

  @override
  void initState() {
    super.initState();
    verify();
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
