import 'package:sarvogyan/components/Networking.dart';

class GetAllExams {
  String url =
      "https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/exam/getAllExams";

  Future<List<Exam>> getExamList() async {
    List<Exam> examList = List<Exam>();
    Networking networking = Networking(url);
    var decodedData = await networking.getData();
    List data = decodedData;
    print(data);
    print(" length: ${data.length}");
    for (int i = 0; i < data.length; i++) {
      print(i);

      Exam exam = Exam();
      exam.examId = data[i]['examId'];
      exam.examName = data[i]['examName'];
      print("Exam: ");
      print(exam.examName);
      exam.examDescription = data[i]['examDescription'];
      exam.examTime = data[i]['examTime'];
      exam.examType = data[i]['examType'];
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
    return examList;
  }
}

class Exam {
  String examId;
  String examName;
  String examDescription;
  String examType;
  int examTime;
  String totalQuestions;
  List<String> courseCategory = List<String>();
  List<String> courseSubCategory = List<String>();
}
