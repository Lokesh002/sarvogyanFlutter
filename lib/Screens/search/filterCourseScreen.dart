import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sarvogyan/Screens/course/courseSelectedLoadingScreen.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sarvogyan/components/Cards/ReusableCard.dart';
import 'package:sarvogyan/components/courseListData.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/components/Cards/reusableCourseCard.dart';
import 'package:sarvogyan/lists/colorList.dart';
import 'package:sarvogyan/lists/course_List.dart';
import 'package:sarvogyan/Screens/course/courseSelected.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/lists/filteredCourses_List.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/components/filteredListNetworking.dart';

class FilterCourseScreen extends StatefulWidget {
  var listofCourses;
  List<String> categoryList;
  FilterCourseScreen(this.listofCourses, this.categoryList);

  @override
  _FilterCourseScreenState createState() => _FilterCourseScreenState();
}

class _FilterCourseScreenState extends State<FilterCourseScreen> {
  var veh;
  bool load = false;
  SavedData savedData = SavedData();
  bool signedIn = false;
  String selectedCourse;
  FilteredCourses_list filteredCourses_list;
  FilteredListNetworking filteredListNetworking;

  getStatus() async {
    signedIn = await savedData.getLoggedIn();
    if (signedIn == null) {
      signedIn = false;
    }
    setState(() {});
  }

  Widget getList(bool loading, SizeConfig screenSize) {
    if (loading)
      return SpinKitWanderingCubes(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
        size: 90.0,
      );
    else {
      return ListView.builder(
          itemBuilder: (BuildContext cntxt, int index) {
            return ReusableCourseCard(
              courseName: veh[index].name,
              subscription: getSubscription(index),
              teacher: veh[index].teacher,
              color: Colors.white,
              image: veh[index].picture,
              onTap: () {
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CourseSelectedLoadingScreen(veh[index].id);
                  }));
                });
              },
            );
          },
          itemCount: veh.length,
          padding: EdgeInsets.fromLTRB(0, screenSize.screenHeight * 2.5, 0,
              screenSize.screenHeight * 15));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    veh = widget.listofCourses;
    setState(() {});
  }

  List<DropdownMenuItem> getCategList() {
    List<DropdownMenuItem<String>> manufacturer_List = [];
    for (int i = 0; i < widget.categoryList.length; i++) {
      var item = DropdownMenuItem(
        child: Text(widget.categoryList[i]),
        value: widget.categoryList[i],
      );
      manufacturer_List.add(item);
    }

    return manufacturer_List;
  }

  String getSubscription(int index) {
    if (widget.listofCourses[index].subscription == 'a')
      return "Free Course";
    else if (widget.listofCourses[index].subscription == 'b')
      return "Basic Course";
    else if (widget.listofCourses[index].subscription == 'c')
      return "Premium Course";
    else
      return "Invalid Subscription Code";
  }

  @override
  Widget build(BuildContext context) {
    getStatus();
    SizeConfig screenSize = SizeConfig(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Material(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(screenSize.screenHeight * 2),
              ),
              elevation: 5,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: screenSize.screenHeight * 7,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: screenSize.screenWidth * 5,
                      ),
                      Text(
                        "Filter Courses",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenSize.screenHeight * 3,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: screenSize.screenWidth * 5,
                      ),

//                      GestureDetector(
//                        onTap: () {},
//                        child: Icon(
//                          Icons.arrow_drop_down_circle,
//                          size: screenSize.screenHeight * 3,
//                          color: Theme.of(context).primaryColor,
//                        ),
//                      )
                    ],
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 1.7,
                  ),
                  Container(
                      child: Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(screenSize.screenHeight * 1),
                    ),
                    child: Center(
                        child: DropdownButton(
                      elevation: 7,
                      isExpanded: false,
                      hint: Text('Choose',
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                      value: selectedCourse,
                      items: getCategList(),
                      onChanged: (value) async {
                        setState(() {
                          load = true;
                        });
                        selectedCourse = value;
                        print('selected1: $selectedCourse');
                        filteredListNetworking =
                            FilteredListNetworking(selectedCourse);
                        var decodedData =
                            await filteredListNetworking.postData();
                        filteredCourses_list =
                            FilteredCourses_list(decodedData, selectedCourse);
                        print(veh);
                        veh = filteredCourses_list.getCourseList();

                        setState(() {
                          load = false;
                        });
                      },
                    )),
                  )),
                ],
              ),
            ),
            Container(
                height: screenSize.screenHeight * 83,
                child: getList(load, screenSize)),
            SizedBox(
              height: screenSize.screenHeight * 1,
            ),
          ],
        ),
      ),
    );
  }
}
