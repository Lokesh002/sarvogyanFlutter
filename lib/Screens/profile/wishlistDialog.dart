import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sarvogyan/Screens/course/courseSelectedLoadingScreen.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/components/Cards/reusableCourseDialogCard.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/courseListData.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';

import 'package:sarvogyan/lists/course_List.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WishlistDialog extends StatefulWidget {
  var listofCourses;
  @override
  _WishlistDialogState createState() => _WishlistDialogState();
}

class _WishlistDialogState extends State<WishlistDialog> {
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
      return "Free Course";
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWanderingCubes(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              size: screenSize.screenHeight * 10,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: screenSize.screenHeight * 5),
              child: Text('Loading....'),
            ),
          ],
        ),
      );
    } else if (veh.length != 0) {
      return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: screenSize.screenHeight * 1,
                ),
                Container(
                  height: screenSize.screenHeight * 67,
                  child: ListView.builder(
                      itemBuilder: (BuildContext cntxt, int index) {
                        return ReusableCourseDialogCard(
                          color: Theme.of(context).accentColor,
                          courseName: veh[index].name,
                          subscription: getSubscription(index),
                          teacher: veh[index].teacher,
                          image: veh[index].picture,
                          onTap: () {
                            setState(() {
                              Navigator.pushReplacement(context,
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
    } else {
      return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: screenSize.screenHeight * 10,
                ),
                Container(
                  height: screenSize.screenHeight * 15,
                  child: SvgPicture.asset('svg/noCourses.svg',
                      semanticsLabel: 'A red up arrow'),
                ),
                SizedBox(
                  height: screenSize.screenHeight * 5,
                ),
                Center(
                  child: Text(
                    "You have not wishlisted to any course. To add to wishlist, tap on 'Add To Wishlist' in course description page.",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: screenSize.screenHeight * 15,
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
