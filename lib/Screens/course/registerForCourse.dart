import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarvogyan/Screens/course/courseRegistrationLoadingScreen.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';

class RegisterForCourseScreen extends StatefulWidget {
  var courseData;
  RegisterForCourseScreen(this.courseData);
  @override
  _RegisterForCourseScreenState createState() =>
      _RegisterForCourseScreenState();
}

class _RegisterForCourseScreenState extends State<RegisterForCourseScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              SizedBox(
                height: screenSize.screenHeight * 10,
              ),
              Container(
                height: screenSize.screenHeight * 20,
                child: SvgPicture.asset('svg/payment.svg',
                    semanticsLabel: 'A red up arrow'),
              ),
              SizedBox(
                height: screenSize.screenHeight * 5,
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Register For This Course",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenSize.screenHeight * 3.5,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 4,
                  ),
                  SizedBox(
                    height: screenSize.screenWidth * 6,
                  ),
                  Center(
                    child: ReusableButton(
                        height: screenSize.screenHeight * 8,
                        width: screenSize.screenWidth * 71,
                        content: "Register",
                        onPress: () {
                          print("registered pressed for course: ");
                          print('${widget.courseData['id']}');
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return CourseRegistrationLoadingScreen(
                                widget.courseData, true);
                          }));
                        }),
                  ),
                  SizedBox(
                    height: screenSize.screenWidth * 10,
                  ),
                ],
              ),
              //)
            ]),
          ),
        ],
      ),
    );
  }
}
