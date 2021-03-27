import 'package:sarvogyan/components/Constants/constants.dart';

class CourseTreeNode {
  String value;

  List<CourseTreeNode> children;
  CourseTreeNode parent;
  CourseTreeNode(String value) {
    this.value = value;
    children = List<CourseTreeNode>();
    parent = null;
  }

  void addChild(CourseTreeNode self, CourseTreeNode child) {
    children.add(child);
    child.parent = self;
  }

  List<CourseTreeNode> getChildren() {
    return this.children;
  }
}

class GetCourseClass {
  void loopAddChild(CourseTreeNode self, List<String> child) {
    for (int i = 0; i < child.length; i++) {
      self.addChild(self, new CourseTreeNode(child[i]));
    }
  }

  CourseTreeNode process() {
    CourseTreeNode sarvogyan = CourseTreeNode("Sarvogyan");
    CourseTreeNode Courses = CourseTreeNode("Courses");
    CourseTreeNode Exams = CourseTreeNode("Exams");
    sarvogyan.addChild(sarvogyan, Courses);
    sarvogyan.addChild(sarvogyan, Exams);
    Courses.addChild(Courses, CourseTreeNode("School"));
    Courses.addChild(Courses, CourseTreeNode("Higher Education"));
    Courses.addChild(Courses, CourseTreeNode("Professional"));
    Courses.addChild(Courses, CourseTreeNode("Vocational Skills"));
    Exams.addChild(Exams, CourseTreeNode("JEE"));
    Exams.addChild(Exams, CourseTreeNode("NEET"));
    Exams.addChild(Exams, CourseTreeNode("CLAT"));
    Exams.addChild(Exams, CourseTreeNode("NDA"));
    Exams.addChild(Exams, CourseTreeNode("UPSC"));
    Exams.addChild(Exams, CourseTreeNode("SSC"));
    Exams.addChild(Exams, CourseTreeNode("GATE"));
    Exams.addChild(Exams, CourseTreeNode("SAT"));
    Exams.addChild(Exams, CourseTreeNode("GMAT"));
    Exams.addChild(Exams, CourseTreeNode("Banking"));
    Exams.addChild(Exams, CourseTreeNode("Teaching"));
    Exams.addChild(Exams, CourseTreeNode("IIT JAM"));

    List<CourseTreeNode> courseChilden = Courses.getChildren();
    loopAddChild(courseChilden[0], schoolChildren);

    //Adding school children
    List<CourseTreeNode> schools = courseChilden[0].children;
    loopAddChild(schools[0], boardChildren1);
    List<CourseTreeNode> CBSEclasses = schools[0].children;
    for (int i = 0; i < CBSEclasses.length; i++) {
      if (i < 4) {
        loopAddChild(CBSEclasses[i], preNurserytoUKGChildren);
      } else if (i < 9) {
        loopAddChild(CBSEclasses[i], Class1toClass5Children);
      } else if (i < 12) {
        loopAddChild(CBSEclasses[i], Class6toClass8Children);
      } else if (i < 14) {
        loopAddChild(CBSEclasses[i], Class9toClass10Children);
      } else if (i < 16) {
        loopAddChild(CBSEclasses[i], Clas11toClass12Children);
      }
    }
    for (int i = 1; i < schools.length; i++) {
      loopAddChild(schools[i], boardChildren2);
      List<CourseTreeNode> otherBoardclasses = schools[i].children;
      for (int i = 0; i < otherBoardclasses.length; i++) {
        if (i < 2) {
          loopAddChild(otherBoardclasses[i], Class6toClass8Children);
        } else if (i < 4) {
          loopAddChild(otherBoardclasses[i], Class9toClass10Children);
        } else if (i < 6) {
          loopAddChild(otherBoardclasses[i], Clas11toClass12Children);
        }
      }
    }

    //Adding Higher Education children

    loopAddChild(courseChilden[1], hEduChildren);

    //Adding Prof children
    loopAddChild(courseChilden[2], profChildren);

    //Adding Vocational children
    loopAddChild(courseChilden[3], vocChildren);

    return sarvogyan;
  }
}
