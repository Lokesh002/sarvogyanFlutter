import 'package:flutter/material.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //SavedData savedData = SavedData();

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/homeScreen');
    });
  }

  DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Hero(
            tag: 'logo',
            child: Container(
              width: screenSize.screenWidth * 100,
              height: screenSize.screenHeight * 70,
              child: Image.asset("images/logo.png"),
            ),
          ),
        ));
  }
}
