import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/profile/addMoney/MakePaymentScreen.dart';
import 'package:sarvogyan/Screens/course/courseViewScreen.dart';
import 'package:sarvogyan/Screens/course/registerForCourse.dart';
import 'package:sarvogyan/components/verifyIsUserRegistered.dart';
import 'package:sarvogyan/components/registerForCourseNetworking.dart';
import 'package:sarvogyan/components/fetchLessonsData.dart';
import 'package:sarvogyan/lists/course_List.dart';

class CourseRegistrationLoadingScreen extends StatefulWidget {
  bool fromRegistrationScreen;
  var courseData;

  CourseRegistrationLoadingScreen(this.courseData, this.fromRegistrationScreen);
  @override
  _CourseRegistrationLoadingScreenState createState() =>
      _CourseRegistrationLoadingScreenState();
}

class _CourseRegistrationLoadingScreenState
    extends State<CourseRegistrationLoadingScreen> {
  FetchLessons fetchLessons;
  List<Lessons> listOfLessons;
  RegisterForCourseNetworking registerForCourseNetworking;
  String regStatus;
  void register() async {
    registerForCourseNetworking =
        RegisterForCourseNetworking(widget.courseData);
    print("going to register function");
    regStatus = await registerForCourseNetworking.register();
    Fluttertoast.showToast(msg: regStatus);
    if (regStatus == "Registered") {
      print("registered success");
      print('getting lessons');
      getLessons();
    } else if (regStatus == "Please add money") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MakePaymentScreen();
      })).then((value) {
        if (value) {
          register();
          Fluttertoast.showToast(msg: "Money Added");
        } else {
          Navigator.pop(context);
        }
      });
    } else {
      Navigator.pop(context);
    }
  }

  void getLessons() async {
    fetchLessons = FetchLessons(widget.courseData);
    listOfLessons = await fetchLessons.fetch();
    Fluttertoast.showToast(msg: "All lessons loaded");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return CourseViewScreen(widget.courseData, listOfLessons);
    }));
  }

  void verifyUserRegistration() async {
    bool verify = false;
    print("inside verifyUserRegistration function");
    VerifyIsUserRegistered verifyIsUserRegistered =
        VerifyIsUserRegistered(widget.courseData);
    verify = await verifyIsUserRegistered.getVerificationStatus();
    print('course verified status' + verify.toString());
    if (!verify) {
      print('going to register for course screen');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return RegisterForCourseScreen(widget.courseData);
      }));
    } else {
      print('getting lessons');
      getLessons();
    }
  }

  @override
  void initState() {
    super.initState();
    print('RegisterForCourseLoading started');
    if (widget.fromRegistrationScreen == false) {
      print("cming from courseSelected");
      verifyUserRegistration();
    } else {
      print("coming from RegisterCourseScreen");
      register();
    }
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
