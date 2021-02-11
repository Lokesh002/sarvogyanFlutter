import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/profile/subscription/buySubscription.dart';
import 'package:sarvogyan/Screens/course/courseRegistrationLoadingScreen.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/course_List.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/utilities/userData.dart';

class CourseSelected extends StatefulWidget {
  var decodedData;
  //CourseData courseSelected;
  CourseSelected(this.decodedData);
  @override
  _CourseSelectedState createState() => _CourseSelectedState();
}

class _CourseSelectedState extends State<CourseSelected> {
  bool isCourseRegistered = false;
  String name = '';
  String picture;
  String teacherName = '';
  String desc = '';
  String cost = '';
  String subscription = '';
  Widget pic;
  String totalParts;
  String getSubscription(String sub) {
    if (sub == 'a')
      return "Basic Course";
    else if (sub == 'b')
      return "Basic Course";
    else if (sub == 'c')
      return "Premium Course";
    else
      return "Invalid Subscription Code";
  }

  getDetails() {
    print("get details");
    print(widget.decodedData);
    if (widget.decodedData != null) {
      print("get fr details");

      if (widget.decodedData["name"] != null) {
        name = widget.decodedData["name"];
      } else {
        name = '';
      }

      if (widget.decodedData["picture"] != null) {
        picture = widget.decodedData["picture"];
        pic = Image.network(picture);
      } else {
        picture = 'images/logo.png';
        pic = Image.asset(picture);
      }
      if (widget.decodedData["totalParts"] != null) {
        totalParts = widget.decodedData["totalParts"].toString();
      } else {
        totalParts = "N.A.";
      }
      if (widget.decodedData["teacherDetails"]["name"] != null) {
        teacherName = widget.decodedData["teacherDetails"]["name"];
      } else {
        teacherName = '';
      }
      if (widget.decodedData["description"] != null) {
        desc = widget.decodedData["description"];
      } else {
        desc = '';
      }
      if (widget.decodedData["cost"] != null) {
        cost = widget.decodedData["cost"].toString();
      } else {
        cost = '0';
      }
      if (widget.decodedData["subscription"] != null) {
        subscription = getSubscription(widget.decodedData["subscription"]);
      } else {
        subscription = 'No Subscription Code';
      }
    } else {
      print("get tg  details");

      name = 'Course Not Approved';
      picture = 'images/logo.png';
      pic = Image.asset(picture);
      teacherName = '';
      desc = '';
      cost = '0';
    }
  }

  SavedData savedData = SavedData();
  verifyUserRegistration() async {
    bool li = await savedData.getLoggedIn();
    if (li) {
      List<String> courses = [];
      courses = await savedData.getCourses();

      print(widget.decodedData['id']);
      print(courses);
      if (courses.contains(widget.decodedData['id'])) {
        isCourseRegistered = true;
      } else {
        isCourseRegistered = false;
      }

      setState(() {});
    }
  }

  Future<bool> canEnter() async {
    String subLevel = await savedData.getUserSubsLevel();
    print(subLevel);
    print(widget.decodedData["subscription"]);
    if (subLevel == widget.decodedData["subscription"]) {
      return true;
    } else {
      if (subLevel == 'b' && widget.decodedData["subscription"] == 'a') {
        return true;
      } else {
        if (subLevel == 'c' &&
            (widget.decodedData["subscription"] == 'b' ||
                widget.decodedData["subscription"] == 'a')) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyUserRegistration();
  }

  @override
  Widget build(BuildContext context) {
    getDetails();
    SizeConfig screenSize = SizeConfig(context);
    final x = screenSize.screenHeight * 50;
    print(name);
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Color(0xffeee9e9),
                width: screenSize.screenWidth * 100,
                height: screenSize.screenHeight * 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.screenWidth * 5,
                          vertical: screenSize.screenHeight * 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                softWrap: true,
                                style: TextStyle(
                                  color: Color(0xffff6714),
                                  fontSize: screenSize.screenHeight * 3.5,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.screen_lock_landscape,
                                    color: Color(0xffff6714),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '$totalParts Lectures',
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenSize.screenHeight * 2,
                                          fontFamily: "Roboto"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.black26,
                                radius: screenSize.screenHeight * 2,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.screenWidth * 2),
                                child: Text(
                                  'Prof. $teacherName',
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenSize.screenHeight * 2,
                                      fontFamily: "Roboto"),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.screenWidth * 5,
                          vertical: screenSize.screenHeight * 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: screenSize.screenWidth * 30,
                              height: screenSize.screenHeight * 20,
                              child: pic),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: isCourseRegistered
                                      ? screenSize.screenHeight * 1
                                      : screenSize.screenHeight * 1),
                              child: ReusableButton(
                                  onPress: () async {
                                    bool login = await savedData.getLoggedIn();
                                    print(login);
                                    if (login == null) {
                                      login = false;
                                    }
                                    print(login);
                                    if (login) {
                                      print(subscription);
                                      bool x = await canEnter();
                                      print("helo" + x.toString());
                                      if (x) {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CourseRegistrationLoadingScreen(
                                              widget.decodedData, false);
                                        }));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please increase subscription level");
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return BuySubscription();
                                        }));
                                      }
                                    } else {
                                      DecodedData = widget.decodedData;
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Login(false);
                                      }));
                                    }
                                  },
                                  content: "Enter Course",
                                  height: screenSize.screenHeight * 7,
                                  width: screenSize.screenWidth * 20),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.screenHeight * 3,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: screenSize.screenWidth * 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: screenSize.screenHeight * 5,
                        width: screenSize.screenWidth * 90,
                        child: Text(
                          "About the Course",
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenSize.screenHeight * 3.5,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.screenHeight * 1,
                      ),
                      Container(
                        height: screenSize.screenHeight * 5,
                        width: screenSize.screenWidth * 90,
                        child: Text(
                          desc,
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenSize.screenHeight * 2,
                              fontFamily: "Roboto"),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.screenHeight * 1,
                      ),
                      Visibility(
                        visible: !isCourseRegistered,
                        child: Container(
                          height: screenSize.screenHeight * 5,
                          width: screenSize.screenWidth * 90,
                          child: Text(
                            subscription,
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenSize.screenHeight * 2,
                                fontFamily: "Roboto"),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}