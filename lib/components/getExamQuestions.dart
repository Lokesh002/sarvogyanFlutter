import 'package:sarvogyan/components/Networking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:sarvogyan/utilities/sharedPref.dart';

class GetExamQuestions {
  String url =
      "https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/exam/getQuestions/";
  String examId;
  GetExamQuestions(this.examId);
  SavedData savedData = SavedData();

  Future<List<Question>> getQuestions() async {
    String authAccessToken = await savedData.getAccessToken();
    print(examId);
    List<Question> questionList = List<Question>();
    http.Response response = await http.get('$url$examId', headers: {
      "Content-Type": "application/json",
      "x-auth-token": authAccessToken
    });
    if (response.statusCode == 200) {
      var decodedData = await convert.jsonDecode(response.body);
      Map data = decodedData;
      print("map: " + data.toString());
      for (int i = 0; i < data.length; i++) {
        Question question = Question();
        String a = (i + 1).toString();
        print(decodedData);
        question.questionNo = a;
        try {
          question.questiontype = decodedData[a]['questionType'].toString();
        } catch (e) {
          question.questiontype = null;
          print(e);
        }
        if (question.questiontype != null) {
          question.link = decodedData[a]['link'].toString();
        } else {
          question.link = null;
        }

        question.question = decodedData[a]['question'].toString();
        question.option1 = decodedData[a]['option1'].toString();
        question.option2 = decodedData[a]['option2'].toString();
        question.option3 = decodedData[a]['option3'].toString();
        question.option4 = decodedData[a]['option4'].toString();
        List ans = decodedData[a]['answer'];
        question.answer = ans;
        questionList.add(question);
        print(questionList[0].questionNo);
      }
    } else {
      print("error");
      print(response.statusCode);
      print(convert.jsonDecode(response.body));
    }
    return questionList;
  }
}

class Question {
  String questionNo;
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String questiontype;
  String link;
  List<dynamic> answer = List<dynamic>();
}
