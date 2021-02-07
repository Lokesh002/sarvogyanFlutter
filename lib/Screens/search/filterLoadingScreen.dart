import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sarvogyan/Screens/search/filterCourseScreen.dart';
import 'package:sarvogyan/lists/course_List.dart';
import 'package:sarvogyan/components/courseListData.dart';
import 'package:sarvogyan/lists/allCategory_list.dart';

class FilterLoadingScreen extends StatefulWidget {
//  String selectedCourse;
//  FilterLoadingScreen(this.selectedCourse);
  @override
  _FilterLoadingScreenState createState() => _FilterLoadingScreenState();
}

class _FilterLoadingScreenState extends State<FilterLoadingScreen> {
  CourseModel courseModel = CourseModel();
  AllCategoryList clist;
  Course_List clst;
  void getListData() async {
    var decodedCourseData = await courseModel.getAllCourses();
    clst = Course_List(decodedCourseData);

    var decodedData = await courseModel.getAllCategories();
    print("response: ");
    debugPrint(decodedData);
    clist = AllCategoryList(decodedData);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return FilterCourseScreen(clst.getCourseList(), clist.getCategoryList());
    }));
  }

  @override
  void initState() {
    super.initState();
    getListData();
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
