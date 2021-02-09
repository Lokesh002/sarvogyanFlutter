import 'package:sarvogyan/components/Networking/networking.dart';

class GetAllExams {
  Future<List<Exam>> getExamList(String query) async {
    List<Exam> examList = List<Exam>();
    Networking networking = Networking();
    var exams = await networking
        .postData("api/search/searchExam", {"searchQuery": query.trimRight()});
    List data = exams;
    print('exams');
    print(exams);
    if (exams != null) {
      print(data);
      print(" length: ${data.length}");
      for (int i = 0; i < data.length; i++) {
        print(i);

        Exam exam = Exam();
        exam.examId = data[i]['id'];
        exam.examName = data[i]['examName'];
        print("Exam: ");
        print(exam.examName);
        exam.examDescription = data[i]['examDescription'];
        exam.examTime = data[i]['examTime'];
        exam.examPicture = data[i]['examPicture'];
        exam.totalQuestions = data[i]['totalQuestions'].toString();
        List categ = data[i]['courseCategory'];
        for (int j = 0; j < categ.length; j++) {
          exam.courseCategory.add(categ[j]);
        }
        List subcateg = data[i]['courseSubCategory'];
        for (int j = 0; j < subcateg.length; j++) {
          exam.courseCategory.add(subcateg[j]);
        }
        examList.add(exam);
      }
    }

    return examList;
  }
}

class Exam {
  String examId;
  String examName;
  String examDescription;
  String examPicture;
  int examTime;
  String totalQuestions;
  List<String> courseCategory = List<String>();
  List<String> courseSubCategory = List<String>();
}
