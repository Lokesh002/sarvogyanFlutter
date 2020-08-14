class FilteredCourses_list {
  List<CourseData> courseList = List<CourseData>();
  int noOfCourses = 0;
  String id;
  String name;
  String desc;
  String category;
  String subCategory;
  String teacher;

  FilteredCourses_list(var decodedData, var cat) {
    if (decodedData == null) {
      id = null;
      name = null;

      desc = null;
      category = null;
      subCategory = null;
      teacher = null;
      return;
    }

    List crslist = decodedData;
    noOfCourses = crslist.length;
    print('filtered list length: $noOfCourses');

    for (int i = 0; i < crslist.length; i++) {
      String id = crslist[i]["id"];
      String name = crslist[i]["name"];
      String desc = crslist[i]["description"];

      String category = cat;
      var b = crslist[i]["courseSubcategory"];
      String subCategory = b[0];

      var c = crslist[i]["teacherDetails"];
      String teacherName = c['name'];

      var pic = crslist[i]["picture"];
      var subscription = crslist[i]["subscription"];
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
