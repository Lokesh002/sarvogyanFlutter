import 'package:flutter/material.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class ReadCourseDocScreen extends StatefulWidget {
  final String data;
  final String title;
  ReadCourseDocScreen(this.data, this.title);

  @override
  _ReadCourseDocScreenState createState() => _ReadCourseDocScreenState();
}

class _ReadCourseDocScreenState extends State<ReadCourseDocScreen> {
  SizeConfig screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Container(
          width: screenSize.screenWidth * 80,
          height: double.infinity,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: screenSize.screenHeight * 5,
              ),
              Text(
                widget.data,
                softWrap: true,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: screenSize.screenHeight * 3,
                    fontFamily: "Roboto"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
