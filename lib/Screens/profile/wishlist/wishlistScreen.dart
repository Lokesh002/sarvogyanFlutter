import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sarvogyan/Screens/course/courseSelectedLoadingScreen.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/components/Cards/reusableCourseCard.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/courseListData.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';

import 'package:sarvogyan/lists/course_List.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class WishlistScreen extends StatefulWidget {
  var listofCourses;
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  SavedData savedData = SavedData();

  var veh;
  CourseModel courseModel = CourseModel();
  Course_List clist;
  var cl;
  void getData() async {
    Networking networking = Networking();
    var decodedData = await networking.getDataWithToken(
        'api/user/wishlist', await savedData.getAccessToken());
    print(decodedData);

    clist = Course_List(decodedData);
    //Navigator.pop(context);
    widget.listofCourses = clist.getCourseList();
    cl = widget.listofCourses;
    isReady = true;
    if (mounted) {
      setState(() {});
    }
//    AllCourses(clist.getCourseList());
  }

  getStatus() async {
    signedIn = await savedData.getLoggedIn();
    if (signedIn == null) {
      signedIn = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  String getSubscription(int index) {
    if (cl[index].subscription == 'a')
      return "Basic Course";
    else if (cl[index].subscription == 'b')
      return "Basic Course";
    else if (cl[index].subscription == 'c')
      return "Premium Course";
    else
      return "Invalid Subscription Code";
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getData();
    }
  }

  bool isReady = false;

  SizeConfig screenSize;
  Widget ShowScreen(bool isReady) {
    if (!isReady) {
      return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: SpinKitWanderingCubes(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          size: screenSize.screenHeight * 18,
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            title: Text('My Wishlist'),
          ),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: screenSize.screenHeight * 1,
                ),
                Container(
                  height: screenSize.screenHeight * 80,
                  child: ListView.builder(
                      itemBuilder: (BuildContext cntxt, int index) {
                        return ReusableCourseCard(
                          color: Theme.of(context).accentColor,
                          courseName: veh[index].name,
                          subscription: getSubscription(index),
                          teacher: veh[index].teacher,
                          image: veh[index].picture,
                          onTap: () {
                            setState(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CourseSelectedLoadingScreen(veh[index]);
                              }));
                            });
                          },
                        );
                      },
                      itemCount: veh.length,
                      padding: EdgeInsets.fromLTRB(
                          0,
                          screenSize.screenHeight * 2.5,
                          0,
                          screenSize.screenHeight * 2.5)),
                ),
              ],
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    veh = cl;

    getStatus();

    screenSize = SizeConfig(context);
    return ShowScreen(isReady);
  }
}
