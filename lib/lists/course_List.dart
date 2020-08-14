import 'dart:math';

class Course_List {
  List<CourseData> courseList = new List<CourseData>();
  int noOfCourses = 0;
  String id;
  String name;
  String desc;
  String category;
  String subCategory;
  String teacher;
  String picture;
  Course_List(var decodedData) {
    if (decodedData == null) {
      id = null;
      name = null;

      desc = null;
      category = null;
      subCategory = null;
      teacher = null;
      picture = null;
      return;
    }

    List crslist = decodedData;
    noOfCourses = crslist.length;
    print('list length: $noOfCourses');
    //for (var data in decodedData) {
    for (int i = 0; i < crslist.length; i++) {
      String id = crslist[i]["id"];
      String name = crslist[i]["name"];
      String desc = crslist[i]["description"];
      List a = crslist[i]["courseCategory"];
      String pic = crslist[i]["picture"];

      String category;
      String subCategory;
      print(a);
      if (a.isNotEmpty) {
        print(a[0]);
        category = a[0];
      } else {
        category = null;
      }
      List b = crslist[i]["courseSubcategory"];
      if (b != null) {
        if (b.isNotEmpty) {
          print('hello: ${b[0]}');
          subCategory = b[0];
        } else {
          subCategory = null;
        }
      } else {
        subCategory = null;
      }
      var teacher = crslist[i]["teacherDetails"];
      String teacherName = teacher["name"];

      var subscription = crslist[i]["subscription"];
      if (subscription == null) {
        subscription = "wrong";
      }
      print("subscription: " + subscription);
      this.courseList.add(CourseData(id, name, desc, category, subCategory,
          teacherName, pic, subscription));
    }
  }

  List<CourseData> getCourseList() {
    return courseList;
  }
}

class CourseData {
  String id;
  String name;
  String desc;
  String category;
  String subCategory;
  String teacher;
  String picture;
  String subscription;

  CourseData(this.id, this.name, this.desc, this.category, this.subCategory,
      this.teacher, this.picture, this.subscription);
  CourseData.empty();
}
