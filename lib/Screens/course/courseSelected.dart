import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/course/readCourseDocScreen.dart';
import 'package:sarvogyan/Screens/courseVideo/courseVideoScreen.dart';
import 'package:sarvogyan/Screens/profile/subscription/buySubscription.dart';
import 'package:sarvogyan/Screens/course/courseRegistrationLoadingScreen.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/Constants/constants.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/course_List.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/utilities/userData.dart';

class CourseSelected extends StatefulWidget {
  var decodedData;
  var previewData;
  //CourseData courseSelected;
  CourseSelected(this.decodedData, this.previewData);
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
  String teacherPic;
  String getSubscription(String sub) {
    if (sub == 'a')
      return "Free Course";
    else if (sub == 'b')
      return "Basic Course";
    else if (sub == 'c')
      return "Premium Course";
    else
      return "Invalid Subscription Code";
  }

  List<dynamic> wishListIds;
  bool addedToWishList = false;
  void inWishList() async {
    String uId = await savedData.getUserId();
    print('uid' + uId.toString());
    wishListIds = widget.decodedData['wishlist'];
    for (int i = 0; i < wishListIds.length; i++) {
      if (uId == wishListIds[i]) {
        setState(() {
          addedToWishList = true;
        });
      }
    }
  }

  getDetails() {
    print("get details");
    log(widget.decodedData.toString());
    log(widget.previewData.toString());
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
        picture = 'images/media/logo.png';
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
      if (widget.decodedData["teacherDetails"]["picture"] != null) {
        teacherPic = widget.decodedData["teacherDetails"]["picture"];
      } else {
        teacherPic = '';
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
      picture = 'images/media/logo.png';
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
      inWishList();
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
      } else if (widget.decodedData['subscription'] == 'c') {
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

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    getDetails();
    SizeConfig screenSize = SizeConfig(context);
    final x = screenSize.screenHeight * 50;
    print(name);

    return WillPopScope(
      onWillPop: () async {
        log('hello brother');
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(''),
              GestureDetector(
                onTap: () async {
                  Networking networking = Networking();
                  var decData = await networking.postDataByUser(
                      'api/user/wishlist',
                      {'course_id': widget.decodedData['id']},
                      await savedData.getAccessToken());
                  log(decData.toString());
                  setState(() {
                    if (addedToWishList)
                      setState(() {
                        addedToWishList = false;
                        Fluttertoast.showToast(msg: 'Removed from Wishlist');
                      });
                    else
                      setState(() {
                        addedToWishList = true;
                        Fluttertoast.showToast(msg: 'Added to Wishlist');
                      });
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(screenSize.screenHeight * 3),
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 1),
                  ),
                  height: screenSize.screenHeight * 5,
                  width: addedToWishList
                      ? screenSize.screenWidth * 40
                      : screenSize.screenWidth * 30,
                  child: Material(
                    borderRadius:
                        BorderRadius.circular(screenSize.screenHeight * 3),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.screenWidth * 1),
                      child: addedToWishList
                          ? Center(
                              child: Text(
                                'Remove from Wishlist',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.screenHeight * 1.6),
                              ),
                            )
                          : Center(
                              child: Text(
                                'Add to wishlist',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: screenSize.screenHeight * 1.6),
                              ),
                            ),
                    ),
                    color: addedToWishList ? Colors.grey : Colors.white,
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
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
                        Container(
                          width: screenSize.screenWidth * 50,
                          child: Padding(
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  screenSize.screenWidth * 2,
                                              vertical:
                                                  screenSize.screenHeight),
                                          child: Text(
                                            '$totalParts Lectures',
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    screenSize.screenHeight * 2,
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
                                      child: ClipOval(
                                        child: SizedBox(
                                          child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  'images/media/logo.png',
                                              image: teacherPic),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              screenSize.screenWidth * 2),
                                      child: Text(
                                        'Prof. $teacherName',
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto"),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: screenSize.screenWidth * 50,
                          child: Padding(
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
                                          bool login =
                                              await savedData.getLoggedIn();
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
                                            previewData = widget.previewData;
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
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
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 3,
                  ),
                  Container(
                    width: screenSize.screenWidth * 100,
                    height: screenSize.screenHeight * 50,
                    child: ListView(
                      children: [
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
                                  height: screenSize.screenHeight * 6,
                                  width: screenSize.screenWidth * 90,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "About the Course",
                                        softWrap: true,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              screenSize.screenHeight * 3.5,
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: screenSize.screenHeight * 2,
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
                        widget.previewData.length > 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.screenWidth * 5),
                                child: Text(
                                  "Preview",
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenSize.screenHeight * 3.5,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Container(
                          alignment: Alignment.center,
                          height: screenSize.screenHeight * 30,
                          width: screenSize.screenWidth * 100,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: screenSize.screenWidth * 2.5,
                                right: screenSize.screenWidth * 2.5),
                            child: ListView.builder(
                                controller: scrollController,
                                //shrinkWrap: true,
                                itemBuilder: (BuildContext cntxt, int index) {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: screenSize.screenWidth * 2.5,
                                          right: screenSize.screenWidth * 2.5),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (widget.previewData[index]
                                                  ['type'] !=
                                              'text') {
                                            print(widget.previewData[index]
                                                    ['content']
                                                .toString());
                                            String link = widget
                                                .previewData[index]['content']
                                                .toString();
                                            link = link.substring(
                                                link.indexOf('embed/') + 6);
                                            print(link);

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return CourseVideoScreen(
                                                  id: link,
                                                  name: name,
                                                  desc: desc,
                                                  previewData:
                                                      widget.previewData);
                                            }));
                                          } else {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ReadCourseDocScreen(
                                                  widget.previewData[index]
                                                      ['content'],
                                                  widget.previewData[index]
                                                      ['name']);
                                            }));
                                          }
                                        },
                                        child: Material(
                                          borderRadius: BorderRadius.circular(
                                              screenSize.screenHeight * 2),
                                          color: Colors.white,
                                          elevation: 3,
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: screenSize.screenWidth * 30,
                                            height:
                                                screenSize.screenHeight * 22,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  child: Icon(
                                                    widget.previewData[index]
                                                                ['type'] !=
                                                            'text'
                                                        ? Icons.personal_video
                                                        : Icons.description,
                                                    size: screenSize
                                                            .screenHeight *
                                                        6,
                                                    color: Colors.white,
                                                  ),
                                                  backgroundColor:
                                                      ColorList[index % 4],
                                                  radius:
                                                      screenSize.screenHeight *
                                                          4,
                                                ),
                                                Container(
                                                  height:
                                                      screenSize.screenHeight *
                                                          13,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: screenSize
                                                                .screenHeight *
                                                            1,
                                                        horizontal: screenSize
                                                                .screenWidth *
                                                            2),
                                                    child: Text(
                                                      widget.previewData[index]
                                                          ['name'],
                                                      overflow:
                                                          TextOverflow.clip,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.previewData.length,
                                padding: EdgeInsets.fromLTRB(
                                    0,
                                    screenSize.screenHeight * 1,
                                    0,
                                    screenSize.screenHeight * 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
