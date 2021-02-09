import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sarvogyan/Screens/course/courseSelectedLoadingScreen.dart';
import 'package:sarvogyan/components/Cards/reusableCourseCard.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/course_List.dart';

class SearchCourse extends StatefulWidget {
  @override
  _SearchCourseState createState() => _SearchCourseState();
}

class _SearchCourseState extends State<SearchCourse> {
  SizeConfig screenSize;
  var _formKey = new GlobalKey<FormState>();
  var searchController = TextEditingController();
  String query;
  @override
  void dispose() {
    visible = false;
    searchController.clear();
    searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool visible = false;
  bool isReady = false;
  List<CourseData> listofCourses = List<CourseData>();
  getCourses() async {
    Networking networking = Networking();
    var courses = await networking.postData("api/search/searchCourse",
        {"searchQuery": query.trimLeft().trimRight()});
    print("hefh");
    print(courses);
    if (courses != null) {
      var clist = Course_List(courses);
      //Navigator.pop(context);
      listofCourses = clist.getCourseList();
    } else {
      listofCourses = [];
    }
    isReady = true;
    if (mounted) {
      setState(() {});
    }
  }

  String getSubscription(int index) {
    if (listofCourses[index].subscription == 'a')
      return "Free Course";
    else if (listofCourses[index].subscription == 'b')
      return "Basic Course";
    else if (listofCourses[index].subscription == 'c')
      return "Premium Course";
    else
      return "Invalid Subscription Code";
  }

  Widget getScreen() {
    if (!isReady) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenSize.screenHeight * 30),
            child: SpinKitWanderingCubes(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              size: 100.0,
            ),
          ),
        ],
      );
    } else {
      return listofCourses.length == 0
          ? Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: screenSize.screenHeight * 10,
                  ),
                  Container(
                    height: screenSize.screenHeight * 20,
                    child: SvgPicture.asset('svg/noCourses.svg',
                        semanticsLabel: 'A red up arrow'),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 5,
                  ),
                  Text(
                    "No Courses Present",
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 20,
                  ),
                ],
              ),
            )
          : Container(
              height: screenSize.screenHeight * 67,
              child: ListView.builder(
                  itemBuilder: (BuildContext cntxt, int index) {
                    return ReusableCourseCard(
                      color: Theme.of(context).accentColor,
                      courseName: listofCourses[index].name,
                      subscription: getSubscription(index),
                      teacher: listofCourses[index].teacher,
                      image: listofCourses[index].picture,
                      onTap: () {
                        setState(() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CourseSelectedLoadingScreen(
                                listofCourses[index]);
                          }));
                        });
                      },
                    );
                  },
                  itemCount: listofCourses.length,
                  padding: EdgeInsets.fromLTRB(0, screenSize.screenHeight * 2.5,
                      0, screenSize.screenHeight * 2.5)),
            );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isReady = true;
    visible = false;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.screenWidth * 2,
                    vertical: screenSize.screenHeight * 2),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 5,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter query first.' : null,
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    onChanged: (query) {
                      this.query = query;
                      print(this.query);
                    },
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: screenSize.screenHeight * 2),
                    // focusNode: focusNode,

                    decoration: InputDecoration(
                      hintText: "Search Courses",
                      suffixIcon: GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isReady = false;
                                visible = true;
                              });
                              getCourses();
                            }
                          },
                          child: Icon(Icons.search)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              screenSize.screenHeight * 2)),
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Visibility(visible: visible, child: getScreen()),
            ],
          ),
        ),
      ),
    );
  }
}
